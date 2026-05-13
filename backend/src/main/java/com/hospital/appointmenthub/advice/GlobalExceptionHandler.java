package com.hospital.appointmenthub.advice;

import com.hospital.appointmenthub.common.Result;
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
        // 使用 ResponseEntity 返回自定义状态码
        return ResponseEntity.status(e.getCode()).body(Result.fail(e.getCode(), e.getMessage()));

    }
}
