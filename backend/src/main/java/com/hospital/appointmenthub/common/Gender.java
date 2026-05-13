package com.hospital.appointmenthub.common;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum Gender {
    MALE(1, "男"),
    FEMALE(2, "女")
    ;
    private final int code;
    private final String message;
}
