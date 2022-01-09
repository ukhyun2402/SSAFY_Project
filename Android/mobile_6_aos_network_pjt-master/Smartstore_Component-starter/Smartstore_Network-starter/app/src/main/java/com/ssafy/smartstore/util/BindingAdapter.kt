package com.ssafy.smartstore.util

import android.view.View
import android.widget.ImageView
import androidx.databinding.BindingAdapter
import com.bumptech.glide.Glide
import com.ssafy.smartstore.config.ApplicationClass

object BindingAdapter {

    @JvmStatic
    @BindingAdapter("imageFile")
    fun bindImg(view: ImageView, resName: String) {
        Glide.with(view.context)
            .load("${ApplicationClass.MENU_IMGS_URL}${resName}")
            .into(view)
    }
}