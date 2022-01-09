package com.ssafy.tp.repository

import com.ssafy.tp.model.Member
import com.ssafy.tp.model.Order
import com.ssafy.tp.model.Product
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query

interface ProductRepository: JpaRepository<Product, Long> {

//    @Query(value = "SELECT * FROM ssafy_cafe.order WHERE member_id = ?1", nativeQuery = true)
//    fun getOrders(memberId:Long,):List<Order>?

        @Query(value = "SELECT * FROM product WHERE id != 0", nativeQuery = true)
        fun getProduct():List<Product>;
}