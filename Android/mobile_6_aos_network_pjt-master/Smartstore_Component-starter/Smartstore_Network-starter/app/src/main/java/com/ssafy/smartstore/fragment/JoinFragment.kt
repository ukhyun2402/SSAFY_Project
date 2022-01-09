package com.ssafy.smartstore.fragment

import android.content.Context
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.fragment.app.Fragment
import com.ssafy.smartstore.R
import com.ssafy.smartstore.activity.LoginActivity
import com.ssafy.smartstore.config.ApplicationClass
import com.ssafy.smartstore.databinding.FragmentJoinBinding
import com.ssafy.smartstore.dto.User
import com.ssafy.smartstore.service.UserService
import com.ssafy.smartstore.util.RetrofitCallback

// 회원 가입 화면
private const val TAG = "JoinFragment_싸피"

class JoinFragment : Fragment() {
    private var checkedId = false
    lateinit var user: User
    lateinit var binding: FragmentJoinBinding
    lateinit var loginActivity: LoginActivity

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        binding = FragmentJoinBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onAttach(context: Context) {
        super.onAttach(context)
        loginActivity = context as LoginActivity
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        //id 중복 확인 버튼
        binding.btnConfirm.setOnClickListener {
            val inputId = binding.editTextJoinID.text.toString()
            if (inputId.isNotEmpty()) {
                var msg = ""
                UserService().isUsed(inputId, IsUsedCallBack())
                if (!checkedId) {
                    binding.btnConfirm.setImageResource(R.drawable.check)
                    checkedId = true
                    msg = "사용 가능한 아이디입니다."
                } else {
                    binding.btnConfirm.setImageResource(R.drawable.check_mark)
                    checkedId = false
                    msg = "중복되는 아이디입니다."
                }
                Toast.makeText(loginActivity, msg, Toast.LENGTH_SHORT).show()
            }
        }

        // 회원가입 버튼
        binding.btnJoin.setOnClickListener {
            if (binding.editTextJoinID.text.isNotEmpty()
                && binding.editTextJoinPW.text.isNotEmpty()
                && binding.editTextJoinName.text.isNotEmpty()
            ) {
                val id = binding.editTextJoinID.text.toString()
                val password = binding.editTextJoinPW.text.toString()
                user = User(id, binding.editTextJoinName.text.toString(), password)
                UserService().join(user, JoinCallBack())
            } else {
                Toast.makeText(loginActivity, "빈 공간이 없는지 확인해주세요", Toast.LENGTH_SHORT).show()
            }
        }
    }

    inner class IsUsedCallBack : RetrofitCallback<Boolean> {
        override fun onError(t: Throwable) {
            Log.d(TAG, "onError: ")
        }

        override fun onSuccess(code: Int, responseData: Boolean) {
            checkedId = responseData
        }

        override fun onFailure(code: Int) {
            Log.d(TAG, "onFailure: ")
        }
    }

    inner class JoinCallBack : RetrofitCallback<Boolean> {
        override fun onError(t: Throwable) {
            Log.d(TAG, "onError: ")
        }

        override fun onSuccess(code: Int, responseData: Boolean) {
            if(responseData) {
                loginActivity.openFragment(1)
                ApplicationClass.sharedPreferencesUtil.addUser(user)
            }
        }

        override fun onFailure(code: Int) {
            Log.d(TAG, "onFailure: ")
        }
    }
}