package com.hospital.appointmenthub.model.dto;

import com.hospital.appointmenthub.model.po.Schedule;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 排班时段信息.
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
public class ScheduleSlotDTO {

    private Long id;

    private Integer timeSlot;

    private Integer totalQuota;

    private Integer remainingQuota;

    private Integer status;

    public static ScheduleSlotDTO from(Schedule schedule) {
        if (schedule == null) {
            return null;
        }

        ScheduleSlotDTO dto = new ScheduleSlotDTO();
        dto.setId(schedule.getId());
        dto.setTimeSlot(schedule.getTimeSlot());
        dto.setTotalQuota(schedule.getTotalQuota());
        dto.setRemainingQuota(schedule.getRemainingQuota());
        dto.setStatus(schedule.getStatus());
        return dto;
    }
}
