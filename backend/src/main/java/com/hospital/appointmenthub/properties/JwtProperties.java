package com.hospital.appointmenthub.properties;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

/**
 * JWT 配置属性
 */
@Data
@Component
@ConfigurationProperties(prefix = "jwt")
public class JwtProperties {

    /** JWT 签名密钥 */
    private String secret;

    /** JWT 签发者 */
    private String issuer;

    /** JWT 有效期 */
    private long expireTime;

    /** 请求头名称 */
    private String header;

    /** Token 前缀 */
    private String tokenPrefix;
}
