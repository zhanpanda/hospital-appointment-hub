package com.hospital.appointmenthub.mapper;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.hospital.appointmenthub.model.dto.AppointmentItemDTO;
import com.hospital.appointmenthub.model.po.Appointment;
import org.apache.ibatis.annotations.Param;

/**
 * 预约记录 Mapper.
 */
public interface AppointmentMapper extends BaseMapper<Appointment> {

    IPage<AppointmentItemDTO> pageByPatientId(Page<AppointmentItemDTO> page, @Param("patientId") Long patientId);
}
