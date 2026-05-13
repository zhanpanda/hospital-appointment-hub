package com.hospital.appointmenthub.model.dto;

import com.hospital.appointmenthub.common.RegexpConstant;
import com.hospital.appointmenthub.model.po.Patient;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.groups.Default;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class LoginPatientDTO {
    /** 手机号 */
    @NotBlank(message = "手机号不能为空", groups = {PhoneLogin.class})
    @Pattern(regexp = RegexpConstant.PHONE, message = RegexpConstant.PHONE_MESSAGE, groups = {PhoneLogin.class})
    private String phone;

    /** 邮件 */
    @NotBlank(message = "邮箱不能为空", groups = {EmailLogin.class})
    @Email(message = "邮箱格式错误，请输入正确的邮箱", groups = {EmailLogin.class})
    private String email;

    /** 密码 */
    @NotBlank(message = "密码不能为空", groups = {PhoneLogin.class, EmailLogin.class})
    private String password;

    public interface PhoneLogin extends Default {}

    public interface EmailLogin extends Default {}


    public static Patient toEntity(LoginPatientDTO loginPatientDTO) {
        Patient patient = new Patient();
        patient.setPhone(loginPatientDTO.getPhone());
        patient.setEmail(loginPatientDTO.getEmail());
        patient.setPassword(loginPatientDTO.getPassword());

        return patient;
    }

}
