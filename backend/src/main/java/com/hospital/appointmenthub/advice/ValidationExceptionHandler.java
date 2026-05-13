package com.hospital.appointmenthub.advice;

import com.hospital.appointmenthub.common.Result;
import com.hospital.appointmenthub.common.ReturnCode;
import jakarta.validation.ConstraintViolationException;
import org.springframework.core.annotation.Order;
import org.springframework.http.HttpStatus;
import org.springframework.validation.BindException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.List;
import java.util.Map;

/**
 * 数据校验异常处理器
 * validation，在参数校验失败时，主要抛出3种不同的异常，对应着不同的参数传递场景
 * MethodArgumentNotValidException：当校验@RequestBody标注的对象参数时
 * ConstraintViolationException：直接在Controller方法的单个参数上使用校验注解，并且Controller类上加了@Validated
 * BindException 当接受表单提交，没有加@RequestBody时，对象绑定失败或校验失败抛出
 */
@Order(1)
@RestControllerAdvice
public class ValidationExceptionHandler {

    /**
     * 处理MethodArgumentNotValidException异常
     * 触发场景：当校验 @RequestBody标注的对象失败
     * 适用场景： JSON 请求参数校验
     * @param e MethodArgumentNotValidException
     * @return Result
     */
    @ExceptionHandler(MethodArgumentNotValidException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST) // 400
    public Result<Map<String, List<Result.FieldError>>> handleMethodArgumentNotValidException(MethodArgumentNotValidException e) {
        List<Result.FieldError> errors = e.getBindingResult().getFieldErrors()
                .stream()
                .map(error -> new Result.FieldError(
                        error.getField(),
                        error.getDefaultMessage()
                ))
                .toList();

        return Result.failOnFieldError(ReturnCode.RC400, errors);
    }

    /**
     * 处理ConstraintViolationException异常
     * 触发场景：方法参数或返回值校验失败（如 @RequestParam、@PathVariable 校验失败
     * 适用场景：方法参数校验
     * @param e ConstraintViolationException
     * @return Result
     */
    @ExceptionHandler(ConstraintViolationException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public Result<Map<String, List<Result.FieldError>>> handleConstraintViolationException(ConstraintViolationException e) {
        List<Result.FieldError> errors = e.getConstraintViolations()
                .stream()
                .map(constraintViolation -> {
                    String field = constraintViolation.getPropertyPath().toString();
                    if (field.contains(".")) {
                        field = field.substring(field.lastIndexOf(".") + 1);
                    }
                    return new Result.FieldError(field, constraintViolation.getMessage());
                })
                .toList();
        return Result.failOnFieldError(ReturnCode.RC400, errors);
    }

    /**
     * 处理BindException异常
     * 触发场景：类型转换错误、字段校验失败
     * 适用场景：Get请求使用DTO接收参数；POST请求接收传统表单提交
     *
     * @param e BindException
     * @return Resutl
     */
    @ExceptionHandler(BindException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public Result<Map<String, List<Result.FieldError>>> handleBindException(BindException e) {
        List<Result.FieldError> errors = e.getBindingResult().getFieldErrors()
                .stream()
                .map(fieldError -> new Result.FieldError(fieldError.getField(), fieldError.getDefaultMessage()))
                .toList();
        return Result.failOnFieldError(ReturnCode.RC400, errors);
    }

}
