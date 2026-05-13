package com.hospital.appointmenthub.common;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum PatientStatus {
    NORMAL(1, "正常"),
    DISABLED(0, "禁用")
    ;

    private final int code;
    private final String message;
}
