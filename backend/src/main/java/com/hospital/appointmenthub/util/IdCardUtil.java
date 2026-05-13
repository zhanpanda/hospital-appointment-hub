package com.hospital.appointmenthub.util;

import com.hospital.appointmenthub.common.Gender;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

public class IdCardUtil {
    /**
     * 根据身份证 获取出生日期
     */
    public static LocalDate getBirthDate(String idCard) {
        if(idCard == null || idCard.length() != 18) {
            return null;
        }
        String dateStr = idCard.substring(6, 14);
        return LocalDate.parse(dateStr, DateTimeFormatter.ofPattern("yyyyMMdd"));
    }

    /**
     * 根据身份证 获取性别
     */
    public static Gender getGender(String idCard) {
        if(idCard == null || idCard.length() != 18) {
            return null;
        }
        char genderChar = idCard.charAt(16);
        return (genderChar - '0') % 2 == 0 ? Gender.FEMALE : Gender.MALE;
    }
}
