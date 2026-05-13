package com.hospital.appointmenthub.common;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum  Relationship {
    SELF(1, "本人"),
    SPOUSE(2, "配偶"),
    CHILD(3, "子女"),
    PARENT(4, "父母"),
    OTHER(5, "其他")
    ;
    private final int code;
    private final String message;
}
