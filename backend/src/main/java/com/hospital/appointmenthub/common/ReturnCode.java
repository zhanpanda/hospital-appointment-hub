package com.hospital.appointmenthub.common;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 通用返回状态码
 */
@Getter
@AllArgsConstructor
public enum ReturnCode {

    RC200(200, "请求成功"),
    RC201(201, "创建成功"),
    RC400(400, "请求参数错误或格式不正确"),
    RC401(401, "未授权访问，需要登录或令牌"),
    RC403(403, "无权限访问"),
    RC404(404, "请求资源不存在"),
    RC405(405, "请求方法不被允许"),
    RC409(409, "资源冲突，已存在相同的资源"),
    RC415(415, "不支持的媒体类型"),
    RC422(422, "请求无法处理"),
    RC429(429, "请求过于频繁，请稍后再试"),
    RC500(500, "服务器内部错误"),
    RC503(503, "服务不可用"),

    INVALID_TOKEN(401, "无效的token"),
    EXPIRED_TOKEN(401, "token已过期"),
    TOKEN_GENERATE_ERROR(500, "token生成失败"),
    ACCESS_DENIED(403, "无权访问"),
    USER_NOT_FOUND(404, "账号不存在"),
    USER_ALREADY_EXISTS(409, "账号已存在"),
    PASSWORD_ERROR(401, "密码错误"),
    USER_NOT_LOGIN(401, "用户未登录"),
    NEW_PASSWORD_EQUAL_OLD_PASSWORD(400, "新密码不能与原密码相同"),
    USER_DISABLED(403, "账号被禁用"),
    USER_LOCKED(403, "账号被锁定"),
    USER_LOGOUT(401, "账号已注销"),
    SERVER_UNAVAILABLE(503, "服务器不可用");

    /** 状态码 */
    private final int code;

    /** 返回信息 */
    private final String message;
}
