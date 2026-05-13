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
 * 科室表.
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
@TableName("departments")
public class Department {

    /** 科室ID */
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    /** 科室名称 */
    private String name;

    /** 排序序号 */
    private Integer sortOrder;

    /** 状态：1-启用，0-停用 */
    private Integer status;

    /** 创建时间 */
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;

    /** 更新时间 */
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updatedAt;
}
