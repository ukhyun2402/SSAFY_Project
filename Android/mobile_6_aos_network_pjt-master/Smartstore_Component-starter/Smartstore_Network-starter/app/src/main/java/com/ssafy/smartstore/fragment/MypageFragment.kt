package com.ssafy.smartstore.fragment

import android.content.Context
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.ssafy.smartstore.R
import com.ssafy.smartstore.activity.MainActivity
import com.ssafy.smartstore.adapter.OrderAdapter
import com.ssafy.smartstore.config.ApplicationClass
import com.ssafy.smartstore.databinding.FragmentMypageBinding
import com.ssafy.smartstore.dto.User
import com.ssafy.smartstore.dto.UserOrderDetail
import com.ssafy.smartstore.response.LatestOrderResponse
import com.ssafy.smartstore.service.OrderService
import com.ssafy.smartstore.service.UserService
import com.ssafy.smartstore.util.RetrofitCallback
import com.ssafy.smartstore.util.RetrofitUtil
import org.json.JSONObject

// MyPage 탭
private const val TAG = "MypageFragment_싸피"

class MypageFragment : Fragment() {
    private lateinit var orderAdapter: OrderAdapter
    private lateinit var mainActivity: MainActivity
    private lateinit var list: List<LatestOrderResponse>
    lateinit var user: User

    private lateinit var binding: FragmentMypageBinding
    override fun onAttach(context: Context) {
        super.onAttach(context)
        mainActivity = context as MainActivity
    }

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        binding = FragmentMypageBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        var id = getUserData()


    }

    //주문데이터
    private fun initData(id: String) {

        val userLastOrderLiveData = OrderService().getLastMonthOrder(id)
        userLastOrderLiveData.observe(
            viewLifecycleOwner,
            {
                list = it

                orderAdapter = OrderAdapter(mainActivity, list)
                orderAdapter.setItemClickListener(object : OrderAdapter.ItemClickListener {
                    override fun onClick(view: View, position: Int, orderid: Int) {
                        mainActivity.openFragment(2, "orderId", orderid)
                    }
                })

                binding.recyclerViewOrder.apply {
                    layoutManager =
                        LinearLayoutManager(context, LinearLayoutManager.HORIZONTAL, false)
                    adapter = orderAdapter
                    //원래의 목록위치로 돌아오게함
                    adapter!!.stateRestorationPolicy =
                        RecyclerView.Adapter.StateRestorationPolicy.PREVENT_WHEN_EMPTY
                }
                binding.logout.setOnClickListener {
                    mainActivity.openFragment(5)
                }

                Log.d(TAG, "onViewCreated: $it")
            }
        )

    }

    private fun getUserData(): String {
//        val a = RetrofitUtil.userService.ge(ApplicationClass.sharedPreferencesUtil.getUser().id)
//        Log.d(TAG, "getUserData: ${ApplicationClass.sharedPreferencesUtil.getUser().id}")
        UserService().get(ApplicationClass.sharedPreferencesUtil.getUser().id, GetUserCallback())
//        binding.textUserName.text = user.name
//
//        return user.id
        return ApplicationClass.sharedPreferencesUtil.getUser().id
    }

    private fun grade() {
        val levelStamp = intArrayOf(0, 10, 15, 20, 25)
        val gradeStamp = mutableListOf<Int>()
        for (i in levelStamp.indices) {
            gradeStamp.add(i, levelStamp.slice(0..(i)).reduce { acc, i -> acc + i * 5 })
        }

        val image = binding.imageLevel
        val textLevelRest = binding.textLevelRest
        val textUserLevel = binding.textUserLevel

        var grade = gradeStamp.indexOf(gradeStamp.find { it -> it > user.stamps }) - 1
        grade = if (grade < 0) 4 else grade
        when ((grade)) {
            0 -> image.setImageResource(R.drawable.seeds)
            1 -> image.setImageResource(R.drawable.flower)
            2 -> image.setImageResource(R.drawable.coffee_fruit)
            3 -> image.setImageResource(R.drawable.coffee_beans)
            4 -> image.setImageResource(R.drawable.coffee_tree)
        }

        val level = if (user.stamps == 0) 1 else {
            if (gradeStamp[grade] == 0) {
                user.stamps / levelStamp[grade + 1] + 1
            } else if (grade == 4) {
                user.stamps % gradeStamp[grade] / levelStamp[4]
            } else {
                user.stamps % gradeStamp[grade] / levelStamp[grade + 1] + 1
            }
        }
        val restCoffee = if (user.stamps == 0) 0 else {
            if (gradeStamp[grade] == 0) {
                user.stamps % levelStamp[grade + 1]
            } else if (grade == 4) {
                user.stamps % gradeStamp[grade] % levelStamp[4]
            } else {
                user.stamps % gradeStamp[grade] % levelStamp[grade + 1]
            }
        }

        binding.proBarUserLevel.max = if (grade == 4) 9999 else levelStamp[grade + 1]
        binding.proBarUserLevel.progress = restCoffee
        textLevelRest.text = ("다음 레벨까지 ${
            if (grade == 4) {
                0
            } else levelStamp[grade + 1] - restCoffee
        }잔 남았습니다.")
        textUserLevel.text = ("${
            when (grade) {
                0 -> "씨앗"
                1 -> "꽃"
                2 -> "열매"
                3 -> "커피콩"
                else -> "나무"
            }
        } ${level}단계")
        binding.textUserNextLevel.text = ("${user.stamps % gradeStamp[grade + 1]} / ${
            if (grade == 4) {
                0
            } else levelStamp[grade + 1]  * level
        }")
    }


    inner class GetUserCallback : RetrofitCallback<HashMap<String, Any>> {
        override fun onError(t: Throwable) {
            Log.d(TAG, "onError: ")
        }

        override fun onSuccess(code: Int, responseData: HashMap<String, Any>) {
            Log.d(TAG, "onSuccess: ${responseData}")
            val data = JSONObject(responseData as Map<*, *>)
            val rawUser = data.getJSONObject("user")
            user = User(
                rawUser.getString("id"),
                rawUser.getString("name"),
                rawUser.getString("pass"),
                rawUser.getInt("stamps"),
            )
            binding.textUserName.text = user.name
            Log.d(TAG, "onSuccess: $user")
            grade()
            initData(user.id)
        }

        override fun onFailure(code: Int) {
            Log.d(TAG, "onFailure: $code")
        }
    }
}