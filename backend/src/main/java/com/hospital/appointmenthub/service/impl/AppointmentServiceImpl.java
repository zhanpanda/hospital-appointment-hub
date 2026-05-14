package com.hospital.appointmenthub.service.impl;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.hospital.appointmenthub.common.ReturnCode;
import com.hospital.appointmenthub.exception.BusinessException;
import com.hospital.appointmenthub.mapper.AppointmentMapper;
import com.hospital.appointmenthub.mapper.DoctorMapper;
import com.hospital.appointmenthub.model.dto.AppointmentCreateDTO;
import com.hospital.appointmenthub.model.dto.AppointmentItemDTO;
import com.hospital.appointmenthub.model.dto.AppointmentSubmitResultDTO;
import com.hospital.appointmenthub.model.po.Appointment;
import com.hospital.appointmenthub.model.po.Doctor;
import com.hospital.appointmenthub.model.po.FamilyMember;
import com.hospital.appointmenthub.model.po.Schedule;
import com.hospital.appointmenthub.service.IFamilyMemberService;
import com.hospital.appointmenthub.service.IAppointmentService;
import com.hospital.appointmenthub.service.IScheduleService;
import com.hospital.appointmenthub.util.RedisIdWorker;
import java.time.LocalDateTime;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.dao.DuplicateKeyException;

/**
 * 预约记录服务实现.
 */
@Service
@RequiredArgsConstructor
public class AppointmentServiceImpl extends ServiceImpl<AppointmentMapper, Appointment> implements IAppointmentService {

    private final IScheduleService scheduleService;

    private final IFamilyMemberService familyMemberService;

    private final DoctorMapper doctorMapper;

    private final RedisIdWorker redisIdWorker;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public AppointmentSubmitResultDTO create(Long patientId, AppointmentCreateDTO appointmentCreateDTO) {
        if (patientId == null) {
            throw new BusinessException(ReturnCode.USER_NOT_LOGIN);
        }

        FamilyMember familyMember = familyMemberService.lambdaQuery()
                .eq(FamilyMember::getId, appointmentCreateDTO.getFamilyMemberId())
                .eq(FamilyMember::getPatientId, patientId)
                .one();
        if (familyMember == null) {
            throw new BusinessException(ReturnCode.RC404.getCode(), "就诊人不存在");
        }

        Schedule schedule = scheduleService.lambdaQuery()
                .eq(Schedule::getId, appointmentCreateDTO.getScheduleId())
                .one();
        if (schedule == null) {
            throw new BusinessException(ReturnCode.RC404.getCode(), "排班不存在");
        }

        if (schedule.getStatus() == null || schedule.getStatus() == 3) {
            throw new BusinessException(ReturnCode.RC422.getCode(), "当前排班已停诊");
        }
        if (schedule.getRemainingQuota() == null || schedule.getRemainingQuota() <= 0 || schedule.getStatus() == 2) {
            throw new BusinessException(ReturnCode.RC422.getCode(), "当前号源已约满");
        }

        Long departmentId = getDepartmentIdFromSchedule(schedule);
        boolean duplicated = lambdaQuery()
                .eq(Appointment::getMemberId, familyMember.getId())
                .eq(Appointment::getDepartmentId, departmentId)
                .eq(Appointment::getAppointmentDate, schedule.getScheduleDate())
                .ne(Appointment::getStatus, 2)
                .exists();
        if (duplicated) {
            throw new BusinessException(ReturnCode.RC409.getCode(), "同一就诊人同一科室同一天只能预约一次");
        }

        boolean updated = scheduleService.lambdaUpdate()
                .eq(Schedule::getId, schedule.getId())
                .gt(Schedule::getRemainingQuota, 0)
                .set(Schedule::getRemainingQuota, schedule.getRemainingQuota() - 1)
                .set(
                        Schedule::getStatus,
                        schedule.getRemainingQuota() - 1 <= 0 ? 2 : 1
                )
                .update();
        if (!updated) {
            throw new BusinessException(ReturnCode.RC422.getCode(), "当前号源已约满");
        }

        Appointment appointment = new Appointment();
        appointment.setAppointmentNo(buildAppointmentNo());
        appointment.setPatientId(patientId);
        appointment.setMemberId(familyMember.getId());
        appointment.setDoctorId(schedule.getDoctorId());
        appointment.setScheduleId(schedule.getId());
        appointment.setDepartmentId(departmentId);
        appointment.setAppointmentDate(schedule.getScheduleDate());
        appointment.setTimeSlot(schedule.getTimeSlot());
        appointment.setStatus(1);
        appointment.setNotificationSent(0);
        appointment.setRemark("请按预约时段提前到院签到。");

        try {
            boolean saved = save(appointment);
            if (!saved) {
                throw new BusinessException(ReturnCode.RC500.getCode(), "预约提交失败");
            }
        } catch (DuplicateKeyException exception) {
            throw new BusinessException(ReturnCode.RC409.getCode(), "同一就诊人同一科室同一天只能预约一次");
        }

        Integer latestRemainingQuota = schedule.getRemainingQuota() == null ? 0 : schedule.getRemainingQuota() - 1;
        schedule.setRemainingQuota(Math.max(latestRemainingQuota, 0));
        schedule.setStatus(schedule.getRemainingQuota() <= 0 ? 2 : 1);

        return AppointmentSubmitResultDTO.from(appointment, schedule, familyMember);
    }

