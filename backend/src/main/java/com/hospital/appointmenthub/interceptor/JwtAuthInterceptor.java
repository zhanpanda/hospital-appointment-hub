package com.hospital.appointmenthub.interceptor;

import com.auth0.jwt.exceptions.JWTVerificationException;
import com.auth0.jwt.exceptions.TokenExpiredException;
import com.hospital.appointmenthub.common.RedisConstant;
import com.hospital.appointmenthub.common.ReturnCode;
import com.hospital.appointmenthub.exception.BusinessException;
import com.hospital.appointmenthub.properties.JwtProperties;
import com.hospital.appointmenthub.util.JwtUtil;
import com.hospital.appointmenthub.util.PatientContext;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.util.StringUtils;
import org.springframework.web.servlet.HandlerInterceptor;

@RequiredArgsConstructor
public class JwtAuthInterceptor implements HandlerInterceptor {

    private final JwtUtil jwtUtil;

    private final JwtProperties jwtProperties;

    private final StringRedisTemplate stringRedisTemplate;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
        String token = request.getHeader(jwtProperties.getHeader());
        if (!StringUtils.hasText(token)) {
            throw new BusinessException(ReturnCode.USER_NOT_LOGIN);
        }
        if (!token.startsWith(jwtProperties.getTokenPrefix())) {
            throw new BusinessException(ReturnCode.INVALID_TOKEN);
        }

        String rawToken = token.replace(jwtProperties.getTokenPrefix(), "").trim();

        try {
            Long patientId = jwtUtil.parsePatientId(token);
            if (patientId == null) {
                throw new BusinessException(ReturnCode.INVALID_TOKEN);
            }

            String cachedToken = stringRedisTemplate.opsForValue().get(RedisConstant.PATIENT_TOKEN_PREFIX + patientId);
            if (!StringUtils.hasText(cachedToken) || !rawToken.equals(cachedToken)) {
                throw new BusinessException(ReturnCode.USER_NOT_LOGIN);
            }

            patientId = jwtUtil.getPatientId(token);
            PatientContext.setPatientId(patientId);
            return true;
        } catch (TokenExpiredException exception) {
            throw new BusinessException(ReturnCode.EXPIRED_TOKEN);
        } catch (JWTVerificationException exception) {
            throw new BusinessException(ReturnCode.INVALID_TOKEN);
        }
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) {
        PatientContext.removePatientId();
    }
}
