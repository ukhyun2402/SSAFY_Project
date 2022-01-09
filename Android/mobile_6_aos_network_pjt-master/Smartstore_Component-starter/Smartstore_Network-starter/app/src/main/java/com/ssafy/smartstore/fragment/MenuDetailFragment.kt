package com.ssafy.smartstore.fragment

import android.app.AlertDialog
import android.content.Context
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.RatingBar
import android.widget.Toast
import androidx.fragment.app.Fragment
import androidx.lifecycle.MutableLiveData
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.bumptech.glide.Glide
import com.ssafy.smartstore.R
import com.ssafy.smartstore.activity.MainActivity
import com.ssafy.smartstore.adapter.CommentAdapter
import com.ssafy.smartstore.config.ApplicationClass
import com.ssafy.smartstore.databinding.FragmentMenuDetailBinding
import com.ssafy.smartstore.dto.Comment
import com.ssafy.smartstore.dto.OrderDetail
import com.ssafy.smartstore.dto.ShoppingCart
import com.ssafy.smartstore.response.MenuDetailWithCommentResponse
import com.ssafy.smartstore.service.CommentService
import com.ssafy.smartstore.service.ProductService
import com.ssafy.smartstore.util.CommonUtils
import com.ssafy.smartstore.util.RetrofitCallback
import kotlin.math.round

//메뉴 상세 화면 . Order탭 - 특정 메뉴 선택시 열림
private const val TAG = "MenuDetailFragment_싸피"

class MenuDetailFragment : Fragment() {
    private lateinit var mainActivity: MainActivity
    private var commentAdapter = CommentAdapter(emptyList(), this::initData)
    private var productId = -1
    lateinit var newComment: Comment
    val liveData = MutableLiveData<List<MenuDetailWithCommentResponse>>()

    private lateinit var binding: FragmentMenuDetailBinding
    override fun onAttach(context: Context) {
        super.onAttach(context)
        mainActivity = context as MainActivity
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        mainActivity.hideBottomNav(true)

        arguments?.let {
            productId = it.getInt("productId", -1)
//            Log.d(TAG, "onCreate: $productId")
        }

    }

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        binding = FragmentMenuDetailBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        initData()
        initListener()

