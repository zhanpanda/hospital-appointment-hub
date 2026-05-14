package com.hospital.appointmenthub.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.hospital.appointmenthub.common.ReturnCode;
import com.hospital.appointmenthub.exception.BusinessException;
import com.hospital.appointmenthub.mapper.DoctorMapper;
import com.hospital.appointmenthub.mapper.ScheduleMapper;
import com.hospital.appointmenthub.model.dto.DoctorScheduleDailyDTO;
import com.hospital.appointmenthub.model.dto.ScheduleSlotDTO;
import com.hospital.appointmenthub.model.po.Doctor;
import com.hospital.appointmenthub.model.po.Schedule;
import com.hospital.appointmenthub.service.IScheduleService;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

/**
 * 医生排班服务实现.
 */
@Service
@RequiredArgsConstructor
public class ScheduleServiceImpl extends ServiceImpl<ScheduleMapper, Schedule> implements IScheduleService {

    private final DoctorMapper doctorMapper;

    @Override
    public List<DoctorScheduleDailyDTO> listNextSevenDaysByDoctorId(Long doctorId) {
        Doctor doctor = doctorMapper.selectById(doctorId);
        if (doctor == null || doctor.getStatus() == null || doctor.getStatus() != 1) {
            throw new BusinessException(ReturnCode.RC404.getCode(), "医生不存在");
        }

        LocalDate today = LocalDate.now();
        LocalDate endDate = today.plusDays(6);

        List<Schedule> schedules = lambdaQuery()
                .eq(Schedule::getDoctorId, doctorId)
                .between(Schedule::getScheduleDate, today, endDate)
                .orderByAsc(Schedule::getScheduleDate)
                .orderByAsc(Schedule::getTimeSlot)
                .list();

        Map<LocalDate, Map<Integer, Schedule>> scheduleMap = schedules.stream()
                .collect(Collectors.groupingBy(
                        Schedule::getScheduleDate,
                        Collectors.toMap(Schedule::getTimeSlot, Function.identity(), (first, second) -> first)
                ));

        List<DoctorScheduleDailyDTO> result = new ArrayList<>();
        for (int i = 0; i < 7; i++) {
            LocalDate targetDate = today.plusDays(i);
            Map<Integer, Schedule> dailyMap = scheduleMap.getOrDefault(targetDate, Map.of());

            DoctorScheduleDailyDTO dailyDTO = new DoctorScheduleDailyDTO();
            dailyDTO.setScheduleDate(targetDate);
            dailyDTO.setMorning(ScheduleSlotDTO.from(dailyMap.get(1)));
            dailyDTO.setAfternoon(ScheduleSlotDTO.from(dailyMap.get(2)));
            result.add(dailyDTO);
        }

        result.sort(Comparator.comparing(DoctorScheduleDailyDTO::getScheduleDate));
        return result;
    }
}
