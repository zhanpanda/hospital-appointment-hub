package com.hospital.appointmenthub.util;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Component;
import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;

@Component
public class RedisIdWorker {

    @Autowired
    private StringRedisTemplate stringRedisTemplate;

    /**
     * 起始时间戳（2024-01-01 00:00:00）
     * 根据你的项目需要调整
     */
    private static final long BEGIN_TIMESTAMP = 1704038400L;

    /**
     * 序列号占用的位数
     */
    private static final int COUNT_BITS = 32;

    /**
     * 生成唯一ID
     * @param keyPrefix 业务前缀，比如 "order"、"user"、"schedule"
     * @return 全局唯一ID
     */
    public long nextId(String keyPrefix) {
        // 1. 生成时间戳（当前时间 - 起始时间）
        LocalDateTime now = LocalDateTime.now();
        long nowSecond = now.toEpochSecond(ZoneOffset.UTC);
        long timestamp = nowSecond - BEGIN_TIMESTAMP;

        // 2. 生成序列号（按天 + 业务前缀隔离）
        String date = now.format(DateTimeFormatter.ofPattern("yyyy:MM:dd"));
        String key = "icr:" + keyPrefix + ":" + date;  // 示例: icr:order:2026:05:14
        Long increment = stringRedisTemplate.opsForValue().increment(key);

        // 设置过期时间（防止 key 一直占用内存）
        stringRedisTemplate.expire(key, java.time.Duration.ofDays(2));

        // 3. 拼接并返回
        // 时间戳左移32位，低32位放序列号
        return (timestamp << COUNT_BITS) | increment;
    }
}