    @Override
    public IPage<AppointmentItemDTO> pageByPatientId(Long patientId, long pageNum, long pageSize) {
        if (patientId == null) {
            throw new BusinessException(ReturnCode.USER_NOT_LOGIN);
        }
        IPage<AppointmentItemDTO> page = baseMapper.pageByPatientId(new Page<>(pageNum, pageSize), patientId);
        page.getRecords().forEach(item ->
                item.setCanCancel(Boolean.TRUE.equals(canCancel(item.getStatus(), item.getCreatedAt())))
        );
        return page;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void cancel(Long patientId, Long appointmentId) {
        if (patientId == null) {
            throw new BusinessException(ReturnCode.USER_NOT_LOGIN);
        }

        Appointment appointment = lambdaQuery()
                .eq(Appointment::getId, appointmentId)
                .eq(Appointment::getPatientId, patientId)
                .one();
        if (appointment == null) {
            throw new BusinessException(ReturnCode.RC404.getCode(), "预约记录不存在");
        }
        if (appointment.getStatus() == null || appointment.getStatus() != 1) {
            throw new BusinessException(ReturnCode.RC422.getCode(), "当前预约状态不可取消");
        }
        if (!canCancel(appointment.getStatus(), appointment.getCreatedAt())) {
            throw new BusinessException(ReturnCode.RC422.getCode(), "预约后30分钟内可取消，当前已不可取消");
        }

        appointment.setStatus(2);
        appointment.setCancelTime(LocalDateTime.now());
        appointment.setRemark("用户主动取消预约");
        boolean updatedAppointment = updateById(appointment);
        if (!updatedAppointment) {
            throw new BusinessException(ReturnCode.RC500.getCode(), "取消预约失败");
        }

        Schedule schedule = scheduleService.getById(appointment.getScheduleId());
        if (schedule != null) {
            Integer nextRemainingQuota = (schedule.getRemainingQuota() == null ? 0 : schedule.getRemainingQuota()) + 1;
            schedule.setRemainingQuota(nextRemainingQuota);
            if (schedule.getStatus() != null && schedule.getStatus() != 3) {
                schedule.setStatus(1);
            }
            scheduleService.updateById(schedule);
        }
    }

    private Long getDepartmentIdFromSchedule(Schedule schedule) {
        Doctor doctor = doctorMapper.selectById(schedule.getDoctorId());
        if (doctor == null || doctor.getDepartmentId() == null) {
            throw new BusinessException(ReturnCode.RC404.getCode(), "医生不存在");
        }
        return Long.valueOf(doctor.getDepartmentId());
    }

    private Long buildAppointmentNo() {
        return redisIdWorker.nextId("appointment");
    }

    private boolean canCancel(Integer status, LocalDateTime createdAt) {
        if (status == null || status != 1 || createdAt == null) {
            return false;
        }
        return createdAt.plusMinutes(30).isAfter(LocalDateTime.now());
    }
}
