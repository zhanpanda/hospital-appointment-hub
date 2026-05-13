package com.hospital.appointmenthub.model.po;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.FieldFill;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.time.LocalDate;
import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 就诊人表
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
@TableName("family_members")
public class FamilyMember {

    /** 就诊人ID */
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    /** 所属患者ID */
    private Integer patientId;

    /** 就诊人姓名 */
    private String name;

    /** 身份证号 */
    private String idCard;

    /** 手机号 */
    private String phone;

    /** 性别：1-男，2-女 */
    private Integer gender;

    /** 出生日期 */
    private LocalDate birthDate;

    /** 与患者关系：本人/配偶/子女/父母/其他 */
    private String relationship;

    /** 是否默认就诊人：1-是，0-否 */
    private Integer isDefault;

    /** 创建时间 */
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;

    /** 更新时间 */
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updatedAt;
}
