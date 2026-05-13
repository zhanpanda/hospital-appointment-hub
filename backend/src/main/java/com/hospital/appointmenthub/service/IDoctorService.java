package com.hospital.appointmenthub.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.IService;
import com.hospital.appointmenthub.model.dto.DoctorDetailDTO;
import com.hospital.appointmenthub.model.dto.DoctorItemDTO;
import com.hospital.appointmenthub.model.po.Doctor;

public interface IDoctorService extends IService<Doctor> {

    IPage<DoctorItemDTO> pageByDepartmentId(Long departmentId, long pageNum, long pageSize);

    DoctorDetailDTO getDetail(Long id);
}
