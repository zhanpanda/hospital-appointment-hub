<script setup>
import { computed, onMounted, ref } from "vue";
import { useRouter } from "vue-router";
import { weekdayLabels } from "@/constants/appointment";
import { useAuthStore } from "@/stores/auth";
import { createAppointment } from "@/api/appointment";
import { fetchDoctorSchedules } from "@/api/schedule";
import { usePortalStore } from "@/stores/portal";
import { handleUnauthorized } from "@/utils/auth";
import { showErrorMessage, showSuccessMessage } from "@/utils/message";

const router = useRouter();
const authStore = useAuthStore();
const portalStore = usePortalStore();
const scheduleLoading = ref(false);
const doctorSchedules = ref([]);
const selectedSchedule = ref(null);
const selectedFamilyMemberId = ref(null);
const appointmentSubmitting = ref(false);

const departmentList = computed(() =>
  [...portalStore.state.departments].sort((first, second) => {
    const firstOrder = Number.isFinite(first?.sortOrder) ? first.sortOrder : Number.MAX_SAFE_INTEGER;
    const secondOrder = Number.isFinite(second?.sortOrder) ? second.sortOrder : Number.MAX_SAFE_INTEGER;

    if (firstOrder !== secondOrder) {
      return firstOrder - secondOrder;
    }

    return Number(first?.id || 0) - Number(second?.id || 0);
  })
);
const doctorList = computed(() => portalStore.state.doctorPage.records || []);
const doctorPage = computed(() => portalStore.state.doctorPage);
const visiblePageNumbers = computed(() => {
  const totalPages = Number(doctorPage.value.pages || 0);
  const currentPage = Number(doctorPage.value.current || 1);

  if (totalPages <= 0) {
    return [];
  }

  if (totalPages <= 5) {
    return Array.from({ length: totalPages }, (_, index) => index + 1);
  }

  const startPage = Math.max(1, currentPage - 2);
  const endPage = Math.min(totalPages, startPage + 4);
  const normalizedStart = Math.max(1, endPage - 4);

  return Array.from({ length: endPage - normalizedStart + 1 }, (_, index) => normalizedStart + index);
});
const normalizedDoctorSchedules = computed(() =>
  doctorSchedules.value.map((item) => {
    const date = item?.scheduleDate ? new Date(item.scheduleDate) : null;
    const dayIndex = date ? date.getDay() : 0;

    return {
      ...item,
      monthDay: item?.scheduleDate ? item.scheduleDate.slice(5) : "--",
      weekday: item?.scheduleDate ? weekdayLabels[dayIndex] : "--"
    };
  })
);
const listedMembers = computed(() => portalStore.state.familyMembers || []);

function scheduleStatusText(slot) {
  if (!slot) {
    return "未排班";
  }

  if (slot.status === 3) {
    return "停诊";
  }

  if (slot.status === 2 || Number(slot.remainingQuota || 0) <= 0) {
    return "已满";
  }

  return `余: ${slot.remainingQuota}`;
}

function scheduleStatusClass(slot) {
  if (!slot) {
    return "muted";
  }

  if (slot.status === 3) {
    return "stopped";
  }

  if (slot.status === 2 || Number(slot.remainingQuota || 0) <= 0) {
    return "full";
  }

  return "available";
}

function timeSlotLabel(value) {
  return Number(value) === 1 ? "上午" : "下午";
}

function canBookSlot(slot) {
  return Boolean(slot) && slot.status !== 3 && slot.status !== 2 && Number(slot.remainingQuota || 0) > 0;
}

function formatScheduleChoice(item, slot) {
  return `${item.monthDay} ${item.weekday} ${timeSlotLabel(slot?.timeSlot)}`;
}

async function ensureDepartments() {
  if (departmentList.value.length || !authStore.state.token) {
    return;
  }

  try {
    await portalStore.loadDepartments(authStore.state.token);
  } catch (error) {
    if (handleUnauthorized(error, router)) {
      return;
    }
    showErrorMessage(error);
  }
}

async function loadDoctorsByDepartment(pageNum = 1) {
  if (!authStore.state.token || !portalStore.state.selectedDepartmentId) {
    return;
  }

  try {
    await portalStore.loadDoctors(authStore.state.token, pageNum);
  } catch (error) {
    if (handleUnauthorized(error, router)) {
      return;
    }
    showErrorMessage(error);
  }
}

async function selectDepartment(id) {
  if (portalStore.state.selectedDepartmentId === id) {
    return;
  }

  portalStore.state.selectedDepartmentId = id;
  await loadDoctorsByDepartment(1);
}

