package com.hospital.appointmenthub.config;

import com.hospital.appointmenthub.interceptor.JwtAuthInterceptor;
import com.hospital.appointmenthub.properties.JwtProperties;
import com.hospital.appointmenthub.util.JwtUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
@RequiredArgsConstructor
public class GlobalWebMvcConfig implements WebMvcConfigurer {

    private final JwtUtil jwtUtil;

    private final JwtProperties jwtProperties;

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(new JwtAuthInterceptor(jwtUtil, jwtProperties))
                .addPathPatterns("/api/**")
                .excludePathPatterns(
                        "/api/patient/register/**",
                        "/api/patient/login/**"
                );
    }
}
