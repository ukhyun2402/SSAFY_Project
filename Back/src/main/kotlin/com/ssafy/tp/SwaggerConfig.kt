//package com.ssafy.tp
//
//import org.springframework.context.annotation.Bean
//import org.springframework.context.annotation.Configuration
//import springfox.documentation.builders.ApiInfoBuilder
//import springfox.documentation.builders.PathSelectors
//import springfox.documentation.builders.RequestHandlerSelectors
//import springfox.documentation.service.ApiInfo
//import springfox.documentation.service.Contact
//import springfox.documentation.spi.DocumentationType
//import springfox.documentation.spring.web.plugins.Docket
//import springfox.documentation.swagger2.annotations.EnableSwagger2
//
//
//@Configuration
//@EnableSwagger2
//class SwaggerConfig {
//    @Bean
//    fun api(): Docket? {
//        return Docket(DocumentationType.SWAGGER_2)
//            .consumes(getConsumeContentTypes())
//            .produces(getProduceContentTypes())
//            .apiInfo(getApiInfo())
//            .select()
//            .apis(RequestHandlerSelectors.basePackage("com.ssafy.tp.controller"))
//            .paths(PathSelectors.ant("/member/**"))
//            .build()
//    }
//
//    private fun getConsumeContentTypes(): Set<String>? {
//        val consumes: MutableSet<String> = HashSet()
//        consumes.add("application/json;charset=UTF-8")
//        consumes.add("application/x-www-form-urlencoded")
//        return consumes
//    }
//
//    private fun getProduceContentTypes(): Set<String>? {
//        val produces: MutableSet<String> = HashSet()
//        produces.add("application/json;charset=UTF-8")
//        return produces
//    }
//
//    private fun apiInfo(): ApiInfo? {
//        return ApiInfoBuilder()
//            .title("API")
//            .description("[Bamdule] API")
//            .contact(Contact("Bamdule Swagger", "https://bamdule.tistory.com/", "Bamdule5@gmail.com"))
//            .version("1.0")
//            .build()
//    }
//}