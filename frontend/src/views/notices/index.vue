<script setup>
import { computed, onMounted, reactive, ref } from "vue";
import { useRouter } from "vue-router";
import { cancelAppointment, fetchAppointments } from "@/api/appointment";
import { useAuthStore } from "@/stores/auth";
import { handleUnauthorized } from "@/utils/auth";
import { showErrorMessage, showSuccessMessage } from "@/utils/message";

const router = useRouter();
const authStore = useAuthStore();

const loading = ref(false);
const cancellingId = ref(null);
const appointmentPage = reactive({
  records: [],
  current: 1,
  size: 10,
  total: 0,
  pages: 0
});

const visiblePageNumbers = computed(() => {
  const totalPages = Number(appointmentPage.pages || 0);
  const currentPage = Number(appointmentPage.current || 1);

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

function timeSlotLabel(value) {
  return Number(value) === 1 ? "上午" : "下午";
}

function appointmentStatusLabel(value) {
  if (Number(value) === 2) {
    return "已取消";
  }
  if (Number(value) === 3) {
    return "已完成";
  }
  return "待就诊";
}

function appointmentStatusClass(value) {
  if (Number(value) === 2) {
    return "cancelled";
  }
  if (Number(value) === 3) {
    return "finished";
  }
  return "pending";
}

async function cancelCurrentAppointment(id) {
  if (!authStore.state.token || !id) {
    return;
  }

  if (!window.confirm("确认取消这条预约吗？")) {
    return;
  }

  cancellingId.value = id;

  try {
    await cancelAppointment(authStore.state.token, id);
    showSuccessMessage("预约已取消");
    await loadAppointmentPage(Number(appointmentPage.current || 1));
  } catch (error) {
    if (handleUnauthorized(error, router)) {
      return;
    }
    showErrorMessage(error);
  } finally {
    cancellingId.value = null;
  }
}

async function loadAppointmentPage(pageNum = 1) {
  if (!authStore.state.token) {
    return;
  }

  loading.value = true;

  try {
    const data = await fetchAppointments(authStore.state.token, {
      pageNum,
      pageSize: 10
    });

    appointmentPage.records = data?.records || [];
    appointmentPage.current = data?.current || pageNum;
    appointmentPage.size = data?.size || 10;
    appointmentPage.total = data?.total || 0;
    appointmentPage.pages = data?.pages || 0;
  } catch (error) {
    if (handleUnauthorized(error, router)) {
      return;
    }
    showErrorMessage(error);
  } finally {
    loading.value = false;
  }
}

async function goToPage(pageNum) {
  if (
    pageNum < 1 ||
    pageNum > Number(appointmentPage.pages || 1) ||
    pageNum === Number(appointmentPage.current || 1)
  ) {
    return;
  }

  await loadAppointmentPage(pageNum);
}

onMounted(() => {
  loadAppointmentPage(1);
});
</script>

<template>
  <section class="notices-shell panel my-appointments-shell">
    <div class="panel-heading">
      <div>
        <h2>我的预约</h2>
      </div>
    </div>

    <p v-if="loading" class="placeholder-text">正在加载预约记录...</p>
    <p v-else-if="!appointmentPage.records.length" class="placeholder-text">暂无预约记录</p>

    <div v-else class="my-appointment-list">
      <article v-for="item in appointmentPage.records" :key="item.id" class="my-appointment-card">
        <div class="my-appointment-card__header">
          <div class="my-appointment-card__title">
            <h3>{{ item.departmentName || "未命名科室" }}</h3>
            <span :class="['my-appointment-status', appointmentStatusClass(item.status)]">
              {{ appointmentStatusLabel(item.status) }}
            </span>
          </div>

          <p class="my-appointment-card__no">预约号 {{ item.appointmentNo }}</p>
        </div>

        <div class="my-appointment-card__body">
          <div class="my-appointment-info">
            <span class="my-appointment-info__label">医生</span>
            <span>{{ item.doctorName }} {{ item.doctorTitle || "" }}</span>
          </div>
          <div class="my-appointment-info">
            <span class="my-appointment-info__label">就诊人</span>
            <span>{{ item.memberName }}</span>
          </div>
          <div class="my-appointment-info">
            <span class="my-appointment-info__label">时间</span>
            <span>{{ item.appointmentDate }} {{ timeSlotLabel(item.timeSlot) }}</span>
          </div>
          <div class="my-appointment-info">
            <span class="my-appointment-info__label">备注</span>
            <span>{{ item.remark || "--" }}</span>
          </div>
        </div>

        <div v-if="item.canCancel" class="my-appointment-card__footer">
          <button
            class="my-appointment-cancel"
            :disabled="cancellingId === item.id"
            type="button"
            @click="cancelCurrentAppointment(item.id)"
          >
            {{ cancellingId === item.id ? "取消中..." : "取消预约" }}
          </button>
        </div>
      </article>
    </div>

    <div v-if="appointmentPage.records.length" class="my-appointment-pager">
      <span class="my-appointment-pager__summary">共 {{ appointmentPage.total || 0 }} 条预约</span>

      <button
        class="my-appointment-pager__button"
        :disabled="Number(appointmentPage.current || 1) <= 1"
        type="button"
        @click="goToPage(Number(appointmentPage.current || 1) - 1)"
      >
        上一页
      </button>

      <div class="my-appointment-pager__numbers">
        <button
          v-for="pageNumber in visiblePageNumbers"
          :key="pageNumber"
          :class="['my-appointment-pager__button', 'my-appointment-pager__button--number', { active: pageNumber === Number(appointmentPage.current || 1) }]"
          type="button"
          @click="goToPage(pageNumber)"
        >
          {{ pageNumber }}
        </button>
      </div>

      <button
        class="my-appointment-pager__button"
        :disabled="Number(appointmentPage.current || 1) >= Number(appointmentPage.pages || 1)"
        type="button"
        @click="goToPage(Number(appointmentPage.current || 1) + 1)"
      >
        下一页
      </button>
    </div>
  </section>
</template>
