package com.hospital.appointmenthub.model.po;

import com.baomidou.mybatisplus.annotation.FieldFill;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 医生表.
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
@TableName("doctors")
public class Doctor {

    /** 医生ID */
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    /** 所属科室ID */
    private Integer departmentId;

    /** 医生姓名 */
    private String name;

    /** 职称 */
    private String title;

    /** 专长描述 */
    private String specialty;

    /** 医生简介 */
    private String introduction;

    /** 状态：1-在岗，0-离职 */
    private Integer status;

    /** 创建时间 */
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;

    /** 更新时间 */
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updatedAt;
}
