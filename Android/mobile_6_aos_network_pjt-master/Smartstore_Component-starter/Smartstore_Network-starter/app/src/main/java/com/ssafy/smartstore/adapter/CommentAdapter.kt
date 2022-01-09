package com.ssafy.smartstore.adapter

import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.EditText
import android.widget.ImageView
import android.widget.TextView
import android.widget.Toast
import androidx.recyclerview.widget.RecyclerView
import com.ssafy.smartstore.R
import com.ssafy.smartstore.activity.MainActivity
import com.ssafy.smartstore.config.ApplicationClass
import com.ssafy.smartstore.dto.Comment
import com.ssafy.smartstore.response.MenuDetailWithCommentResponse
import com.ssafy.smartstore.service.CommentService
import com.ssafy.smartstore.util.RetrofitCallback

private const val TAG = "JoinFragment_싸피"

class CommentAdapter(val list: List<MenuDetailWithCommentResponse>, val kFunction0: () -> Unit) :
    RecyclerView.Adapter<CommentAdapter.CommentHolder>() {

    lateinit var context: MainActivity

    interface Notify {
        fun onChanged()
    }
    inner class CommentHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {


        val comment = itemView.findViewById<TextView>(R.id.textNoticeContent)
        val commentModify = itemView.findViewById<EditText>(R.id.et_comment_content)
        val user = ApplicationClass.sharedPreferencesUtil.getUser()

        val modify = itemView.findViewById<ImageView>(R.id.iv_modify_comment)
        val modifyAccept = itemView.findViewById<ImageView>(R.id.iv_modify_accept_comment)
        val modifyCancle = itemView.findViewById<ImageView>(R.id.iv_modify_cancel_comment)
        val delete = itemView.findViewById<ImageView>(R.id.iv_delete_comment)

        private fun visibleMainButton(visible: Boolean = true) {
            if (visible) {
                modify.visibility = ImageView.VISIBLE
                delete.visibility = ImageView.VISIBLE
            } else {
                modify.visibility = ImageView.GONE
                delete.visibility = ImageView.GONE
            }
        }

        private fun visibleModifiedButton(visible: Boolean = true) {
            if (visible) {
                modifyAccept.visibility = ImageView.VISIBLE
                modifyCancle.visibility = ImageView.VISIBLE
                commentModify.visibility = EditText.VISIBLE
            } else {
                commentModify.visibility = EditText.GONE
                modifyAccept.visibility = ImageView.GONE
                modifyCancle.visibility = ImageView.GONE
            }
        }


        fun bindInfo(data: MenuDetailWithCommentResponse, index: Int) {
            val newComment = Comment(
                data.commentId,
                user.id,
                data.productId,
                data.productRating.toFloat(),
                data.commentContent ?: "너무좋아요"
            )
            visibleModifiedButton(false)

            if (data.userId == user.id) {
                visibleMainButton()

                modify.setOnClickListener {
                    visibleModifiedButton()
                    visibleMainButton(false)
                }

                modifyCancle.setOnClickListener {
                    visibleMainButton()
                    visibleModifiedButton(false)
                }

                modifyAccept.setOnClickListener {
                    newComment.comment = commentModify.text.toString()
                    CommentService().modify(newComment, ModifyCallback())
                    visibleMainButton()
                    visibleModifiedButton(false)
                }

                delete.setOnClickListener {
//                    val i = list.indexOfFirst { item -> item.commentId == data.id }
//                    commentService.deleteComment(data.id)
//                    list.removeAt(i)
                    CommentService().delete(newComment.id, DeleteCallback())
                    visibleMainButton()
                    visibleModifiedButton(false)
                }
            } else {
                visibleMainButton(false)
            }
            comment.text = data.commentContent
        }

        inner class ModifyCallback : RetrofitCallback<Boolean> {
            override fun onError(t: Throwable) {
                Log.d(TAG, "onError: ")
            }

            override fun onSuccess(code: Int, responseData: Boolean) {
                if (responseData) {
                    Toast.makeText(context, "수정되었습니다.", Toast.LENGTH_SHORT).show()
                    kFunction0()
                }
            }

            override fun onFailure(code: Int) {
                Log.d(TAG, "onFailure: ")
            }
        }

        inner class DeleteCallback : RetrofitCallback<Boolean> {
            override fun onError(t: Throwable) {
                Log.d(TAG, "onError: ")
            }

            override fun onSuccess(code: Int, responseData: Boolean) {
                
                if(responseData){
                    Toast.makeText(context, "삭제되었습니다.", Toast.LENGTH_SHORT).show()
                    kFunction0()
                }
            }

            override fun onFailure(code: Int) {
                Log.d(TAG, "onFailure: ")
            }
        }
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): CommentHolder {
        context = parent.context as MainActivity
        val view =
            LayoutInflater.from(parent.context).inflate(R.layout.list_item_comment, parent, false)
        return CommentHolder(view)
    }

    override fun onBindViewHolder(holder: CommentHolder, position: Int) {
        holder.bindInfo(list[position], position)
    }

    override fun getItemCount(): Int {
        return list.size
    }
}

