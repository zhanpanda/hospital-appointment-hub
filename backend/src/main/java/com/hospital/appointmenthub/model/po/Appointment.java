package com.hospital.appointmenthub.model.po;

import com.baomidou.mybatisplus.annotation.FieldFill;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.time.LocalDate;
import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 预约记录表.
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
@TableName("appointments")
public class Appointment {

    /** 预约ID */
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    /** 预约号 */
    private String appointmentNo;

    /** 患者ID */
    private Long patientId;

    /** 就诊人ID */
    private Long memberId;

    /** 医生ID */
    private Long doctorId;

    /** 排班ID */
    private Long scheduleId;

    /** 科室ID */
    private Long departmentId;

    /** 预约日期 */
    private LocalDate appointmentDate;

    /** 预约时段：1-上午，2-下午 */
    private Integer timeSlot;

    /** 状态：1-待就诊，2-已取消，3-已完成 */
    private Integer status;

    /** 取消时间 */
    private LocalDateTime cancelTime;

    /** 是否已发送通知：0-未发送，1-已发送 */
    private Integer notificationSent;

    /** 备注 */
    private String remark;

    /** 预约创建时间 */
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;

    /** 更新时间 */
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updatedAt;
}
