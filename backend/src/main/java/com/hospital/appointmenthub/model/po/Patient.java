package com.hospital.appointmenthub.model.po;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.FieldFill;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 患者用户表
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
@TableName("patients")
public class Patient {

    /** 患者ID */
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    /** 手机号（手机号或邮箱二选一必填） */
    private String phone;

    /** 邮箱 */
    private String email;

    /** 加密后的密码 */
    private String password;

    /** 昵称 */
    private String nickname;

    /** 头像地址 */
    private String avatar;

    /** 账号状态：1-正常，0-禁用 */
    private Integer status;

    /** 注册时间 */
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;

    /** 更新时间 */
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updatedAt;
}
