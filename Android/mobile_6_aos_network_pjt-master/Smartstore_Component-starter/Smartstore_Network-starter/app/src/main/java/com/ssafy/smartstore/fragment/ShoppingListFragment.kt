package com.ssafy.smartstore.fragment

import android.app.AlertDialog
import android.app.Dialog
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.nfc.NdefMessage
import android.nfc.NfcAdapter
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.ImageView
import android.widget.TextView
import android.widget.Toast
import androidx.core.content.ContextCompat
import androidx.fragment.app.Fragment
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.ssafy.smartstore.R
import com.ssafy.smartstore.activity.MainActivity
import com.ssafy.smartstore.adapter.ShoppingListAdapter
import com.ssafy.smartstore.config.ApplicationClass
import com.ssafy.smartstore.dto.Order
import com.ssafy.smartstore.dto.OrderDetail
import com.ssafy.smartstore.dto.ShoppingCart
import com.ssafy.smartstore.service.OrderService
import com.ssafy.smartstore.util.CommonUtils
import com.ssafy.smartstore.util.RetrofitCallback
import org.w3c.dom.Text
import kotlin.math.log

//장바구니 Fragment
private const val TAG = "ShoppingListF_싸피"
class ShoppingListFragment(val shoppingCarList: MutableList<ShoppingCart>) : Fragment(){
    private lateinit var shoppingListRecyclerView: RecyclerView
    private var shoppingListAdapter : ShoppingListAdapter? = ShoppingListAdapter(shoppingCarList)
    private lateinit var mainActivity: MainActivity
    private lateinit var btnShop : Button
    private lateinit var btnTakeout : Button
    private lateinit var btnOrder : Button
    private var isShop : Boolean = true

//   private lateinit var builder: AlertDialog.Builder
    var isChk = false


//    var nfcAdapter: NfcAdapter? = null
//    var pIntent: PendingIntent? = null
//    lateinit var filters: Array<IntentFilter>

    override fun onAttach(context: Context) {
        super.onAttach(context)
        mainActivity = context as MainActivity
    }
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        mainActivity.hideBottomNav(true)
    }

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val view = inflater.inflate(R.layout.fragment_shopping_list,null)
        shoppingListRecyclerView =view.findViewById(R.id.recyclerViewShoppingList)
        btnShop = view.findViewById(R.id.btnShop)
        btnTakeout = view.findViewById(R.id.btnTakeout)
        btnOrder = view.findViewById(R.id.btnOrder)
        return view
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

