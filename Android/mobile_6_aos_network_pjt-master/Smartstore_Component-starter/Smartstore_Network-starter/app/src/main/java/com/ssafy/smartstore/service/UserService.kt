package com.ssafy.smartstore.service

import android.content.Context
import android.util.Log
import android.view.Menu
import android.widget.Toast
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import com.ssafy.smartstore.config.ApplicationClass
import com.ssafy.smartstore.dto.Comment
import com.ssafy.smartstore.dto.Product
import com.ssafy.smartstore.dto.User
import com.ssafy.smartstore.response.MenuDetailWithCommentResponse
import com.ssafy.smartstore.util.RetrofitCallback
import com.ssafy.smartstore.util.RetrofitUtil
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

private const val TAG = "LoginService_싸피"
class UserService {

    fun login(user:User, callback: RetrofitCallback<User>)  {
        RetrofitUtil.userService.login(user).enqueue(object : Callback<User> {
            override fun onResponse(call: Call<User>, response: Response<User>) {
                val res = response.body()
                if(response.code() == 200){
                    if (res != null) {
                        callback.onSuccess(response.code(), res)
                    }
                } else {
                    callback.onFailure(response.code())
                }
            }

            override fun onFailure(call: Call<User>, t: Throwable) {
                callback.onError(t)
            }
        })
    }

    fun isUsed(id: String, callback: RetrofitCallback<Boolean>) {
        RetrofitUtil.userService.isUsedId(id).enqueue(object : Callback<Boolean> {
            override fun onResponse(call: Call<Boolean>, response: Response<Boolean>) {
                val res = response.body()
                if(response.code() == 200) {
                    if (res != null) {
                        callback.onSuccess(response.code(), res)
                    }
                } else {
                    callback.onFailure(response.code())
                }
            }

            override fun onFailure(call: Call<Boolean>, t: Throwable) {
                callback.onError(t)
            }
        })
    }

    fun join(user: User, callback: RetrofitCallback<Boolean>) {
        RetrofitUtil.userService.insert(user).enqueue(object : Callback<Boolean> {
            override fun onResponse(call: Call<Boolean>, response: Response<Boolean>) {
                val res = response.body()
                if(response.code() == 200) {
                    if (res != null) {
                        callback.onSuccess(response.code(), res)
                    }
                } else {
                    callback.onFailure(response.code())
                }
            }

            override fun onFailure(call: Call<Boolean>, t: Throwable) {
                callback.onError(t)
            }
        })
    }

    fun get(userId: String, callback: RetrofitCallback<HashMap<String, Any>>) {
        RetrofitUtil.userService.getInfo(userId).enqueue(object : Callback<HashMap<String, Any>> {
            override fun onResponse(
                call: Call<HashMap<String, Any>>,
                response: Response<HashMap<String, Any>>
            ) {
                val res = response.body()
                if(response.code() == 200) {
                    if (res != null) {
                        callback.onSuccess(response.code(), res)
                    }
                } else {
                    Log.d(TAG, "onResponse: ")
                    callback.onFailure(response.code())
                }
            }

            override fun onFailure(call: Call<HashMap<String, Any>>, t: Throwable) {
                callback.onError(t)
            }
        })
    }
}