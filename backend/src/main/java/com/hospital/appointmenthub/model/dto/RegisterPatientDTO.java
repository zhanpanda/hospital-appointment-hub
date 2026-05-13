package com.hospital.appointmenthub.model.dto;

import com.hospital.appointmenthub.common.RegexpConstant;
import com.hospital.appointmenthub.model.po.Patient;
import com.hospital.appointmenthub.validator.FieldMatch;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.groups.Default;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 患者注册DTO
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
@FieldMatch(field1 = "password", field2 = "confirmPassword", fieldType = String.class) // 验证两次密码是否一致
public class RegisterPatientDTO {
    /** 手机号 */
    @NotBlank(message = "手机号不能为空", groups = {PhoneRegister.class})
    @Pattern(regexp= RegexpConstant.PHONE, message=RegexpConstant.PHONE_MESSAGE, groups = {PhoneRegister.class})
    private String phone;

    /** 邮件 */
    @NotBlank(message = "邮箱不能为空", groups = {EmailRegister.class})
    @Email(message = "邮箱格式错误，请输入正确的邮箱", groups = {EmailRegister.class})
    private String email;

    /** 密码 */
    @NotBlank(message = "密码不能为空")
    @Pattern(regexp= RegexpConstant.PASSWORD, message=RegexpConstant.PASSWORD_MESSAGE)
    private String password;

    /** 确认密码 */
    @NotBlank(message = "确认密码不能为空")
    private String confirmPassword;



    // 继承 Default 接口
    // 当 Controller 使用@Validated（PhoneRegister.class）时
    // 不仅会校验 phone，还会自动校验 password 和 confirmPassword这种通用（default）字段
    public interface PhoneRegister extends Default {}

    public interface EmailRegister extends Default{}


    public static Patient toEntity(RegisterPatientDTO registerPatientDTO) {
        Patient patient = new Patient();
        patient.setPhone(registerPatientDTO.getPhone());
        patient.setEmail(registerPatientDTO.getEmail());
        patient.setPassword(registerPatientDTO.getPassword());

        return patient;
    }

    public static RegisterPatientDTO buildPhoneRegisterDTO(RegisterPatientDTO registerPatientDTO) {
        RegisterPatientDTO target = new RegisterPatientDTO();
        target.setPhone(registerPatientDTO.getPhone());
        target.setPassword(registerPatientDTO.getPassword());
        target.setConfirmPassword(registerPatientDTO.getConfirmPassword());
        return target;
    }

    public static RegisterPatientDTO buildEmailRegisterDTO(RegisterPatientDTO registerPatientDTO) {
        RegisterPatientDTO target = new RegisterPatientDTO();
        target.setEmail(registerPatientDTO.getEmail());
        target.setPassword(registerPatientDTO.getPassword());
        target.setConfirmPassword(registerPatientDTO.getConfirmPassword());
        return target;
    }
}
