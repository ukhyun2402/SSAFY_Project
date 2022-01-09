package com.ssafy.tp.repository

import com.ssafy.tp.model.Event
import com.ssafy.tp.model.Member
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import java.util.*

interface EventRepository: JpaRepository<Event, Long>{

}