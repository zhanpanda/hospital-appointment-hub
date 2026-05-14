package com.hospital.appointmenthub.advice;

import com.hospital.appointmenthub.common.Result;
import com.hospital.appointmenthub.common.ReturnCode;
import com.hospital.appointmenthub.exception.BusinessException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@Slf4j
@RestControllerAdvice
public class GlobalExceptionHandler {

    // 处理自定义异常
    @ExceptionHandler(BusinessException.class)
    public ResponseEntity<Result<Void>> handleBusinessException(BusinessException e) {
        log.warn("业务异常: code={}, message={}", e.getCode(), e.getMessage());
        // 使用 ResponseEntity 返回自定义状态码
        return ResponseEntity.status(e.getCode()).body(Result.fail(e.getCode(), e.getMessage()));
    }

    // 处理未捕获异常
    @ExceptionHandler(Exception.class)
    public ResponseEntity<Result<Void>> handleException(Exception e) {
        log.error("系统异常", e);
        return ResponseEntity
                .status(ReturnCode.RC500.getCode())
                .body(Result.fail(ReturnCode.RC500.getCode(), "服务器内部错误"));
    }

}
