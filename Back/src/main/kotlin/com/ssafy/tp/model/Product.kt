package com.ssafy.tp.model

import javax.persistence.*

@Entity(name = "product")
data class Product(

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name="id")
    var id: Long,

    @Column(name="product_name")
    var productName:String,

    @Column(name="product_img_path")
    var productImgPath:String,

    @Column(name="price")
    var price:Long,

    @Column(name="category")
    var category:String,

    @OneToMany
    @JoinColumn(name = "product_id")
    var reviews: List<Review>,


)
