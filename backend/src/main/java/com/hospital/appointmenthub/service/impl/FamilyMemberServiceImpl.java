package com.hospital.appointmenthub.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.hospital.appointmenthub.common.Gender;
import com.hospital.appointmenthub.common.ReturnCode;
import com.hospital.appointmenthub.exception.BusinessException;
import com.hospital.appointmenthub.mapper.FamilyMemberMapper;
import com.hospital.appointmenthub.model.dto.FamilyMemberDetailDTO;
import com.hospital.appointmenthub.model.dto.FamilyMemberDTO;
import com.hospital.appointmenthub.model.dto.FamilyMemberItemDTO;
import com.hospital.appointmenthub.model.po.FamilyMember;
import com.hospital.appointmenthub.service.IFamilyMemberService;
import com.hospital.appointmenthub.util.IdCardUtil;
import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class FamilyMemberServiceImpl extends ServiceImpl<FamilyMemberMapper, FamilyMember> implements IFamilyMemberService {
    @Override
    @Transactional(rollbackFor = Exception.class)
    public void add(Long patientId, FamilyMemberDTO familyMemberDTO) {
        FamilyMember familyMember = new FamilyMember();
        familyMember.setPatientId(patientId);
        applyFamilyMemberData(familyMember, familyMemberDTO);
        handleDefaultFamilyMember(patientId, null, familyMemberDTO.getIsDefault());
        boolean saved = save(familyMember);
        if (!saved) {
            throw new BusinessException(ReturnCode.RC500.getCode(), "新增就诊人失败");
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void update(Long patientId, Long id, FamilyMemberDTO familyMemberDTO) {
        FamilyMember familyMember = getFamilyMember(patientId, id);
        applyFamilyMemberData(familyMember, familyMemberDTO);
        handleDefaultFamilyMember(patientId, id, familyMemberDTO.getIsDefault());
        boolean updated = updateById(familyMember);
        if (!updated) {
            throw new BusinessException(ReturnCode.RC500.getCode(), "修改就诊人失败");
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateDefault(Long patientId, Long id) {
        FamilyMember familyMember = getFamilyMember(patientId, id);
        if (Boolean.TRUE.equals(familyMember.getIsDefault())) {
            return;
        }
        handleDefaultFamilyMember(patientId, id, true);
        familyMember.setIsDefault(true);
        boolean updated = updateById(familyMember);
        if (!updated) {
            throw new BusinessException(ReturnCode.RC500.getCode(), "修改默认就诊人失败");
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void delete(Long patientId, Long id) {
        FamilyMember familyMember = getFamilyMember(patientId, id);
        boolean removed = removeById(familyMember.getId());
        if (!removed) {
            throw new BusinessException(ReturnCode.RC500.getCode(), "删除就诊人失败");
        }
    }

    @Override
    public FamilyMemberDetailDTO getDetail(Long patientId, Long id) {
        return FamilyMemberDetailDTO.from(getFamilyMember(patientId, id));
    }

    @Override
    public List<FamilyMemberItemDTO> list(Long patientId) {
        return lambdaQuery()
                .eq(FamilyMember::getPatientId, patientId)
                .orderByDesc(FamilyMember::getIsDefault)
                .orderByDesc(FamilyMember::getUpdatedAt)
                .list()
                .stream()
                .map(FamilyMemberItemDTO::from) // 将FamilyMember 转换为FamilyMemberItemDTO
                .toList();
    }

    /**
     * 将请求参数中的就诊人信息填充到实体对象，并根据身份证号解析出生日期和性别。
     */
    private void applyFamilyMemberData(FamilyMember familyMember, FamilyMemberDTO familyMemberDTO) {
        familyMember.setName(familyMemberDTO.getName());
        familyMember.setIdCard(familyMemberDTO.getIdCard());
        familyMember.setPhone(familyMemberDTO.getPhone());
        familyMember.setRelationship(familyMemberDTO.getRelationship());
        familyMember.setIsDefault(familyMemberDTO.getIsDefault());
        familyMember.setBirthDate(IdCardUtil.getBirthDate(familyMemberDTO.getIdCard()));

        Gender gender = IdCardUtil.getGender(familyMemberDTO.getIdCard());
        familyMember.setGender(gender == null ? null : gender.getCode());
    }

    /**
     * 当当前操作要设置默认就诊人时，将同一患者名下其他默认就诊人取消默认状态。
     */
    private void handleDefaultFamilyMember(Long patientId, Long excludeId, Boolean isDefault) {
        if (!Boolean.TRUE.equals(isDefault)) {
            return;
        }
        var updateChain = lambdaUpdate()
                .eq(FamilyMember::getPatientId, patientId)
                .eq(FamilyMember::getIsDefault, true);
        if (excludeId != null) {
            updateChain.ne(FamilyMember::getId, excludeId);
        }
        updateChain.set(FamilyMember::getIsDefault, false).update();
    }

    /**
     * 按患者ID和就诊人ID查询就诊人，确保只能操作当前登录用户自己的就诊人数据。
     */
    private FamilyMember getFamilyMember(Long patientId, Long id) {
        FamilyMember familyMember = lambdaQuery()
                .eq(FamilyMember::getId, id)
                .eq(FamilyMember::getPatientId, patientId)
                .one();
        if (familyMember == null) {
            throw new BusinessException(ReturnCode.RC404.getCode(), "就诊人不存在");
        }
        return familyMember;
    }
}
