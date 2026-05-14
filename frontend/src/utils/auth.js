import { useAuthStore } from "@/stores/auth";

export function handleUnauthorized(error, router) {
  if (error?.status === 401 || error?.payload?.code === 401) {
    const authStore = useAuthStore();
    authStore.clearSession();
    router.replace({ name: "login" });
    return true;
  }

  return false;
}
