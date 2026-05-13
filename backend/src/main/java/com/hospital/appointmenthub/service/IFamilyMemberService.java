package com.hospital.appointmenthub.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.hospital.appointmenthub.model.dto.FamilyMemberDetailDTO;
import com.hospital.appointmenthub.model.dto.FamilyMemberDTO;
import com.hospital.appointmenthub.model.dto.FamilyMemberItemDTO;
import com.hospital.appointmenthub.model.po.FamilyMember;
import java.util.List;

public interface IFamilyMemberService extends IService<FamilyMember> {
    void add(Long patientId, FamilyMemberDTO familyMemberDTO);

    void update(Long patientId, Long id, FamilyMemberDTO familyMemberDTO);

    void updateDefault(Long patientId, Long id);

    void delete(Long patientId, Long id);

    FamilyMemberDetailDTO getDetail(Long patientId, Long id);

    List<FamilyMemberItemDTO> list(Long patientId);
}
