package com.hospital.appointmenthub.common;

import java.time.Instant;
import java.util.List;
import java.util.Map;

import lombok.AllArgsConstructor;
import lombok.Data;


/**
 * 通用返回结果
 */
@Data
public class Result<T> {

    /** 状态码 */
    private int code;

    /** 返回消息 */
    private String message;

    /** 返回数据 */
    private T data;

    /** 返回时间戳 */
    private Instant timestamp;

    @Data
    @AllArgsConstructor
    public static class FieldError {
        private String field; // 字段名
        private String message; //错误消息

        public static Map<String, List<FieldError>> result(List<FieldError> errors) {
            return Map.of("errors", errors);
        }
    }

    public Result() {
        this.timestamp = Instant.now();
    }

    public Result(int code, String message, T data) {
        this();
        this.code = code;
        this.message = message;
        this.data = data;
    }

    public static <T> Result<T> success() {
        return build(ReturnCode.RC200.getCode(), ReturnCode.RC200.getMessage(), null);
    }

    public static <T> Result<T> success(T data) {
        return build(ReturnCode.RC200.getCode(), ReturnCode.RC200.getMessage(), data);
    }

    public static <T> Result<T> success(ReturnCode returnCode) {
        return build(returnCode.getCode(), returnCode.getMessage(), null);
    }

    public static <T> Result<T> success(ReturnCode returnCode, T data) {
        return build(returnCode.getCode(), returnCode.getMessage(), data);
    }

    public static <T> Result<T> success(int code, String message) {
        return build(code, message, null);
    }

    public static <T> Result<T> success(int code, String message, T data) {
        return build(code, message, data);
    }

    public static <T> Result<T> fail() {
        return build(ReturnCode.RC500.getCode(), ReturnCode.RC500.getMessage(), null);
    }

    public static <T> Result<T> fail(T data) {
        return build(ReturnCode.RC500.getCode(), ReturnCode.RC500.getMessage(), data);
    }

    public static <T> Result<T> fail(ReturnCode returnCode) {
        return build(returnCode.getCode(), returnCode.getMessage(), null);
    }

    public static <T> Result<T> fail(ReturnCode returnCode, T data) {
        return build(returnCode.getCode(), returnCode.getMessage(), data);
    }

    public static <T> Result<T> fail(int code, String message) {
        return build(code, message, null);
    }

    public static <T> Result<T> fail(int code, String message, T data) {
        return build(code, message, data);
    }

    public static Result<Map<String, List<FieldError>>> failOnFieldError(ReturnCode rc, List<FieldError> errors) {
        return build(rc.getCode(), rc.getMessage(), FieldError.result(errors));
    }

    private static <T> Result<T> build(int code, String message, T data) {
        return new Result<>(code, message, data);
    }
}
