package com.hospital.appointmenthub.model.dto;

import java.time.LocalDate;
import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 我的预约列表项.
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
public class AppointmentItemDTO {

    private Long id;

    private Long appointmentNo;

    private Long memberId;

    private String memberName;

    private Long doctorId;

    private String doctorName;

    private String doctorTitle;

    private Long departmentId;

    private String departmentName;

    private Long scheduleId;

    private LocalDate appointmentDate;

    private Integer timeSlot;

    private Integer status;

    private String remark;

    private LocalDateTime createdAt;

    private Boolean canCancel;
}
