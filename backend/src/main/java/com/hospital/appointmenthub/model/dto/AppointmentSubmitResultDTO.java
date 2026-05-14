package com.hospital.appointmenthub.model.dto;

import com.hospital.appointmenthub.model.po.Appointment;
import com.hospital.appointmenthub.model.po.FamilyMember;
import com.hospital.appointmenthub.model.po.Schedule;
import java.time.LocalDate;
import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 预约提交结果.
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
public class AppointmentSubmitResultDTO {

    private Long appointmentId;

    private Long appointmentNo;

    private Long scheduleId;

    private Long familyMemberId;

    private String familyMemberName;

    private Long doctorId;

    private Long departmentId;

    private LocalDate appointmentDate;

    private Integer timeSlot;

    private Integer status;

    private List<String> notices;

    public static AppointmentSubmitResultDTO from(
            Appointment appointment,
            Schedule schedule,
            FamilyMember familyMember
    ) {
        AppointmentSubmitResultDTO dto = new AppointmentSubmitResultDTO();
        dto.setAppointmentId(appointment.getId());
        dto.setAppointmentNo(appointment.getAppointmentNo());
        dto.setScheduleId(schedule.getId());
        dto.setFamilyMemberId(familyMember.getId());
        dto.setFamilyMemberName(familyMember.getName());
        dto.setDoctorId(appointment.getDoctorId());
        dto.setDepartmentId(appointment.getDepartmentId());
        dto.setAppointmentDate(appointment.getAppointmentDate());
        dto.setTimeSlot(appointment.getTimeSlot());
        dto.setStatus(appointment.getStatus());
        dto.setNotices(List.of(
                "请在就诊当日提前到院签到取号。",
                "请携带就诊人有效身份证件按时就诊。",
                "如需取消预约，请尽量提前操作。"
        ));
        return dto;
    }
}
