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
 * 医生排班表.
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
@TableName("schedules")
public class Schedule {

    /** 排班ID */
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    /** 医生ID */
    private Long doctorId;

    /** 排班日期 */
    private LocalDate scheduleDate;

    /** 时段：1-上午，2-下午 */
    private Integer timeSlot;

    /** 总号源数 */
    private Integer totalQuota;

    /** 剩余可预约数 */
    private Integer remainingQuota;

    /** 状态：1-可预约，2-已约满，3-停诊 */
    private Integer status;

    /** 创建时间 */
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;

    /** 更新时间 */
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updatedAt;
}
