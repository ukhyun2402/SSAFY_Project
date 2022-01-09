package com.ssafy.tp.controller

import com.ssafy.tp.model.*
import com.ssafy.tp.repository.*
import org.springframework.data.jpa.domain.AbstractPersistable_.id
import org.springframework.http.HttpStatus
import org.springframework.http.MediaType
import org.springframework.http.ResponseEntity
import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.*
import java.io.InputStream
import javax.validation.Valid

@Controller
@RequestMapping("/api")
class Controller(
    private val memberRepository: MemberRepository,
    private val orderRepository: OrderRepository,
    private val eventRepository: EventRepository,
    private val productRepository: ProductRepository,
    private val reviewRepository: ReviewRepository,
    private val orderDetailsRepository: OrderDetailsRepository

) {

    @GetMapping("/members")
    fun getMembers(): ResponseEntity<List<Member>> {
        println(memberRepository.findAll())
        return ResponseEntity<List<Member>>(memberRepository.findAll(),HttpStatus.OK);
    }

    @GetMapping("/member/{id}")
    fun getMember(@PathVariable(value = "id") memberId: Long): ResponseEntity<Member> {
        return memberRepository.findById(memberId).map { member ->
            ResponseEntity.ok(member)
        }.orElse(ResponseEntity.notFound().build())
    }

    @PutMapping("/member")
    fun newMember(@Valid @RequestBody member: Member): Member = memberRepository.save(member)

    @PostMapping("/login")
    fun login(@RequestBody member: Member): ResponseEntity<Member> {
        val tmp = memberRepository.login(member.email, member.password)
        val reponseStatus: HttpStatus;
        if (tmp == null) {
            reponseStatus = HttpStatus.BAD_REQUEST;
        } else {
            reponseStatus = HttpStatus.OK;
        }
        return ResponseEntity<Member>(tmp, reponseStatus);
    }

    @PostMapping("/signUp")
    fun signUp(@RequestBody member: Member): ResponseEntity<Long> {
        val tmp = memberRepository.save(member)
        return ResponseEntity<Long>(tmp.id, HttpStatus.OK);
    }

    @PostMapping("/idCheck")
    fun idCheck(@RequestBody body: Map<String, String>): ResponseEntity<Int> {
        println(System.currentTimeMillis())
        return ResponseEntity<Int>(memberRepository.idCheck(body["id"] ?: ""), HttpStatus.OK)
    }

    @PostMapping("/phoneCheck")
    fun phoneCheck(@RequestBody body: Map<String, String>): ResponseEntity<Int> {
//        println(System.currentTimeMillis())
        return ResponseEntity<Int>(memberRepository.phoneCheck(body["phone_number"] ?: ""), HttpStatus.OK)
    }

    @PutMapping("/member/{phoneNumber}/{point}")
    fun addPoint(@PathVariable("phoneNumber") phoneNumber:String, @PathVariable("point") point:Int):ResponseEntity<Int>{
        val affectedRows = memberRepository.addPoint(phoneNumber=phoneNumber, point=point);
        if(affectedRows == 0 ){
            return ResponseEntity<Int>(affectedRows, HttpStatus.BAD_REQUEST);
        }else {
            return ResponseEntity<Int>(affectedRows, HttpStatus.OK);
        }
    }

//    @GetMapping("/member/{id}")
//    fun getMemberImage(@PathVariable("id") memberId:Long) :ResponseEntity<String> {
//        return
//    }

    @GetMapping("/orders/{userId}")
    fun getOrders(@PathVariable(name = "userId") userId: Long): ResponseEntity<List<Order>> {
        var result = orderRepository.getOrders(userId);
        val reponseStatus: HttpStatus;
        if (result == null) {
            reponseStatus = HttpStatus.BAD_REQUEST;
        } else {
            reponseStatus = HttpStatus.OK;
        }
        return ResponseEntity<List<Order>>(result, reponseStatus)
    }

    @PostMapping("/order")
    fun postOrder(@RequestBody body: Map<String, Any>):ResponseEntity<Boolean>{
        val memberId:Long = (body["memberId"] as Int).toLong()
        val dateTime:String = body["dateTime"] as String
        val orderDetails = body["orderDetails"] as List<*>;

        val newOrderId = orderRepository.postOrder(memberId = memberId, dateTime = dateTime)

        for ( od in orderDetails){
            od as Map<String, String>
            orderDetailsRepository.save(OrderDetails(productId = (od["productId"] as Int).toLong(), (newOrderId as Int).toLong(), (od["quantity"] as Int).toLong()))
        }
        return ResponseEntity<Boolean>(HttpStatus.OK)
    }

    //Event
    @GetMapping("/events")
    fun getEvents(): ResponseEntity<List<Event>> {
        return ResponseEntity<List<Event>>(eventRepository.findAll(),HttpStatus.OK);
    }

    //Product
    @GetMapping("/products")
    fun getProducts() : ResponseEntity<List<Product>> {
        return ResponseEntity<List<Product>>(productRepository.getProduct(), HttpStatus.OK)
    }

    @GetMapping("/product/{id}")
    fun getProducts(@PathVariable(value ="id") productId:Long) : ResponseEntity<Product> {
        return productRepository.findById(productId).map { product ->
            ResponseEntity.ok(product)
        }.orElse(ResponseEntity.notFound().build())
    }

    //Reviews
    @GetMapping("/reviews/{productId}")
    fun getReviews(@PathVariable(value = "productId") productId:Long) :ResponseEntity<List<Review>>{
        return ResponseEntity<List<Review>>(reviewRepository.getReviews(productId), HttpStatus.OK)
    }

    //Image
//    @GetMapping("/image/{path}", produces = [MediaType.IMAGE_PNG_VALUE, MediaType.IMAGE_JPEG_VALUE])
//    fun getImage(@PathVariable("path") imagePath: String): ResponseEntity<ByteArray>{
//        var inputStream: InputStream =
//        return ResponseEntity<ByteArray>(imageByteArray, HttpStatus.OK)
//    }
}