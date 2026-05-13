package com.hospital.appointmenthub.model.dto;

import com.hospital.appointmenthub.model.po.FamilyMember;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class FamilyMemberItemDTO {
    private Long id;

    private String name;

    private Boolean isDefault;

    public static FamilyMemberItemDTO from(FamilyMember familyMember) {
        FamilyMemberItemDTO dto = new FamilyMemberItemDTO();
        dto.setId(familyMember.getId());
        dto.setName(familyMember.getName());
        dto.setIsDefault(familyMember.getIsDefault());
        return dto;
    }
}
