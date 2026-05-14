package com.hospital.appointmenthub.model.dto;

import com.hospital.appointmenthub.model.po.Doctor;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class DoctorDetailDTO {
    private Long id;

    private Integer departmentId;

    private String name;

    private String title;

    private String specialty;

    private String introduction;

    public static DoctorDetailDTO from(Doctor doctor) {
        DoctorDetailDTO dto = new DoctorDetailDTO();
        dto.setId(doctor.getId());
        dto.setDepartmentId(doctor.getDepartmentId());
        dto.setName(doctor.getName());
        dto.setTitle(doctor.getTitle());
        dto.setSpecialty(doctor.getSpecialty());
        dto.setIntroduction(doctor.getIntroduction());
        return dto;
    }
}
