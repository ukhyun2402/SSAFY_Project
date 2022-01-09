package com.ssafy.tp.model

import javax.persistence.*

@Entity
@Table(name = "order", schema = "ssafy_cafe")
data class Order(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    var id: Long?,

    @Column(name = "member_id")
    var memberId: Long,

    @Column(name = "date_time")
    var dateTime: String,

    @OneToMany
    @JoinColumn(name = "order_id")
    var orderDetails: List<OrderDetails>?
) {
    constructor(memberId: Long, dateTime: String) : this(
        id = null,
        orderDetails = null,
        memberId = memberId,
        dateTime = dateTime
    )
}