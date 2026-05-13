package com.hospital.appointmenthub.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.hospital.appointmenthub.model.dto.LoginPatientDTO;
import com.hospital.appointmenthub.model.dto.RegisterPatientDTO;
import com.hospital.appointmenthub.model.po.Patient;

public interface IPatientService extends IService<Patient> {


    String registerByPhone(RegisterPatientDTO registerPatientDTO);


    String registerByEmail(RegisterPatientDTO registerPatientDTO);


    String loginByPhone(LoginPatientDTO loginPatientDTO);


    String loginByEmail(LoginPatientDTO loginPatientDTO);
}
