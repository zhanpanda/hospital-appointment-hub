package com.hospital.appointmenthub.model.dto;

import com.hospital.appointmenthub.model.po.Doctor;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class DoctorItemDTO {
    private Long id;

    private String name;

    private String title;

    private String specialty;

    public static DoctorItemDTO from(Doctor doctor) {
        DoctorItemDTO dto = new DoctorItemDTO();
        dto.setId(doctor.getId());
        dto.setName(doctor.getName());
        dto.setTitle(doctor.getTitle());
        dto.setSpecialty(doctor.getSpecialty());
        return dto;
    }
}
