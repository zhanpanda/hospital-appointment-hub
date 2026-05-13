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

    private String avatar;

    private String title;

    public static DoctorItemDTO from(Doctor doctor) {
        DoctorItemDTO dto = new DoctorItemDTO();
        dto.setId(doctor.getId());
        dto.setName(doctor.getName());
        dto.setAvatar(doctor.getAvatar());
        dto.setTitle(doctor.getTitle());
        return dto;
    }
}
