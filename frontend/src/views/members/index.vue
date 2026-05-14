<script setup>
import { computed, reactive, ref } from "vue";
import { useRouter } from "vue-router";
import {
  createFamilyMember,
  deleteFamilyMemberById,
  fetchFamilyMemberDetail,
  setDefaultFamilyMember,
  updateFamilyMember
} from "@/api/familyMember";
import { relationshipOptions } from "@/constants/appointment";
import { useAuthStore } from "@/stores/auth";
import { usePortalStore } from "@/stores/portal";
import { handleUnauthorized } from "@/utils/auth";
import { showErrorMessage, showSuccessMessage } from "@/utils/message";

const router = useRouter();
const authStore = useAuthStore();
const portalStore = usePortalStore();

const familySubmitting = ref(false);
const editingFamilyMemberId = ref(null);
const modalVisible = ref(false);

const phonePattern = /^1[3-9]\d{9}$/;
const idCardPattern = /^[1-9]\d{5}(18|19|20)\d{2}((0[1-9])|(1[0-2]))(([0-2][1-9])|10|20|30|31)\d{3}[0-9X]$/;

const familyForm = reactive({
  name: "",
  idCard: "",
  phone: "",
  relationship: 0,
  isDefault: false
});

const familyFieldErrors = reactive({
  name: "",
  idCard: "",
  phone: "",
  relationship: ""
});

const listedMembers = computed(() => portalStore.state.familyMembers);

const derivedMemberPreview = computed(() => {
  const idCard = familyForm.idCard.trim().toUpperCase();
  if (!idCardPattern.test(idCard)) {
    return {
      gender: "待识别",
      birthDate: "待识别"
    };
  }

  return {
    gender: Number(idCard.charAt(16)) % 2 === 0 ? "女" : "男",
    birthDate: `${idCard.slice(6, 10)}-${idCard.slice(10, 12)}-${idCard.slice(12, 14)}`
  };
});

function resetFamilyFieldErrors() {
  familyFieldErrors.name = "";
  familyFieldErrors.idCard = "";
  familyFieldErrors.phone = "";
  familyFieldErrors.relationship = "";
}

function resetFamilyForm() {
  familyForm.name = "";
  familyForm.idCard = "";
  familyForm.phone = "";
  familyForm.relationship = 0;
  familyForm.isDefault = false;
  editingFamilyMemberId.value = null;
  resetFamilyFieldErrors();
}

function fillFamilyForm(detail) {
  familyForm.name = detail?.name || "";
  familyForm.idCard = detail?.idCard || "";
  familyForm.phone = detail?.phone || "";
  familyForm.relationship = detail?.relationship ?? 0;
  familyForm.isDefault = Boolean(detail?.isDefault);
  resetFamilyFieldErrors();
}

function relationshipLabel(value) {
  return relationshipOptions.find((item) => item.value === value)?.label || "未设置";
}

function openCreateModal() {
  resetFamilyForm();
  modalVisible.value = true;
}

function closeModal() {
  modalVisible.value = false;
  resetFamilyForm();
}

function validateFamilyForm() {
  resetFamilyFieldErrors();

  if (!familyForm.name.trim()) {
    familyFieldErrors.name = "请输入就诊人姓名";
    return false;
  }

  const idCard = familyForm.idCard.trim().toUpperCase();
  if (!idCard) {
    familyFieldErrors.idCard = "请输入身份证号";
    return false;
  }
  if (!idCardPattern.test(idCard)) {
    familyFieldErrors.idCard = "身份证号格式错误，请输入正确的身份证号";
    return false;
  }

  const phone = familyForm.phone.trim();
  if (!phone) {
    familyFieldErrors.phone = "请输入手机号";
    return false;
  }
  if (!phonePattern.test(phone)) {
    familyFieldErrors.phone = "手机号码格式错误，请输入正确的手机号码";
    return false;
  }

  if (familyForm.relationship === "" || familyForm.relationship === null || familyForm.relationship === undefined) {
    familyFieldErrors.relationship = "请选择与患者关系";
    return false;
  }

  return true;
}

async function startEditFamilyMember(id) {
  try {
    const detail = await fetchFamilyMemberDetail(authStore.state.token, id);
    editingFamilyMemberId.value = id;
    fillFamilyForm(detail);
    modalVisible.value = true;
  } catch (error) {
    if (handleUnauthorized(error, router)) {
      return;
    }
    showErrorMessage(error);
  }
}

async function submitFamilyMemberForm() {
  if (!validateFamilyForm()) {
    return;
  }

  familySubmitting.value = true;

  const payload = {
    name: familyForm.name.trim(),
    idCard: familyForm.idCard.trim().toUpperCase(),
    phone: familyForm.phone.trim(),
    relationship: Number(familyForm.relationship),
    isDefault: Boolean(familyForm.isDefault)
  };

  try {
    if (editingFamilyMemberId.value) {
      await updateFamilyMember(authStore.state.token, editingFamilyMemberId.value, payload);
      showSuccessMessage("就诊人已更新");
    } else {
      await createFamilyMember(authStore.state.token, payload);
      showSuccessMessage("就诊人已新增");
    }

    await portalStore.loadFamilyMembers(authStore.state.token);
    closeModal();
  } catch (error) {
    if (handleUnauthorized(error, router)) {
      return;
    }
    showErrorMessage(error);
  } finally {
    familySubmitting.value = false;
  }
}

