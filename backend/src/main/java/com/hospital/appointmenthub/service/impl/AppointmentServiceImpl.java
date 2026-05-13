package com.hospital.appointmenthub.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.hospital.appointmenthub.mapper.AppointmentMapper;
import com.hospital.appointmenthub.model.po.Appointment;
import com.hospital.appointmenthub.service.IAppointmentService;
import org.springframework.stereotype.Service;

/**
 * 预约记录服务实现.
 */
@Service
public class AppointmentServiceImpl extends ServiceImpl<AppointmentMapper, Appointment> implements IAppointmentService {
}
