package com.ssafy.tp.repository

import com.ssafy.tp.model.Member
import com.ssafy.tp.model.Order
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Modifying
import org.springframework.data.jpa.repository.Query
import javax.transaction.Transactional

interface OrderRepository: JpaRepository<Order, Long> {

    @Query(value = "SELECT * FROM ssafy_cafe.order WHERE member_id = ?1", nativeQuery = true)
    fun getOrders(memberId:Long,):List<Order>?

    @Modifying
    @Transactional
    @Query(value = "insert into ssafy_cafe.order (date_time, member_id) values (?1, ?2)", nativeQuery = true)
    fun postOrder(dateTime:String, memberId: Long):Int?
}