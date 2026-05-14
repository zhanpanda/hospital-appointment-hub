package com.hospital.appointmenthub.util;

import com.auth0.jwt.JWT;
import com.auth0.jwt.JWTVerifier;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.exceptions.JWTDecodeException;
import com.auth0.jwt.interfaces.DecodedJWT;
import com.hospital.appointmenthub.properties.JwtProperties;
import java.util.Date;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

/**
 * JWT 工具类
 */
@Component
@RequiredArgsConstructor
public class JwtUtil {

    private final JwtProperties jwtProperties;

    /**
     * 生成令牌
     */
    public String generateToken(Long patientId) {
        Date now = new Date();
        Date expireAt = new Date(now.getTime() + jwtProperties.getExpireTime());
        return JWT.create()
                .withIssuer(jwtProperties.getIssuer())
                .withClaim("patientId", patientId)
                .withIssuedAt(now)
                .withExpiresAt(expireAt)
                .sign(getAlgorithm());
    }

    /**
     * 校验并解析令牌
     */
    public DecodedJWT verifyToken(String token) {
        String rawToken = token.replace(jwtProperties.getTokenPrefix(), "").trim();
        JWTVerifier verifier = JWT.require(getAlgorithm())
                .withIssuer(jwtProperties.getIssuer())
                .build();
        return verifier.verify(rawToken);
    }

    /**
     * 获取患者ID
     */
    public Long getPatientId(String token) {
        return verifyToken(token).getClaim("patientId").asLong();
    }

    /**
     * 不校验签名，直接从 token 中读取患者ID，用于 Redis 预检查
     */
    public Long parsePatientId(String token) {
        String rawToken = token.replace(jwtProperties.getTokenPrefix(), "").trim();
        try {
            return JWT.decode(rawToken).getClaim("patientId").asLong();
        } catch (JWTDecodeException exception) {
            return null;
        }
    }

    private Algorithm getAlgorithm() {
        return Algorithm.HMAC256(jwtProperties.getSecret());
    }
}