async function makeDefault(id) {
  try {
    await setDefaultFamilyMember(authStore.state.token, id);
    showSuccessMessage("默认就诊人已更新");
    await portalStore.loadFamilyMembers(authStore.state.token);
  } catch (error) {
    if (handleUnauthorized(error, router)) {
      return;
    }
    showErrorMessage(error);
  }
}

async function removeMember(id) {
  if (!window.confirm("确认删除这个就诊人吗？")) {
    return;
  }

  try {
    await deleteFamilyMemberById(authStore.state.token, id);
    showSuccessMessage("就诊人已删除");
    await portalStore.loadFamilyMembers(authStore.state.token);
  } catch (error) {
    if (handleUnauthorized(error, router)) {
      return;
    }
    showErrorMessage(error);
  }
}
</script>

<template>
  <section class="members-shell members-shell--list">
    <div class="members-toolbar">
      <h2>就诊人管理</h2>
      <button class="members-add-button" type="button" @click="openCreateModal">+ 添加就诊人</button>
    </div>

    <p v-if="portalStore.state.familyLoading" class="placeholder-text">正在加载就诊人列表...</p>

    <div v-else class="member-card-list">
      <article v-for="member in listedMembers" :key="member.id" class="member-list-card">
        <div class="member-list-card__header">
          <div class="member-list-card__title">
            <h3>{{ member.name }}</h3>
            <span class="member-tag">{{ relationshipLabel(member.relationship) }}</span>
            <span v-if="member.isDefault" class="member-tag member-tag--default">默认</span>
          </div>

          <button
            v-if="!member.isDefault"
            class="member-link member-link--primary"
            type="button"
            @click="makeDefault(member.id)"
          >
            设为默认
          </button>
        </div>

        <div class="member-list-card__body">
          <div class="member-info-row">
            <span class="member-info-row__label">身份证：</span>
            <span>{{ member.idCard || "--" }}</span>
          </div>
          <div class="member-info-row">
            <span class="member-info-row__label">手机号：</span>
            <span>{{ member.phone || "--" }}</span>
          </div>
        </div>

        <div class="member-list-card__footer">
          <button class="member-link member-link--primary" type="button" @click="startEditFamilyMember(member.id)">
            编辑
          </button>
          <button class="member-link member-link--danger" type="button" @click="removeMember(member.id)">
            删除
          </button>
        </div>
      </article>

      <p v-if="!listedMembers.length" class="placeholder-text">
        还没有就诊人，请先新增。
      </p>
    </div>

    <div v-if="modalVisible" class="member-modal">
      <div class="member-modal__mask" @click="closeModal"></div>

      <form class="member-modal__card stack-form" @submit.prevent="submitFamilyMemberForm">
        <div class="panel-heading panel-heading--compact">
          <h3>{{ editingFamilyMemberId ? "编辑就诊人" : "新增就诊人" }}</h3>

          <button class="member-modal__close" type="button" aria-label="关闭" @click="closeModal">
            ×
          </button>
        </div>

        <label class="field">
          <span>姓名</span>
          <input v-model.trim="familyForm.name" placeholder="请输入就诊人姓名" type="text" />
        </label>
        <p v-if="familyFieldErrors.name" class="inline-error inline-error--field">
          {{ familyFieldErrors.name }}
        </p>

        <label class="field">
          <span>身份证号</span>
          <input v-model.trim="familyForm.idCard" placeholder="请输入18位身份证号" type="text" />
        </label>
        <p v-if="familyFieldErrors.idCard" class="inline-error inline-error--field">
          {{ familyFieldErrors.idCard }}
        </p>

        <div class="member-preview-row">
          <div class="member-preview-pill">
            <span>自动识别性别</span>
            <strong>{{ derivedMemberPreview.gender }}</strong>
          </div>
          <div class="member-preview-pill">
            <span>自动识别出生日期</span>
            <strong>{{ derivedMemberPreview.birthDate }}</strong>
          </div>
        </div>

        <label class="field">
          <span>手机号</span>
          <input v-model.trim="familyForm.phone" placeholder="请输入手机号" type="text" />
        </label>
        <p v-if="familyFieldErrors.phone" class="inline-error inline-error--field">
          {{ familyFieldErrors.phone }}
        </p>

        <label class="field">
          <span>关系</span>
          <select v-model="familyForm.relationship">
            <option v-for="option in relationshipOptions" :key="option.value" :value="option.value">
              {{ option.label }}
            </option>
          </select>
        </label>
        <p v-if="familyFieldErrors.relationship" class="inline-error inline-error--field">
          {{ familyFieldErrors.relationship }}
        </p>

        <label class="checkbox-field">
          <input v-model="familyForm.isDefault" type="checkbox" />
          <span>设为默认就诊人</span>
        </label>

        <div class="form-actions">
          <button class="primary-button" :disabled="familySubmitting" type="submit">
            {{ familySubmitting ? "保存中..." : editingFamilyMemberId ? "保存修改" : "新增就诊人" }}
          </button>
        </div>
      </form>
    </div>
  </section>
</template>
