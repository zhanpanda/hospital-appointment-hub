package com.hospital.appointmenthub.validator;


import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import org.springframework.beans.BeanWrapper;
import org.springframework.beans.BeanWrapperImpl;

import java.util.Objects;

public class FieldMatchValidator implements ConstraintValidator<FieldMatch, Object> {

    private String field1Path; // 字段1的路径（如 "password" 或 "user.email")
    private String field2Path; // 字段2的路径
    private Class<?> fieldType; // 字段约束类型
    private String typeMessageTemplate; // 注解中的 typeMessage

    @Override
    public void initialize(FieldMatch constraintAnnotation) {
        this.field1Path = constraintAnnotation.field1();
        this.field2Path = constraintAnnotation.field2();
        this.fieldType = constraintAnnotation.fieldType();
        this.typeMessageTemplate = constraintAnnotation.typeMessage();
    }

    @Override
    public boolean isValid(Object target, ConstraintValidatorContext constraintValidatorContext) {
        // 使用 Spring 的 BeanWrapper 解析嵌套路径
        BeanWrapper wrapper = new BeanWrapperImpl(target);
        Object value1 = wrapper.getPropertyValue(field1Path);
        Object value2 = wrapper.getPropertyValue(field2Path);

        // 1. 类型校验
        if(fieldType != Object.class) {
            if(!isTypeValid(value1, value2, constraintValidatorContext)) {
                return false;
            }
        }

        // 2. 值校验
        boolean matches = Objects.equals(value1, value2);
        if(!matches) {
            addValueMismatchMessage(constraintValidatorContext);
        }
        return matches;
    }

    private void addValueMismatchMessage(ConstraintValidatorContext constraintValidatorContext) {
        String finalMessage = constraintValidatorContext.getDefaultConstraintMessageTemplate()
                .replace("{field1}", field1Path)
                .replace("{field2}", field2Path);
        constraintValidatorContext.disableDefaultConstraintViolation(); // 禁用默认错误消息
        constraintValidatorContext.buildConstraintViolationWithTemplate(finalMessage) // 用自定义消息新建一条错误
                .addPropertyNode(field2Path) // 绑定到具体字段
                .addConstraintViolation(); // 提交这条错误
    }




    private boolean isTypeValid(Object value1, Object value2, ConstraintValidatorContext context) {
        if(fieldType.isInstance(value1) && fieldType.isInstance(value2)) {
            return true;
        }

        // 替换 {type} 占位符
        String finalMessage = typeMessageTemplate.replace("{type}", fieldType.getSimpleName());

        // 构建类型错误消息
        context.disableDefaultConstraintViolation(); // 禁用默认错误消息（默认情况下，校验器会使用注解里message()属性的值作为错误消息）

        context.buildConstraintViolationWithTemplate(finalMessage) // 用自定义消息新建一条错误
                .addPropertyNode(field2Path) // 绑定到具体字段
                .addConstraintViolation(); // 提交这条错误
        return false;
    }
}
