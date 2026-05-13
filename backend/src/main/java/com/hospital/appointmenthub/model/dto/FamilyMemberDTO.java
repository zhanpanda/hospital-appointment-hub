package com.hospital.appointmenthub.model.dto;

import com.hospital.appointmenthub.common.RegexpConstant;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class FamilyMemberDTO {
    @NotBlank(message = "就诊人姓名不能为空")
    private String name;

    @NotBlank(message = "身份证号不能为空")
    @Pattern(regexp = RegexpConstant.ID_CARD, message = RegexpConstant.ID_CARD_MESSAGE)
    private String idCard;

    @NotBlank(message = "手机号不能为空")
    @Pattern(regexp = RegexpConstant.PHONE, message = RegexpConstant.PHONE_MESSAGE)
    private String phone;

    @NotNull(message = "与患者关系不能为空")
    private Integer relationship;

    @NotNull(message = "是否设为默认就诊人不能为空")
    private Boolean isDefault;
}
