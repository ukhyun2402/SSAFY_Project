package com.ssafy.tp.model

import javax.persistence.*

@Entity(name = "event")
data class Event(

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name ="id")
    var id: Long,

    @Column(name ="event_name")
    var eventName: String,

    @Column(name="description")
    var description: String?,

    @Column(name = "route_page_name")
    var routePageName:String,

    @Column(name = "image_path")
    var imagePath:String?

) {
}