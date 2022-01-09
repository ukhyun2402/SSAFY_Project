package com.ssafy.smartstore.adapter

import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.ssafy.smartstore.R
import com.ssafy.smartstore.response.LatestOrderResponse
import com.ssafy.smartstore.response.OrderDetailResponse
import com.ssafy.smartstore.util.CommonUtils


private const val TAG = "LatestOrderAdapter_ukhyun"
class LatestOrderAdapter() :RecyclerView.Adapter<LatestOrderAdapter.LatestOrderHolder>(){

    var list = mutableListOf<LatestOrderResponse>()

    inner class LatestOrderHolder(var binding: com.ssafy.smartstore.databinding.ListItemLatestOrderBinding) : RecyclerView.ViewHolder(binding.root){

        fun bindInfo(item : LatestOrderResponse){
            binding.dto = item
            binding.textMenuDate.text = CommonUtils.getFormattedStringDate(item.orderDate)
            binding.textMenuPrice.text = CommonUtils.makeComma(item.totalPrice)
        }
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): LatestOrderHolder {
//        val view = LayoutInflater.from(parent.context).inflate(R.layout.list_item_latest_order, parent, false)
        return LatestOrderHolder(com.ssafy.smartstore.databinding.ListItemLatestOrderBinding.inflate(LayoutInflater.from(parent.context),parent,false))
    }

    override fun onBindViewHolder(holder: LatestOrderHolder, position: Int) {
//        holder.bind()
        holder.apply {
            bindInfo(list[position])
            //클릭연결
            itemView.setOnClickListener{
                itemClickListner.onClick(it, position)
            }
        }
    }

    override fun getItemCount(): Int {
        return list.size
    }

    //클릭 인터페이스 정의 사용하는 곳에서 만들어준다.
    interface ItemClickListener {
        fun onClick(view: View,  position: Int)
    }
    //클릭리스너 선언
    private lateinit var itemClickListner: ItemClickListener
    //클릭리스너 등록 매소드
    fun setItemClickListener(itemClickListener: ItemClickListener) {
        this.itemClickListner = itemClickListener
    }

}

