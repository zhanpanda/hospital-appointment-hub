package com.hospital.appointmenthub.model.dto;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 提交预约请求.
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
public class AppointmentCreateDTO {

    @NotNull(message = "排班ID不能为空")
    private Long scheduleId;

    @NotNull(message = "就诊人ID不能为空")
    private Long familyMemberId;
}
