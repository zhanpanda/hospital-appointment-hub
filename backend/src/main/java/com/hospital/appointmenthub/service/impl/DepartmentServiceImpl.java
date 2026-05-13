package com.hospital.appointmenthub.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.hospital.appointmenthub.mapper.DepartmentMapper;
import com.hospital.appointmenthub.model.po.Department;
import com.hospital.appointmenthub.service.IDepartmentService;
import java.util.List;
import org.springframework.stereotype.Service;

/**
 * 科室服务实现.
 */
@Service
public class DepartmentServiceImpl extends ServiceImpl<DepartmentMapper, Department> implements IDepartmentService {

    @Override
    public List<Department> listDepartments() {
        return lambdaQuery()
                .eq(Department::getStatus, 1)
                .orderByAsc(Department::getSortOrder)
                .orderByAsc(Department::getId)
                .list();
    }
}
