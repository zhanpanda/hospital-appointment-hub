package com.hospital.appointmenthub;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.hospital.appointmenthub.mapper")
public class HospitalAppointmentHubApplication {

    public static void main(String[] args) {
        SpringApplication.run(HospitalAppointmentHubApplication.class, args);
    }
}
