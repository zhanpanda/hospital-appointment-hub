package com.hospital.appointmenthub.controller;

import com.hospital.appointmenthub.common.Result;
import com.hospital.appointmenthub.model.dto.DoctorScheduleDailyDTO;
import com.hospital.appointmenthub.service.IScheduleService;
import jakarta.validation.constraints.NotNull;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 医生排班接口.
 */
@RestController
@RequestMapping("/api/schedules")
@RequiredArgsConstructor
@Validated
public class ScheduleController {

    private final IScheduleService scheduleService;

    @GetMapping
    public Result<List<DoctorScheduleDailyDTO>> listNextSevenDaysByDoctorId(
            @RequestParam @NotNull(message = "医生ID不能为空") Long doctorId
    ) {
        return Result.success(scheduleService.listNextSevenDaysByDoctorId(doctorId));
    }
}
