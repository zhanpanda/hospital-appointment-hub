package com.hospital.appointmenthub.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.hospital.appointmenthub.mapper.ScheduleMapper;
import com.hospital.appointmenthub.model.po.Schedule;
import com.hospital.appointmenthub.service.IScheduleService;
import org.springframework.stereotype.Service;

/**
 * 医生排班服务实现.
 */
@Service
public class ScheduleServiceImpl extends ServiceImpl<ScheduleMapper, Schedule> implements IScheduleService {
}
