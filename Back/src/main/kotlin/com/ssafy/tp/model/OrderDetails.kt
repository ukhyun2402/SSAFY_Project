package com.ssafy.tp.model

import javax.persistence.*

@Entity(name = "order_details")
data class OrderDetails(

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    var id: Long?,

    @Column(name = "product_id")
    var productId: Long,

    @Column(name ="order_id")
    var orderId:Long,

    @Column(name="quantity")
    var quantity:Long,
) {
    constructor(productId: Long, orderId: Long, quantity: Long) : this(null, productId, orderId, quantity)
}