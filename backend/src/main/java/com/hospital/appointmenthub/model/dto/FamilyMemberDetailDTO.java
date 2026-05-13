package com.hospital.appointmenthub.model.dto;

import com.hospital.appointmenthub.model.po.FamilyMember;
import java.time.LocalDate;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class FamilyMemberDetailDTO {
    private Long id;

    private String name;

    private String idCard;

    private String phone;

    private Integer gender;

    private LocalDate birthDate;

    private Integer relationship;

    private Boolean isDefault;

    public static FamilyMemberDetailDTO from(FamilyMember familyMember) {
        FamilyMemberDetailDTO dto = new FamilyMemberDetailDTO();
        dto.setId(familyMember.getId());
        dto.setName(familyMember.getName());
        dto.setIdCard(familyMember.getIdCard());
        dto.setPhone(familyMember.getPhone());
        dto.setGender(familyMember.getGender());
        dto.setBirthDate(familyMember.getBirthDate());
        dto.setRelationship(familyMember.getRelationship());
        dto.setIsDefault(familyMember.getIsDefault());
        return dto;
    }
}
