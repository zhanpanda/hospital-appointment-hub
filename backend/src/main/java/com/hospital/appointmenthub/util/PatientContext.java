package com.hospital.appointmenthub.util;

/**
 * 患者上下文工具类
 */
public class PatientContext {

    private static final ThreadLocal<Long> PATIENT_ID_HOLDER = new ThreadLocal<>();

    private PatientContext() {
    }

    /**
     * 保存患者ID
     */
    public static void setPatientId(Long patientId) {
        PATIENT_ID_HOLDER.set(patientId);
    }

    /**
     * 获取患者ID
     */
    public static Long getPatientId() {
        return PATIENT_ID_HOLDER.get();
    }

    /**
     * 清除患者ID
     */
    public static void removePatientId() {
        PATIENT_ID_HOLDER.remove();
    }
}