async function selectDoctor(id) {
  if (!authStore.state.token || !id) {
    return;
  }

  selectedSchedule.value = null;
  selectedFamilyMemberId.value = null;

  try {
    await portalStore.loadDoctorDetail(authStore.state.token, id);
    scheduleLoading.value = true;
    doctorSchedules.value = await fetchDoctorSchedules(authStore.state.token, id);
  } catch (error) {
    if (handleUnauthorized(error, router)) {
      return;
    }
    showErrorMessage(error);
  } finally {
    scheduleLoading.value = false;
  }
}

function chooseSchedule(item, slot) {
  if (!canBookSlot(slot)) {
    return;
  }

  selectedSchedule.value = {
    scheduleId: slot.id,
    scheduleDate: item.scheduleDate,
    weekday: item.weekday,
    monthDay: item.monthDay,
    timeSlot: slot.timeSlot,
    remainingQuota: slot.remainingQuota
  };
}

async function submitAppointment() {
  if (!authStore.state.token) {
    return;
  }

  if (!selectedSchedule.value) {
    showErrorMessage(new Error("请选择预约时段"));
    return;
  }

  if (!selectedFamilyMemberId.value) {
    showErrorMessage(new Error("请选择就诊人"));
    return;
  }

  appointmentSubmitting.value = true;

  try {
    const appointmentResult = await createAppointment(authStore.state.token, {
      scheduleId: selectedSchedule.value.scheduleId,
      familyMemberId: Number(selectedFamilyMemberId.value)
    });
    showSuccessMessage(`预约成功，预约号：${appointmentResult.appointmentNo}`);
    selectedSchedule.value = null;
    selectedFamilyMemberId.value = null;
    await portalStore.loadFamilyMembers(authStore.state.token);
    doctorSchedules.value = await fetchDoctorSchedules(authStore.state.token, portalStore.state.doctorDetail.id);
  } catch (error) {
    if (handleUnauthorized(error, router)) {
      return;
    }
    showErrorMessage(error);
  } finally {
    appointmentSubmitting.value = false;
  }
}

async function goToPage(pageNum) {
  if (
    pageNum < 1 ||
    pageNum > Number(doctorPage.value.pages || 1) ||
    pageNum === Number(doctorPage.value.current || 1)
  ) {
    return;
  }

  await loadDoctorsByDepartment(pageNum);
}

onMounted(async () => {
  await ensureDepartments();

  if (!doctorList.value.length && portalStore.state.selectedDepartmentId) {
    await loadDoctorsByDepartment(1);
  }
});
</script>

