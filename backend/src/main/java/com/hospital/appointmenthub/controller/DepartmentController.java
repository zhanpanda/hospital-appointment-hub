package com.hospital.appointmenthub.controller;

import com.hospital.appointmenthub.common.Result;
import com.hospital.appointmenthub.model.po.Department;
import com.hospital.appointmenthub.service.IDepartmentService;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 科室接口.
 */
@RestController
@RequestMapping("/api/departments")
@RequiredArgsConstructor
public class DepartmentController {

    private final IDepartmentService departmentService;

    @GetMapping
    public Result<List<Department>> listDepartments() {
        return Result.success(departmentService.listDepartments());
    }
}
