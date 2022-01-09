package com.ssafy.tp.model

import javax.persistence.*
import javax.validation.constraints.NotBlank

@Entity(name = "member")
data class Member(

    @Id
    @Column(name="id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    var id: Long? = null,

    @get: NotBlank
    @Column(name = "email")
    var email:String = "",

    @get: NotBlank
    @Column(name = "password")
    var password:String ="",

    @get: NotBlank
    @Column(name = "name")
    var name:String? = "",

    @Column(name = "point")
    var point:Int?,

    @Column(name = "phone_number")
    var phoneNumber:String?,

    @Column(name = "stamp")
    var stamp: Int?,

    @Column(name ="img")
    var img: String?,

) {


}