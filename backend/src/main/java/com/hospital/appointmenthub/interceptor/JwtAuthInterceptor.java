package com.hospital.appointmenthub.interceptor;

import com.auth0.jwt.exceptions.JWTVerificationException;
import com.auth0.jwt.exceptions.TokenExpiredException;
import com.hospital.appointmenthub.common.ReturnCode;
import com.hospital.appointmenthub.exception.BusinessException;
import com.hospital.appointmenthub.properties.JwtProperties;
import com.hospital.appointmenthub.util.JwtUtil;
import com.hospital.appointmenthub.util.PatientContext;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.util.StringUtils;
import org.springframework.web.servlet.HandlerInterceptor;

@RequiredArgsConstructor
public class JwtAuthInterceptor implements HandlerInterceptor {

    private final JwtUtil jwtUtil;

    private final JwtProperties jwtProperties;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
        String token = request.getHeader(jwtProperties.getHeader());
        if (!StringUtils.hasText(token)) {
            throw new BusinessException(ReturnCode.USER_NOT_LOGIN);
        }
        if (!token.startsWith(jwtProperties.getTokenPrefix())) {
            throw new BusinessException(ReturnCode.INVALID_TOKEN);
        }

        try {
            Long patientId = jwtUtil.getPatientId(token);
            if (patientId == null) {
                throw new BusinessException(ReturnCode.INVALID_TOKEN);
            }
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
