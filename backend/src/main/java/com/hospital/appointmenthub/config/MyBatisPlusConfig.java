package com.hospital.appointmenthub.config;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.context.annotation.Configuration;

@Configuration
// 自动扫描包路径下的所有 Mapper 接口，将它们注册为 Spring 的 Bean
// 减少在 Mapper 接口上使用 @Mapper 注解的需要，使配置更加集中
@MapperScan("com.hospital.appointmenthub.mapper")
public class MyBatisPlusConfig {
}
