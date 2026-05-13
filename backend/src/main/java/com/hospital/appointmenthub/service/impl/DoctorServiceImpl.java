package com.hospital.appointmenthub.service.impl;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.hospital.appointmenthub.common.ReturnCode;
import com.hospital.appointmenthub.exception.BusinessException;
import com.hospital.appointmenthub.mapper.DoctorMapper;
import com.hospital.appointmenthub.model.dto.DoctorDetailDTO;
import com.hospital.appointmenthub.model.dto.DoctorItemDTO;
import com.hospital.appointmenthub.model.po.Doctor;
import com.hospital.appointmenthub.service.IDoctorService;
import java.util.List;
import org.springframework.stereotype.Service;

/**
 * 医生服务实现.
 */
@Service
public class DoctorServiceImpl extends ServiceImpl<DoctorMapper, Doctor> implements IDoctorService {

    @Override
    public IPage<DoctorItemDTO> pageByDepartmentId(Long departmentId, long pageNum, long pageSize) {
        Page<Doctor> page = lambdaQuery()
                .eq(Doctor::getDepartmentId, departmentId)
                .eq(Doctor::getStatus, 1)
                .orderByAsc(Doctor::getId)
                .page(new Page<>(pageNum, pageSize));

        List<DoctorItemDTO> records = page.getRecords()
                .stream()
                .map(DoctorItemDTO::from)
                .toList();

        Page<DoctorItemDTO> result = new Page<>(page.getCurrent(), page.getSize(), page.getTotal());
        result.setRecords(records);
        return result;
    }

    @Override
    public DoctorDetailDTO getDetail(Long id) {
        Doctor doctor = lambdaQuery()
                .eq(Doctor::getId, id)
                .eq(Doctor::getStatus, 1)
                .one();
        if (doctor == null) {
            throw new BusinessException(ReturnCode.RC404.getCode(), "医生不存在");
        }
        return DoctorDetailDTO.from(doctor);
    }
}
