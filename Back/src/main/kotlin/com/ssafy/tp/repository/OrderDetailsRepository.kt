package com.ssafy.tp.repository

import com.ssafy.tp.model.OrderDetails
import org.springframework.data.jpa.repository.JpaRepository

interface OrderDetailsRepository : JpaRepository<OrderDetails, Long>{

}