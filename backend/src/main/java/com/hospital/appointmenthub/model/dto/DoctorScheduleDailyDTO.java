package com.hospital.appointmenthub.model.dto;

import java.time.LocalDate;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 医生日排班信息.
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
public class DoctorScheduleDailyDTO {

    private LocalDate scheduleDate;

    private ScheduleSlotDTO morning;

    private ScheduleSlotDTO afternoon;
}
