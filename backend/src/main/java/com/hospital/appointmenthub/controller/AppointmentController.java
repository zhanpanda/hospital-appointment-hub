package com.hospital.appointmenthub.controller;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.hospital.appointmenthub.common.Result;
import com.hospital.appointmenthub.model.dto.AppointmentCreateDTO;
import com.hospital.appointmenthub.model.dto.AppointmentItemDTO;
import com.hospital.appointmenthub.model.dto.AppointmentSubmitResultDTO;
import com.hospital.appointmenthub.service.IAppointmentService;
import com.hospital.appointmenthub.util.PatientContext;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 预约记录接口.
 */
@RestController
@RequestMapping("/api/appointments")
@RequiredArgsConstructor
@Validated
public class AppointmentController {

    private final IAppointmentService appointmentService;

    @GetMapping
    public Result<IPage<AppointmentItemDTO>> pageByPatientId(
            @RequestParam(defaultValue = "1") @Min(value = 1, message = "页码必须大于等于1") long pageNum,
            @RequestParam(defaultValue = "10") @Min(value = 1, message = "每页条数必须大于等于1") long pageSize
    ) {
        Long patientId = PatientContext.getPatientId();
        return Result.success(appointmentService.pageByPatientId(patientId, pageNum, pageSize));
    }

    @PostMapping
    public Result<AppointmentSubmitResultDTO> create(@Valid @RequestBody AppointmentCreateDTO appointmentCreateDTO) {
        Long patientId = PatientContext.getPatientId();
        return Result.success(appointmentService.create(patientId, appointmentCreateDTO));
    }

    @PutMapping("/{id}/cancel")
    public Result<Void> cancel(@PathVariable("id") @NotNull(message = "预约ID不能为空") Long id) {
        Long patientId = PatientContext.getPatientId();
        appointmentService.cancel(patientId, id);
        return Result.success();
    }
}
