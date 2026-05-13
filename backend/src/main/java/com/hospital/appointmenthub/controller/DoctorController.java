package com.hospital.appointmenthub.controller;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.hospital.appointmenthub.common.Result;
import com.hospital.appointmenthub.model.dto.DoctorDetailDTO;
import com.hospital.appointmenthub.model.dto.DoctorItemDTO;
import com.hospital.appointmenthub.service.IDoctorService;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 医生接口.
 */
@RestController
@RequestMapping("/api/doctors")
@RequiredArgsConstructor
@Validated
public class DoctorController {

    private final IDoctorService doctorService;

    @GetMapping
    public Result<IPage<DoctorItemDTO>> pageByDepartmentId(
            @RequestParam @NotNull(message = "科室ID不能为空") Long departmentId,
            @RequestParam(defaultValue = "1") @Min(value = 1, message = "页码必须大于等于1") long pageNum,
            @RequestParam(defaultValue = "10") @Min(value = 1, message = "每页条数必须大于等于1") long pageSize
    ) {
        return Result.success(doctorService.pageByDepartmentId(departmentId, pageNum, pageSize));
    }

    @GetMapping("/{id}")
    public Result<DoctorDetailDTO> getDetail(@PathVariable Long id) {
        return Result.success(doctorService.getDetail(id));
    }
}
