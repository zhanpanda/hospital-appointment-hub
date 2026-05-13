package com.hospital.appointmenthub.controller;

import com.hospital.appointmenthub.common.Result;
import com.hospital.appointmenthub.model.dto.FamilyMemberDetailDTO;
import com.hospital.appointmenthub.model.dto.FamilyMemberDTO;
import com.hospital.appointmenthub.model.dto.FamilyMemberItemDTO;
import com.hospital.appointmenthub.service.IFamilyMemberService;
import com.hospital.appointmenthub.util.PatientContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.List;

@RestController
@RequestMapping("/api/family-member")
public class FamilyMemberController {
    @Autowired
    private IFamilyMemberService familyMemberService;

    @PostMapping
    public Result<Void> add(@RequestBody @Validated FamilyMemberDTO familyMemberDTO) {
        Long patientId = PatientContext.getPatientId();
        familyMemberService.add(patientId, familyMemberDTO);
        return Result.success();
    }

    @GetMapping
    public Result<List<FamilyMemberItemDTO>> list() {
        Long patientId = PatientContext.getPatientId();
        return Result.success(familyMemberService.list(patientId));
    }

    @GetMapping("/{id}")
    public Result<FamilyMemberDetailDTO> getDetail(@PathVariable Long id) {
        Long patientId = PatientContext.getPatientId();
        return Result.success(familyMemberService.getDetail(patientId, id));
    }

    @PutMapping("/{id}")
    public Result<Void> update(@PathVariable Long id, @RequestBody @Validated FamilyMemberDTO familyMemberDTO) {
        Long patientId = PatientContext.getPatientId();
        familyMemberService.update(patientId, id, familyMemberDTO);
        return Result.success();
    }

    @PutMapping("/{id}/default")
    public Result<Void> updateDefault(@PathVariable Long id) {
        Long patientId = PatientContext.getPatientId();
        familyMemberService.updateDefault(patientId, id);
        return Result.success();
    }

    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        Long patientId = PatientContext.getPatientId();
        familyMemberService.delete(patientId, id);
        return Result.success();
    }

}
