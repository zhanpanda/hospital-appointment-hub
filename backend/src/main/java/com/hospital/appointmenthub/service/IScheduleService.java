package com.hospital.appointmenthub.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.hospital.appointmenthub.model.dto.DoctorScheduleDailyDTO;
import com.hospital.appointmenthub.model.po.Schedule;
import java.util.List;

public interface IScheduleService extends IService<Schedule> {

    List<DoctorScheduleDailyDTO> listNextSevenDaysByDoctorId(Long doctorId);
}