<template>
  <section class="appointment-shell appointment-shell--simple">
    <aside class="appointment-department-sidebar panel">
      <p v-if="portalStore.state.dashboardLoading" class="placeholder-text">正在加载科室信息...</p>
      <p v-else-if="!departmentList.length" class="placeholder-text">暂无科室信息</p>

      <div v-else class="appointment-department-list">
        <button
          v-for="department in departmentList"
          :key="department.id"
          :class="['appointment-department-item', { active: department.id === portalStore.state.selectedDepartmentId }]"
          type="button"
          @click="selectDepartment(department.id)"
        >
          {{ department.name }}
        </button>
      </div>

      <div v-if="doctorList.length" class="appointment-pager">
        <span class="appointment-pager__summary">
          共 {{ doctorPage.total || 0 }} 位医生
        </span>

        <button
          class="appointment-pager__button"
          :disabled="Number(doctorPage.current || 1) <= 1"
          type="button"
          @click="goToPage(Number(doctorPage.current || 1) - 1)"
        >
          上一页
        </button>

        <div class="appointment-pager__numbers">
          <button
            v-for="pageNumber in visiblePageNumbers"
            :key="pageNumber"
            :class="['appointment-pager__button', 'appointment-pager__button--number', { active: pageNumber === Number(doctorPage.current || 1) }]"
            type="button"
            @click="goToPage(pageNumber)"
          >
            {{ pageNumber }}
          </button>
        </div>

        <button
          class="appointment-pager__button"
          :disabled="Number(doctorPage.current || 1) >= Number(doctorPage.pages || 1)"
          type="button"
          @click="goToPage(Number(doctorPage.current || 1) + 1)"
        >
          下一页
        </button>
      </div>
    </aside>

    <section class="appointment-doctor-panel panel">
      <div v-if="!portalStore.state.doctorDetail" class="appointment-doctor-panel__heading">
        <h2>{{ portalStore.selectedDepartmentName.value }}</h2>
      </div>

      <p v-if="portalStore.state.doctorDetailLoading" class="placeholder-text">正在加载专家信息...</p>
      <p v-else-if="portalStore.state.doctorsLoading" class="placeholder-text">正在加载医生信息...</p>
      <p v-else-if="!portalStore.state.doctorDetail && !doctorList.length" class="placeholder-text">当前科室暂无医生</p>

      <section v-else-if="portalStore.state.doctorDetail" class="doctor-detail-view">
        <div class="doctor-detail-hero">
          <button
            class="doctor-detail-hero__back"
            type="button"
            @click="portalStore.state.doctorDetail = null; selectedSchedule = null"
          >
            ← 返回科室列表
          </button>

          <h2>
            {{ portalStore.state.doctorDetail.name }} · {{ portalStore.state.doctorDetail.title || "医生" }}
          </h2>

          <div class="doctor-detail-hero__meta">
            <span>所属科室 {{ portalStore.selectedDepartmentName.value }}</span>
          </div>
        </div>

        <div class="doctor-detail-sections">
          <section class="doctor-detail-section">
            <h3>专业特长</h3>
            <p>{{ portalStore.state.doctorDetail.specialty || "暂无医生专长信息" }}</p>
          </section>

          <section class="doctor-detail-section">
            <h3>医生简介</h3>
            <p>{{ portalStore.state.doctorDetail.introduction || "暂无医生简介" }}</p>
          </section>

          <section class="doctor-detail-section">
            <div class="doctor-detail-section__heading">
              <h3>未来 7 天号源排班</h3>
            </div>

            <p v-if="scheduleLoading" class="placeholder-text">正在加载排班信息...</p>

            <div v-else class="doctor-schedule-grid">
              <article v-for="item in normalizedDoctorSchedules" :key="item.scheduleDate" class="doctor-schedule-card">
                <span class="doctor-schedule-card__date">{{ item.monthDay }}</span>
                <strong>{{ item.weekday }}</strong>

                <div class="doctor-schedule-card__slots">
                  <button
                    :class="[
                      'doctor-schedule-card__slot',
                      { active: selectedSchedule?.scheduleId === item.morning?.id, disabled: !canBookSlot(item.morning) }
                    ]"
                    type="button"
                    @click="chooseSchedule(item, item.morning)"
                  >
                    <span>上午</span>
                    <em :class="['doctor-schedule-card__status', scheduleStatusClass(item.morning)]">
                      {{ scheduleStatusText(item.morning) }}
                    </em>
                  </button>

                  <button
                    :class="[
                      'doctor-schedule-card__slot',
                      { active: selectedSchedule?.scheduleId === item.afternoon?.id, disabled: !canBookSlot(item.afternoon) }
                    ]"
                    type="button"
                    @click="chooseSchedule(item, item.afternoon)"
                  >
                    <span>下午</span>
                    <em :class="['doctor-schedule-card__status', scheduleStatusClass(item.afternoon)]">
                      {{ scheduleStatusText(item.afternoon) }}
                    </em>
                  </button>
                </div>
              </article>
            </div>
          </section>

          <section class="doctor-detail-section doctor-booking-panel">
            <h3>选择就诊人并预约</h3>

            <div class="doctor-booking-panel__group">
              <span class="doctor-booking-panel__label">预约时段</span>
              <p class="doctor-booking-panel__value">
                {{ selectedSchedule ? formatScheduleChoice(selectedSchedule, selectedSchedule) : "请选择上方可预约时段" }}
              </p>
            </div>

            <div class="doctor-booking-panel__group">
              <span class="doctor-booking-panel__label">选择就诊人</span>
              <div class="doctor-booking-members">
                <button
                  v-for="member in listedMembers"
                  :key="member.id"
                  :class="['doctor-booking-member', { active: Number(selectedFamilyMemberId) === member.id }]"
                  type="button"
                  @click="selectedFamilyMemberId = member.id"
                >
                  <strong>{{ member.name }}</strong>
                  <span>{{ member.phone || "--" }}</span>
                </button>
              </div>
            </div>

            <button
              class="doctor-booking-submit"
              :disabled="appointmentSubmitting || !selectedSchedule || !selectedFamilyMemberId"
              type="button"
              @click="submitAppointment"
            >
              {{ appointmentSubmitting ? "提交中..." : "提交预约" }}
            </button>
          </section>
        </div>
      </section>

      <div v-else class="appointment-doctor-list">
        <article
          v-for="doctor in doctorList"
          :key="doctor.id"
          class="appointment-doctor-card"
          @click="selectDoctor(doctor.id)"
        >
          <div class="appointment-doctor-card__header">
            <div class="appointment-doctor-card__identity">
              <h3>{{ doctor.name }}</h3>
              <span>{{ doctor.title || "医生" }}</span>
            </div>
          </div>

          <div class="appointment-doctor-card__body">
            <p class="appointment-doctor-card__copy">
              {{ doctor.specialty || "暂无医生专长信息" }}
            </p>
          </div>
        </article>
      </div>
    </section>
  </section>
</template>