//        builder = AlertDialog.Builder(requireContext())

        shoppingListAdapter = ShoppingListAdapter(shoppingCarList)
        shoppingListAdapter!!.deleteButtonClick = object : ShoppingListAdapter.DeleteButtonClick{
            override fun onClick(shoppingCart: ShoppingCart) {
                shoppingCarList.remove(shoppingCart)
                shoppingListAdapter!!.notifyDataSetChanged()
                displaySummary()
            }
        }
        shoppingListRecyclerView.apply {
            val linearLayoutManager = LinearLayoutManager(context)
            linearLayoutManager.orientation = LinearLayoutManager.VERTICAL
            layoutManager = linearLayoutManager
            adapter = shoppingListAdapter
            //원래의 목록위치로 돌아오게함
            adapter!!.stateRestorationPolicy =
                RecyclerView.Adapter.StateRestorationPolicy.PREVENT_WHEN_EMPTY
        }

        displaySummary()

        btnShop.setOnClickListener {
            btnShop.background = ContextCompat.getDrawable(requireContext(), R.drawable.button_color)
            btnTakeout.background = ContextCompat.getDrawable(requireContext(), R.drawable.button_non_color)
            isShop = true
        }
        btnTakeout.setOnClickListener {
            btnTakeout.background = ContextCompat.getDrawable(requireContext(), R.drawable.button_color)
            btnShop.background = ContextCompat.getDrawable(requireContext(), R.drawable.button_non_color)
            isShop = false
        }
        btnOrder.setOnClickListener {
            if(isShop) {
                enableNfc()
                showDialogForOrderInShop()
            }
            else {
                //거리가 200이상이라면
                if(true) showDialogForOrderTakeoutOver200m()
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        mainActivity.hideBottomNav(false)
    }

    private fun showDialogForOrderInShop() {
        val builder: AlertDialog.Builder = AlertDialog.Builder(requireContext())
        builder.setTitle("알림")
        builder.setMessage(
            "Table NFC를 찍어주세요.\n"
        )
        builder.setCancelable(true)
        builder.setNegativeButton("취소"
        ) { dialog, _ ->
//            completedOrder()
            if(ApplicationClass.sharedPreferencesUtil.getOrderTable().equals("x")) {   // NFC 태깅해서 테이블 데이터가 있으면
                Toast.makeText(requireContext(), "Table NFC를 찍어주세요.", Toast.LENGTH_SHORT).show()
            } else {
                Log.d(TAG, "showDialogForOrderInShop: ${ApplicationClass.sharedPreferencesUtil.getOrderTable()}")
                isChk = true
                makeOrderDto()
            }
            dialog.cancel()
        }
        builder.create().show()
    }

    private fun showDialogForOrderTakeoutOver200m() {
        val builder: AlertDialog.Builder = AlertDialog.Builder(requireContext())
        builder.setTitle("알림")
        builder.setMessage(
            "현재 고객님의 위치가 매장과 200m 이상 떨어져 있습니다.\n정말 주문하시겠습니까?"
        )
        builder.setCancelable(true)
        builder.setPositiveButton("확인") { _, _ ->
//            completedOrder()
            makeOrderDto()
        }
        builder.setNegativeButton("취소"
        ) { dialog, _ -> dialog.cancel() }
        builder.create().show()
    }

    private fun completedOrder(order: Order){
//        var orderTable = mainActivity.orderTable!!
//        if(orderTable.contains("order_table")) {   // 데이터가 있으면
//            isChk = true
//        }
        if (isShop && isChk) {
            val orderTable = ApplicationClass.sharedPreferencesUtil.getOrderTable()!!
            order.orderTable = orderTable
            Toast.makeText(context, "${orderTable.substring(orderTable.length - 2, orderTable.length)}번 테이블 번호가 등록되었습니다.", Toast.LENGTH_SHORT).show()
        } else {
            order.orderTable = "take-out"
        }

        OrderService().insertOrder(order ,object : RetrofitCallback<Int> {
            override fun onError(t: Throwable) {
                Log.d(TAG, "onError: ")
            }

            override fun onSuccess(code: Int, responseData: Int) {

                Log.d(TAG, "onSuccess: $responseData")
                //(requireContext() as MainActivity).onBackPressed()

                Toast.makeText(context,"주문이 완료되었습니다.",Toast.LENGTH_SHORT).show()
                shoppingCarList.clear() // 장바구니 비우기
                mainActivity.openFragment(2, "orderId", responseData)
                isChk = false
                ApplicationClass.sharedPreferencesUtil.addOrderTable("x")
            }

            override fun onFailure(code: Int) {
                Log.d(TAG, "onFailure: ")
            }

        })
    }

    fun enableNfc() {
        // NFC 포그라운드 기능 활성화
        mainActivity.nfcAdapter!!.enableForegroundDispatch(mainActivity, mainActivity.pIntent, mainActivity.filters, null)
    }

    override fun onPause() {
        super.onPause()
        mainActivity.nfcAdapter!!.disableForegroundDispatch(mainActivity)
    }

    fun makeOrderDto(){
        var orderDetailList:ArrayList<OrderDetail> = arrayListOf()

        var order = Order(
            0,
            ApplicationClass.sharedPreferencesUtil.getUser().id,
            "",
            System.currentTimeMillis().toString(),
            "T",
            orderDetailList
        )

        for(i in 0 .. shoppingCarList.size - 1){
            orderDetailList.add(
                OrderDetail(
                    order.id,
                    0,
                    shoppingCarList.get(i).menuId,
                    shoppingCarList.get(i).menuCnt,
                ))
        }

        completedOrder(order)
    }




    fun displaySummary(){
        this@ShoppingListFragment.view?.findViewById<TextView>(R.id.textShoppingCount)?.text = ("총 ${shoppingCarList.sumOf { it.menuCnt }.toString()}개")
        this@ShoppingListFragment.view?.findViewById<TextView>(R.id.textShoppingMoney)?.text = CommonUtils.makeComma(shoppingCarList.sumOf { it.totalPrice })
    }
}