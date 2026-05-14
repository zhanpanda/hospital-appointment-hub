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

    private String idCard;

    private String phone;

    private Integer relationship;

    private Boolean isDefault;

    public static FamilyMemberItemDTO from(FamilyMember familyMember) {
        FamilyMemberItemDTO dto = new FamilyMemberItemDTO();
        dto.setId(familyMember.getId());
        dto.setName(familyMember.getName());
        dto.setIdCard(maskIdCard(familyMember.getIdCard()));
        dto.setPhone(maskPhone(familyMember.getPhone()));
        dto.setRelationship(familyMember.getRelationship());
        dto.setIsDefault(familyMember.getIsDefault());
        return dto;
    }

    private static String maskIdCard(String idCard) {
        if (idCard == null || idCard.length() < 8) {
            return idCard;
        }
        return idCard.substring(0, 4) + "**********" + idCard.substring(idCard.length() - 4);
    }

    private static String maskPhone(String phone) {
        if (phone == null || phone.length() < 7) {
            return phone;
        }
        return phone.substring(0, 3) + "****" + phone.substring(phone.length() - 4);
    }
}
