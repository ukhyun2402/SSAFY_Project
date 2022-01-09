package com.ssafy.tp.model

import javax.persistence.*

@Entity(name = "review")
data class Review(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    var id: Long,

    @Column(name = "content")
    var content:String,

    @Column(name = "product_id")
    var productId:Long,

    @Column(name = "member_id")
    var memberId:Long,
) {


}