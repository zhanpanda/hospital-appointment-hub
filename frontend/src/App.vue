<script setup>
import { onMounted, ref } from "vue";

const apiBaseUrl = "http://localhost:8080";
const doctors = ref([]);
const healthMessage = ref("加载中...");
const loading = ref(true);
const error = ref("");

async function loadDashboard() {
  loading.value = true;
  error.value = "";

  try {
    const [healthResponse, doctorsResponse] = await Promise.all([
      fetch(`${apiBaseUrl}/api/health`),
      fetch(`${apiBaseUrl}/api/doctors`)
    ]);

    if (!healthResponse.ok || !doctorsResponse.ok) {
      throw new Error("后端接口请求失败");
    }

    const healthData = await healthResponse.json();
    const doctorsData = await doctorsResponse.json();

    healthMessage.value = healthData.message;
    doctors.value = doctorsData;
  } catch (requestError) {
    error.value = requestError instanceof Error ? requestError.message : "未知错误";
  } finally {
    loading.value = false;
  }
}

onMounted(() => {
  loadDashboard();
});
</script>

<template>
  <main class="page-shell">
    <section class="hero">
      <div>
        <p class="eyebrow">Hospital Appointment Hub</p>
        <h1>医院预约管理平台</h1>
        <p class="hero-copy">
          当前项目已拆分为 Vue 前端和 Spring Boot 后端，页面会在启动后直接读取后端健康状态与医生排班数据。
        </p>
      </div>
      <button class="refresh-button" @click="loadDashboard">刷新数据</button>
    </section>

    <section class="status-card">
      <h2>服务状态</h2>
      <p v-if="loading">正在连接后端服务...</p>
      <p v-else-if="error" class="error-text">{{ error }}</p>
      <p v-else>{{ healthMessage }}</p>
    </section>

    <section class="doctor-panel">
      <div class="section-heading">
        <h2>今日可预约医生</h2>
        <span>{{ doctors.length }} 位医生</span>
      </div>

      <div v-if="!loading && !error" class="doctor-grid">
        <article v-for="doctor in doctors" :key="doctor.id" class="doctor-card">
          <div class="doctor-card__header">
            <h3>{{ doctor.name }}</h3>
            <span>{{ doctor.title }}</span>
          </div>
          <p>{{ doctor.department }}</p>
          <strong>剩余号源：{{ doctor.availableSlots }}</strong>
        </article>
      </div>
    </section>
  </main>
</template>
