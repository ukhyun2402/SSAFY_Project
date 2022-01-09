package com.ssafy.tp.repository

import com.ssafy.tp.model.Event
import com.ssafy.tp.model.Review
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query

interface ReviewRepository: JpaRepository<Review, Long> {

    @Query(value = "SELECT * FROM ssafy_cafe.review WHERE product_id = ?1", nativeQuery = true)
    fun getReviews(productId:Long,):List<Review>?
}