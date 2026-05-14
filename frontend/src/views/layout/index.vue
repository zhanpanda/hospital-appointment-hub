<script setup>
import { computed, onMounted, watch } from "vue";
import { RouterView, useRoute, useRouter } from "vue-router";
import { logoutPatient } from "@/api/auth";
import AppHeader from "@/components/AppHeader.vue";
import { useAuthStore } from "@/stores/auth";
import { usePortalStore } from "@/stores/portal";
import { handleUnauthorized } from "@/utils/auth";
import { showErrorMessage } from "@/utils/message";

const route = useRoute();
const router = useRouter();
const authStore = useAuthStore();
const portalStore = usePortalStore();

const activePage = computed(() => String(route.name || "home"));
const userDisplayName = computed(() => authStore.state.displayName || "当前用户");

async function bootstrapPortal() {
  if (!authStore.state.token) {
    return;
  }

  try {
    await portalStore.bootstrap(authStore.state.token);
  } catch (error) {
    if (handleUnauthorized(error, router)) {
      return;
    }
    showErrorMessage(error);
  }
}

function navigate(pageName) {
  router.push({ name: pageName });
}

async function logout() {
  const currentToken = authStore.state.token;

  try {
    if (currentToken) {
      await logoutPatient(currentToken);
    }
  } catch (error) {
    if (!handleUnauthorized(error, router)) {
      showErrorMessage(error);
    }
  } finally {
    authStore.clearSession();
    portalStore.clearState();
    router.replace({ name: "login" });
  }
}

onMounted(() => {
  bootstrapPortal();
});

watch(
  () => authStore.state.token,
  (newToken, oldToken) => {
    if (!newToken) {
      portalStore.clearState();
      return;
    }

    if (newToken !== oldToken) {
      bootstrapPortal();
    }
  }
);
</script>

<template>
  <main :class="['app-shell', 'app-shell--dashboard', `app-shell--${activePage}`]">
    <section :class="['dashboard-screen', `dashboard-screen--${activePage}`]">
      <AppHeader
        :active-page="activePage"
        :user-display-name="userDisplayName"
        @navigate="navigate"
        @logout="logout"
      />

      <RouterView />
    </section>
  </main>
</template>
