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

    /**
     * 身份证 首位不能为0，5个随机数字， 出生年份18xx 19xx 20xx，月份只能是01-12，日期只能01-31，三位随机数，最后一位可以是数字或者是xX
     */
    public static final String ID_CARD = "^[1-9]\\d{5}(18|19|20)\\d{2}((0[1-9])|(1[0-2]))(([0-2][1-9])|10|20|30|31)\\d{3}[0-9X]$";
    public static final String ID_CARD_MESSAGE = "身份证号格式错误，请输入正确的身份证号";
}