        countProduct()
    }

    //MutableLiveData<List<MenuDetailWithCommentResponse>>
    fun initData() {
        liveData.observe(mainActivity, {
//            Log.d(TAG, "livaData changed ${liveData.value}")
            binding.recyclerViewMenuDetail.adapter = liveData.value?.let { it1 ->
                CommentAdapter(
                    it1,
                    this::initData
                )
            }

        })
        ProductService().getProductWithComments(productId, ProductWithCommentInsertCallback())

        binding.recyclerViewMenuDetail.apply {
            layoutManager = LinearLayoutManager(context, LinearLayoutManager.VERTICAL, false)
            adapter = commentAdapter
            //원래의 목록위치로 돌아오게함
            adapter!!.stateRestorationPolicy =
                RecyclerView.Adapter.StateRestorationPolicy.PREVENT_WHEN_EMPTY
        }
    }

    // 초기 화면 설정
    private fun setScreen(menu: MenuDetailWithCommentResponse) {
        Glide.with(this)
            .load("${ApplicationClass.MENU_IMGS_URL}${menu.productImg}")
            .into(binding.menuImage)

        binding.txtMenuName.text = menu.productName
        binding.txtMenuPrice.text = "${CommonUtils.makeComma(menu.productPrice)}"
        binding.txtRating.text = "${(round(menu.productRatingAvg * 10) / 10)}점"
        binding.ratingBar.rating = menu.productRatingAvg.toFloat() / 2
    }

    private fun initListener() {
        binding.btnAddList.setOnClickListener {
            val count = binding.textMenuCount.text.toString().toInt()
            if (count >= 1) {
                Toast.makeText(context, "상품이 장바구니에 담겼습니다.", Toast.LENGTH_SHORT).show()
                val newOne = ShoppingCart(
                    productId,
                    liveData.value!![0].productImg,
                    liveData.value!![0].productName,
                    binding.textMenuCount.text.toString().toInt(),
                    liveData.value!![0].productPrice,
                    binding.textMenuCount.text.toString()
                        .toInt() * liveData.value!![0].productPrice,
                    liveData.value!![0].productType ?: "null"
                )
                val isItIn = mainActivity.shoppingList.find { newOne -> newOne.menuId == productId }
                if (isItIn == null) {
                    mainActivity.shoppingList.add(
                        newOne
                    )
                } else {
                    isItIn.addDupMenu(newOne)
                }

            }

        }
        binding.btnCreateComment.setOnClickListener {
            showDialogRatingStar()
        }
        binding.btnAddCount.setOnClickListener {
            val count = binding.textMenuCount.text.toString().toInt()
            if (count >= 0) {
                binding.textMenuCount.text = (count + 1).toString()
            }
        }
        binding.btnMinusCount.setOnClickListener {
            val count = binding.textMenuCount.text.toString().toInt()
            if (count > 0) {
                binding.textMenuCount.text = (count - 1).toString()
            } else {
                Toast.makeText(mainActivity, "0개 이하는 안됩니다!", Toast.LENGTH_SHORT).show()
            }
        }

        //Add comment
        binding.btnCreateComment.setOnClickListener {
            val commentText = binding.newCommentEdt.text.toString()
            if (commentText.isNotEmpty() && commentText.isNotBlank()) {
                showDialogRatingStar()?.show()
            } else {
                android.widget.Toast.makeText(
                    mainActivity,
                    "댓글을 입력해주세요!",
                    android.widget.Toast.LENGTH_SHORT
                ).show()
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        mainActivity.hideBottomNav(false)
    }

    private fun showDialogRatingStar(): AlertDialog? {
        val view = layoutInflater.inflate(R.layout.dialog_menu_comment, null)
        val dialog = AlertDialog.Builder(mainActivity).apply {
            setTitle("별점선택")
            setView(view)
            setPositiveButton("확인") { dialog, which ->

                val user = ApplicationClass.sharedPreferencesUtil.getUser()
                newComment = Comment(
                    -1,
                    user.id,
                    productId,
                    view.findViewById<RatingBar>(R.id.ratingBarMenuDialogComment).rating,
                    binding.newCommentEdt.text.toString()
                )
                CommentService().insert(newComment, CommentAddCallback())
            }
            setNegativeButton("취소") { dialog, which ->
                dialog.cancel()
            }
        }
        return dialog.create()
    }

    // 상품 수량 설정
    private fun countProduct() {
        var menuCnt = binding.textMenuCount.text.toString().toInt()
        binding.btnAddCount.setOnClickListener {
            binding.textMenuCount.text = menuCnt++.toString()
        }

        binding.btnMinusCount.setOnClickListener {
            if (menuCnt <= 0) {
                Toast.makeText(requireContext(), "수량을 입력해주세요", Toast.LENGTH_SHORT).show()
                binding.textMenuCount.text = "0"
            } else {
                binding.textMenuCount.text = menuCnt--.toString()
            }
        }
    }

    companion object {
        @JvmStatic
        fun newInstance(key: String, value: Int) =
            MenuDetailFragment().apply {
                arguments = Bundle().apply {
                    putInt(key, value)
                }
            }
    }


    inner class ProductWithCommentInsertCallback :
        RetrofitCallback<List<MenuDetailWithCommentResponse>> {
        override fun onSuccess(
            code: Int,
            responseData: List<MenuDetailWithCommentResponse>
        ) {
            if (responseData.isNotEmpty()) {

                Log.d(TAG, "initData: ${responseData[0]}")

                // comment 가 없을 경우 -> 들어온 response가 1개이고 해당 userId 가 null일 경우 빈 배열 Adapter 연결
                commentAdapter = if (responseData.size == 1 && responseData[0].userId == null) {
                    CommentAdapter(mutableListOf(), this@MenuDetailFragment::initData)
                } else {
                    CommentAdapter(responseData, this@MenuDetailFragment::initData)
                }
                liveData.value = responseData
                // 화면 정보 갱신
                setScreen(responseData[0])
            }

        }

        override fun onError(t: Throwable) {
            Log.d(TAG, t.message ?: "물품 정보 받아오는 중 통신오류")
        }

        override fun onFailure(code: Int) {
            Log.d(TAG, "onResponse: Error Code $code")
        }
    }

    inner class CommentAddCallback : RetrofitCallback<Boolean> {
        override fun onError(t: Throwable) {
            Log.d(TAG, "onError: ")
        }

        override fun onSuccess(code: Int, responseData: Boolean) {
            if (responseData) {
                binding.newCommentEdt.text.clear()
                initData()
            }
        }

        override fun onFailure(code: Int) {
            Log.d(TAG, "onFailure: ")
        }
    }

}