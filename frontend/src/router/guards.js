import router from "@/router";
import { useAuthStore } from "@/stores/auth";

router.beforeEach((to) => {
  const authStore = useAuthStore();

  if (to.meta?.requiresAuth && !authStore.isAuthenticated.value) {
    return { name: "login" };
  }

  if (to.meta?.guestOnly && authStore.isAuthenticated.value) {
    return { name: "home" };
  }

  document.title = `医院预约服务 - ${to.meta?.title || "首页"}`;
  return true;
});
