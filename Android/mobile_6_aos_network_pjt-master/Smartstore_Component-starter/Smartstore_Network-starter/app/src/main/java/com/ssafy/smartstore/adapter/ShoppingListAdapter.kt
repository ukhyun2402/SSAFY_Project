package com.ssafy.smartstore.adapter

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.ssafy.smartstore.R
import com.ssafy.smartstore.activity.MainActivity
import com.ssafy.smartstore.databinding.ListItemShoppingListBinding
import com.ssafy.smartstore.dto.ShoppingCart


class ShoppingListAdapter(val shoppingCartList: MutableList<ShoppingCart>) :RecyclerView.Adapter<ShoppingListAdapter.ShoppingListHolder>(){

    lateinit var mainActivity: MainActivity

    interface DeleteButtonClick{
        fun onClick(shoppingCart: ShoppingCart)
    }

    lateinit var deleteButtonClick: DeleteButtonClick

    inner class ShoppingListHolder(var binding: ListItemShoppingListBinding) : RecyclerView.ViewHolder(binding.root){

        fun bindInfo(shoppingCart: ShoppingCart){
            binding.shoppingItem = shoppingCart
            binding.deleteShoppingcartBtn.setOnClickListener {
//                shoppingCartList.remove(shoppingCart)
//                this@ShoppingListAdapter.notifyDataSetChanged()
                deleteButtonClick.onClick(shoppingCart)
            }
        }
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ShoppingListHolder {
        mainActivity = parent.context as MainActivity
        val view = LayoutInflater.from(parent.context).inflate(R.layout.list_item_shopping_list, parent, false)
//        return ShoppingListHolder(view)
        return ShoppingListHolder(ListItemShoppingListBinding.inflate(LayoutInflater.from(parent.context),parent, false))
    }

    override fun onBindViewHolder(holder: ShoppingListHolder, position: Int) {
        val shoppingCart = shoppingCartList[position]
        holder.bindInfo(shoppingCart)
    }

    override fun getItemCount(): Int {
        return shoppingCartList.size
    }
}

