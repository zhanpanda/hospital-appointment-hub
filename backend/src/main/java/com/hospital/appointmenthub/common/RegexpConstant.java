package com.hospital.appointmenthub.common;

/**
 * 正则表达式常量类
 */
public class RegexpConstant {
    /**
     * 手机号
     */
    public static final String PHONE = "^1[3-9]\\d{9}$";
    public static final String PHONE_MESSAGE = "手机号码格式错误，请输入正确的手机号码";

    /**
     * 密码
     */
    public static final String PASSWORD = "^(?=.*[a-zA-Z])(?=.*\\d)[\\x21-\\x7E]{8,20}$";
    public static final String PASSWORD_MESSAGE = "密码长度为 8-20 位，必须包含字母和数字，仅支持标准英文及标点（不可包含空格、中文或表情符号）";
}
