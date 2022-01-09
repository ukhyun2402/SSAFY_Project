package com.ssafy.tp

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication
import org.springframework.context.annotation.ComponentScan
import org.springframework.http.CacheControl
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer
import java.util.concurrent.TimeUnit

@ComponentScan("com.ssafy")
@SpringBootApplication
class TpApplication : WebMvcConfigurer {

    override fun addResourceHandlers(registry: ResourceHandlerRegistry) {
        super.addResourceHandlers(registry)
        registry.addResourceHandler("/images/**").addResourceLocations("classpath:/static/img/")
            .setCacheControl(CacheControl.maxAge(2, TimeUnit.HOURS).cachePublic())
    }

}

fun main(args: Array<String>) {
    runApplication<TpApplication>(*args)
}


