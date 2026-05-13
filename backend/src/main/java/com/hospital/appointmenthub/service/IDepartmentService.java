package com.hospital.appointmenthub.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.hospital.appointmenthub.model.po.Department;
import java.util.List;

public interface IDepartmentService extends IService<Department> {

    List<Department> listDepartments();
}
