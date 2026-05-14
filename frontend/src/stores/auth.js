import { computed, reactive } from "vue";
import { DISPLAY_NAME_STORAGE_KEY, TOKEN_STORAGE_KEY } from "@/constants/storage";

const state = reactive({
  token: window.localStorage.getItem(TOKEN_STORAGE_KEY) || "",
  displayName: window.localStorage.getItem(DISPLAY_NAME_STORAGE_KEY) || ""
});

const isAuthenticated = computed(() => Boolean(state.token));

function setSession({ token, displayName }) {
  state.token = token;
  state.displayName = displayName;
  window.localStorage.setItem(TOKEN_STORAGE_KEY, token);
  window.localStorage.setItem(DISPLAY_NAME_STORAGE_KEY, displayName);
}

function clearSession() {
  state.token = "";
  state.displayName = "";
  window.localStorage.removeItem(TOKEN_STORAGE_KEY);
  window.localStorage.removeItem(DISPLAY_NAME_STORAGE_KEY);
}

function setDisplayName(displayName) {
  state.displayName = displayName;
  window.localStorage.setItem(DISPLAY_NAME_STORAGE_KEY, displayName);
}

export function useAuthStore() {
  return {
    state,
    isAuthenticated,
    setSession,
    clearSession,
    setDisplayName
  };
}
