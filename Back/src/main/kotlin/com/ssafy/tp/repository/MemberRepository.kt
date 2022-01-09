package com.ssafy.tp.repository

import com.ssafy.tp.model.Member
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Modifying
import org.springframework.data.jpa.repository.Query
import java.util.*
import javax.transaction.Transactional

interface MemberRepository: JpaRepository<Member, Long>{

    @Query(value = "SELECT * FROM MEMBER WHERE email = ?1 and password = ?2", nativeQuery = true)
    fun login(email:String, password:String):Member?

    @Query(value = "SELECT COUNT(*) FROM MEMBER WHERE EMAIL =?1", nativeQuery = true)
    fun idCheck(email:String):Int

    @Query(value = "SELECT COUNT(*) FROM MEMBER WHERE PHONE_NUMBER =?1", nativeQuery = true)
    fun phoneCheck(email:String):Int

    @Modifying
    @Transactional
    @Query(value = "UPDATE MEMBER SET POINT = POINT + ?2 WHERE PHONE_NUMBER =?1",nativeQuery = true)
    fun addPoint(phoneNumber:String, point:Int):Int
}