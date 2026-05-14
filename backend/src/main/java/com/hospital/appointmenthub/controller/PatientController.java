package com.hospital.appointmenthub.controller;

import com.hospital.appointmenthub.common.Result;
import com.hospital.appointmenthub.model.dto.LoginPatientDTO;
import com.hospital.appointmenthub.model.dto.RegisterPatientDTO;
import com.hospital.appointmenthub.service.IPatientService;
import com.hospital.appointmenthub.util.PatientContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 患者接口
 */
@RestController
@RequestMapping("/api/patient")
public class PatientController {

    @Autowired
    private IPatientService patientService;

    /**
     * 手机号注册
     */
    @PostMapping("/register/phone")
    public Result<String> registerByPhone(@RequestBody @Validated(RegisterPatientDTO.PhoneRegister.class) RegisterPatientDTO registerPatientDTO) {
        String token = patientService.registerByPhone(registerPatientDTO);
        return Result.success(token);
    }

    /**
     * 邮箱注册
     */
    @PostMapping("/register/email")
    public Result<String> registerByEmail(@RequestBody @Validated(RegisterPatientDTO.EmailRegister.class) RegisterPatientDTO registerPatientDTO) {
        String token = patientService.registerByEmail(registerPatientDTO);
        return Result.success(token);
    }

    /**
     * 手机号注册
     */
    @PostMapping("/login/phone")
    public Result<String> loginByPhone(@RequestBody @Validated(LoginPatientDTO.PhoneLogin.class) LoginPatientDTO loginPatientDTO) {
        String token = patientService.loginByPhone(loginPatientDTO);
        return Result.success(token);
    }

    /**
     * 邮箱注册
     */
    @PostMapping("/login/email")
    public Result<String> loginByEmail(@RequestBody @Validated(LoginPatientDTO.EmailLogin.class) LoginPatientDTO loginPatientDTO) {
        String token = patientService.loginByEmail(loginPatientDTO);
        return Result.success(token);
    }

    /**
     * 退出登录
     */
    @PostMapping("/logout")
    public Result<Void> logout() {
        patientService.logout(PatientContext.getPatientId());
        return Result.success();
    }
}
