package com.hospital.appointmenthub.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.hospital.appointmenthub.common.PatientStatus;
import com.hospital.appointmenthub.common.RedisConstant;
import com.hospital.appointmenthub.common.ReturnCode;
import com.hospital.appointmenthub.exception.BusinessException;
import com.hospital.appointmenthub.mapper.PatientMapper;
import com.hospital.appointmenthub.model.dto.LoginPatientDTO;
import com.hospital.appointmenthub.model.dto.RegisterPatientDTO;
import com.hospital.appointmenthub.model.po.Patient;
import com.hospital.appointmenthub.properties.JwtProperties;
import com.hospital.appointmenthub.service.IPatientService;
import com.hospital.appointmenthub.util.BCryptUtil;
import com.hospital.appointmenthub.util.JwtUtil;
import java.time.Duration;
import lombok.RequiredArgsConstructor;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

/**
 * 患者服务实现
 */
@Service
@RequiredArgsConstructor
public class PatientServiceImpl extends ServiceImpl<PatientMapper, Patient> implements IPatientService {

    private final JwtUtil jwtUtil;
    private final JwtProperties jwtProperties;
    private final StringRedisTemplate stringRedisTemplate;

    @Override
    public String registerByPhone(RegisterPatientDTO registerPatientDTO) {
        long count = lambdaQuery()
                .eq(Patient::getPhone, registerPatientDTO.getPhone())
                .count();
        if (count > 0) {
            throw new BusinessException(ReturnCode.USER_ALREADY_EXISTS.getCode(), "手机号已存在");
        }
        Patient patient = savePatient(RegisterPatientDTO.buildPhoneRegisterDTO(registerPatientDTO), "手机号已存在");
        return issueToken(patient.getId());
    }

    @Override
    public String registerByEmail(RegisterPatientDTO registerPatientDTO) {
        long count = lambdaQuery()
                .eq(Patient::getEmail, registerPatientDTO.getEmail())
                .count();
        if (count > 0) {
            throw new BusinessException(ReturnCode.USER_ALREADY_EXISTS.getCode(), "邮箱已存在");
        }
        Patient patient = savePatient(RegisterPatientDTO.buildEmailRegisterDTO(registerPatientDTO), "邮箱已存在");
        return issueToken(patient.getId());
    }

    @Override
    public String loginByPhone(LoginPatientDTO loginPatientDTO) {
        Patient patient = lambdaQuery()
                .eq(Patient::getPhone, loginPatientDTO.getPhone())
                .one();
        validateLoginPatient(patient, loginPatientDTO.getPassword());
        return issueToken(patient.getId());
    }

    @Override
    public String loginByEmail(LoginPatientDTO loginPatientDTO) {
        Patient patient = lambdaQuery()
                .eq(Patient::getEmail, loginPatientDTO.getEmail())
                .one();
        validateLoginPatient(patient, loginPatientDTO.getPassword());
        return issueToken(patient.getId());
    }

    @Override
    public void logout(Long patientId) {
        if (patientId == null) {
            throw new BusinessException(ReturnCode.USER_NOT_LOGIN);
        }
        stringRedisTemplate.delete(buildPatientTokenKey(patientId));
    }

    private Patient savePatient(RegisterPatientDTO registerPatientDTO, String duplicateMessage) {
        Patient patient = RegisterPatientDTO.toEntity(registerPatientDTO);
        patient.setPassword(BCryptUtil.encode(registerPatientDTO.getPassword()));
        patient.setStatus(PatientStatus.NORMAL.getCode());

        try {
            boolean saved = save(patient);
            if (!saved || patient.getId() == null) {
                throw new BusinessException(ReturnCode.RC500.getCode(), "注册失败");
            }
        } catch (DuplicateKeyException exception) {
            throw new BusinessException(ReturnCode.USER_ALREADY_EXISTS.getCode(), duplicateMessage);
        }
        return patient;
    }

    private void validateLoginPatient(Patient patient, String rawPassword) {
        if (patient == null) {
            throw new BusinessException(ReturnCode.USER_NOT_FOUND);
        }
        if (patient.getStatus() == null || patient.getStatus() != PatientStatus.NORMAL.getCode()) {
            throw new BusinessException(ReturnCode.USER_DISABLED);
        }
        if (!BCryptUtil.matches(rawPassword, patient.getPassword())) {
            throw new BusinessException(ReturnCode.PASSWORD_ERROR);
        }
    }

    private String issueToken(Long patientId) {
        String token = jwtUtil.generateToken(patientId);
        stringRedisTemplate.opsForValue().set(
                buildPatientTokenKey(patientId),
                token,
                Duration.ofMillis(jwtProperties.getExpireTime())
        );
        return token;
    }

    private String buildPatientTokenKey(Long patientId) {
        return RedisConstant.PATIENT_TOKEN_PREFIX + patientId;
    }
}
