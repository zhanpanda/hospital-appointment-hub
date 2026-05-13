package com.hospital.appointmenthub.validator;


import jakarta.validation.Constraint;
import jakarta.validation.Payload;

import java.lang.annotation.*;

@Target({ElementType.TYPE}) // 自定注解可作用的Java元素范围；TYPE类、接口；METHOD方法；FIELD字段；PARAMETER参数；CONSTRUCTOR构造器
@Retention(RetentionPolicy.RUNTIME) // 指定注解的声明周期；SOURCE源码；CLASS保留在class文件，运行时丢弃（默认）；RUNTIME运行时保留，可通过反射解析
@Constraint(validatedBy = FieldMatchValidator.class) // 关联校验器
@Repeatable(FieldMatch.List.class) // 支持重复注解
@Documented // 指定注解是否被javadoc工具生成文档
public @interface FieldMatch {

    /**
     * 错误提示消息（支持 {field1} 和 {field2} 占位符
     * 默认消息实例："邮箱地址 必须与 确认邮箱 一致
     */
    String message() default "{field2} 必须与 {field1} 一致";

    /**
     * 校验分组（用于按场景分组校验）
     */
    Class<?>[] groups() default {};

    /**
     * 负载信息（通常用于自定义元数据）
     */
    Class<? extends Payload>[] payload() default {};

    /**
     * 第一个字段路径（支持嵌套路径，如 "user.email"、 "password")
     */
    String field1() default "";

    /**
     * 第二个字段路径（需与 field1 比较的字段）
     */
    String field2() default "";

    /**
     * 字段类型（可选，用于强制校验字段类型一致）
     * 实例：fieldType = String.class 确保两个字段均为字符串
     */
    Class<?> fieldType() default Object.class;

    /**
     * 字段类型错误提示消息（支持{type}占位符）
     * 默认消息实例："字段必须为 String 类型"
     * @return
     */
    String typeMessage() default "字段类型必须为 {type} 类型";

    @Target({ElementType.TYPE})
    @Retention(RetentionPolicy.RUNTIME)
    @Documented
    public @interface List {
        // 强制要求：名字必须叫 value，类型必须是单体注解的数组
        FieldMatch[] value();
    }

}
