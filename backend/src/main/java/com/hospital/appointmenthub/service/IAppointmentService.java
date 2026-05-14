package com.hospital.appointmenthub.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.IService;
import com.hospital.appointmenthub.model.dto.AppointmentCreateDTO;
import com.hospital.appointmenthub.model.dto.AppointmentItemDTO;
import com.hospital.appointmenthub.model.dto.AppointmentSubmitResultDTO;
import com.hospital.appointmenthub.model.po.Appointment;

public interface IAppointmentService extends IService<Appointment> {

    AppointmentSubmitResultDTO create(Long patientId, AppointmentCreateDTO appointmentCreateDTO);

    IPage<AppointmentItemDTO> pageByPatientId(Long patientId, long pageNum, long pageSize);

    void cancel(Long patientId, Long appointmentId);
}
