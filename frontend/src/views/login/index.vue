<script setup>
import { reactive, ref, watch } from "vue";
import { useRouter } from "vue-router";
import { loginByEmail, loginByPhone, registerByEmail, registerByPhone } from "@/api/auth";
import { useAuthStore } from "@/stores/auth";
import { showErrorMessage, showSuccessMessage } from "@/utils/message";

const router = useRouter();
const authStore = useAuthStore();

const authMode = ref("login");
const authChannel = ref("phone");
const authLoading = ref(false);

const authForm = reactive({
  phone: "",
  email: "",
  password: "",
  confirmPassword: ""
});

const authFieldErrors = reactive({
  phone: "",
  email: "",
  password: "",
  confirmPassword: ""
});

const phonePattern = /^1[3-9]\d{9}$/;
const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
const passwordPattern = /^(?=.*[a-zA-Z])(?=.*\d)[\x21-\x7E]{8,20}$/;

function resetAuthForm() {
  authForm.phone = "";
  authForm.email = "";
  authForm.password = "";
  authForm.confirmPassword = "";
  authFieldErrors.phone = "";
  authFieldErrors.email = "";
  authFieldErrors.password = "";
  authFieldErrors.confirmPassword = "";
}

function maskPhone(phone) {
  return phone.slice(0, 3) + "****" + phone.slice(7);
}

function buildDisplayName() {
  return authChannel.value === "phone" ? maskPhone(authForm.phone) : authForm.email;
}

function validateAuthForm() {
  authFieldErrors.phone = "";
  authFieldErrors.email = "";
  authFieldErrors.password = "";
  authFieldErrors.confirmPassword = "";

  if (authChannel.value === "phone") {
    if (!authForm.phone) {
      authFieldErrors.phone = "请输入手机号码";
      return false;
    }
    if (!phonePattern.test(authForm.phone)) {
      authFieldErrors.phone = "手机号码格式错误，请输入正确的手机号码";
      return false;
    }
  } else {
    if (!authForm.email) {
      authFieldErrors.email = "请输入邮箱地址";
      return false;
    }
    if (!emailPattern.test(authForm.email)) {
      authFieldErrors.email = "邮箱格式错误，请输入正确的邮箱地址";
      return false;
    }
  }

  if (!authForm.password) {
    authFieldErrors.password = "请输入密码";
    return false;
  }
  if (!passwordPattern.test(authForm.password)) {
    authFieldErrors.password = "密码长度为 8-20 位，必须包含字母和数字";
    return false;
  }

  if (authMode.value === "register") {
    if (!authForm.confirmPassword) {
      authFieldErrors.confirmPassword = "请再次输入密码";
      return false;
    }
    if (authForm.password !== authForm.confirmPassword) {
      authFieldErrors.confirmPassword = "两次输入的密码不一致";
      return false;
    }
  }

  return true;
}

async function submitAuth() {
  authLoading.value = true;

  const isValid = validateAuthForm();
  if (!isValid) {
    authLoading.value = false;
    return;
  }

  const payload =
    authChannel.value === "phone"
      ? { phone: authForm.phone, password: authForm.password }
      : { email: authForm.email, password: authForm.password };

  if (authMode.value === "register") {
    payload.confirmPassword = authForm.confirmPassword;
  }

  const requestMap = {
    login: {
      phone: loginByPhone,
      email: loginByEmail
    },
    register: {
      phone: registerByPhone,
      email: registerByEmail
    }
  };

  try {
    const nextToken = await requestMap[authMode.value][authChannel.value](payload);
    authStore.setSession({
      token: nextToken,
      displayName: buildDisplayName()
    });
    showSuccessMessage(authMode.value === "login" ? "登录成功" : "注册成功");
    router.replace({ name: "home" });
  } catch (error) {
    showErrorMessage(error);
  } finally {
    authLoading.value = false;
  }
}

watch(authChannel, () => {
  resetAuthForm();
});

watch(authMode, () => {
  resetAuthForm();
});
</script>

<template>
  <main class="app-shell">
    <section class="auth-screen">
      <div class="auth-stage">
        <section class="auth-showcase">
          <div class="auth-showcase__content">
            <h1>医院预约服务</h1>
            <p class="auth-copy">
              在线完成账号登录、医生查看与常用就诊人维护，让预约流程更顺手、更省时。
            </p>
          </div>
        </section>

        <article class="auth-card auth-card--compact">
          <div class="auth-channel-card">
            <div class="channel-switch channel-switch--wide">
              <button
                :class="{ active: authChannel === 'phone' }"
                type="button"
                @click="authChannel = 'phone'"
              >
                {{ authMode === "login" ? "手机号登录" : "手机号注册" }}
              </button>

              <button
                :class="{ active: authChannel === 'email' }"
                type="button"
                @click="authChannel = 'email'"
              >
                {{ authMode === "login" ? "邮箱登录" : "邮箱注册" }}
              </button>
            </div>
          </div>

          <form
            :key="`${authMode}-${authChannel}`"
            autocomplete="off"
            class="stack-form auth-form"
            @submit.prevent="submitAuth"
          >
            <template v-if="authChannel === 'phone'">
              <label class="field field--icon">
                <span class="input-icon" aria-hidden="true">
                  <svg viewBox="0 0 24 24" fill="none">
                    <path
                      d="M16.5 2.75h-9A2.75 2.75 0 0 0 4.75 5.5v13A2.75 2.75 0 0 0 7.5 21.25h9a2.75 2.75 0 0 0 2.75-2.75v-13A2.75 2.75 0 0 0 16.5 2.75Z"
                      stroke="currentColor"
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="1.8"
                    />
                    <path
                      d="M10 18.25h4"
                      stroke="currentColor"
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="1.8"
                    />
                  </svg>
                </span>
                <input
                  v-model.trim="authForm.phone"
                  autocomplete="off"
                  placeholder="请输入手机号码"
                  spellcheck="false"
                  type="text"
                />
              </label>

              <p v-if="authFieldErrors.phone" class="inline-error inline-error--field">
                {{ authFieldErrors.phone }}
              </p>
            </template>

            <template v-else>
              <label class="field field--icon">
                <span class="input-icon" aria-hidden="true">
                  <svg viewBox="0 0 24 24" fill="none">
                    <path
                      d="M4 7.75 11.157 13a1.45 1.45 0 0 0 1.686 0L20 7.75"
                      stroke="currentColor"
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="1.8"
                    />
                    <rect
                      x="3"
                      y="5"
                      width="18"
                      height="14"
                      rx="3"
                      stroke="currentColor"
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="1.8"
                    />
                  </svg>
                </span>
                <input
                  v-model.trim="authForm.email"
                  autocomplete="off"
                  placeholder="请输入邮箱地址"
                  spellcheck="false"
                  type="email"
                />
              </label>

              <p v-if="authFieldErrors.email" class="inline-error inline-error--field">
                {{ authFieldErrors.email }}
              </p>
            </template>

            <label class="field field--icon">
              <span class="input-icon" aria-hidden="true">
                <svg viewBox="0 0 24 24" fill="none">
                  <rect
                    x="4"
                    y="10"
                    width="16"
                    height="10"
                    rx="2.5"
                    stroke="currentColor"
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="1.8"
                  />
                  <path
                    d="M8 10V7.75a4 4 0 1 1 8 0V10"
                    stroke="currentColor"
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="1.8"
                  />
                </svg>
              </span>
              <input
                v-model="authForm.password"
                autocomplete="new-password"
                placeholder="请输入密码"
                type="password"
              />
            </label>

            <p v-if="authFieldErrors.password" class="inline-error inline-error--field">
              {{ authFieldErrors.password }}
            </p>

            <label v-if="authMode === 'register'" class="field field--icon">
              <span class="input-icon" aria-hidden="true">
                <svg viewBox="0 0 24 24" fill="none">
                  <rect
                    x="4"
                    y="10"
                    width="16"
                    height="10"
                    rx="2.5"
                    stroke="currentColor"
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="1.8"
                  />
                  <path
                    d="M8 10V7.75a4 4 0 1 1 8 0V10"
                    stroke="currentColor"
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="1.8"
                  />
                </svg>
              </span>
              <input
                v-model="authForm.confirmPassword"
                autocomplete="new-password"
                placeholder="请再次输入密码"
                type="password"
              />
            </label>

            <p v-if="authFieldErrors.confirmPassword" class="inline-error inline-error--field">
              {{ authFieldErrors.confirmPassword }}
            </p>

            <button class="primary-button auth-submit" :disabled="authLoading" type="submit">
              {{ authLoading ? "提交中..." : authMode === "login" ? "登录" : "注册" }}
            </button>
          </form>

          <div class="auth-switch-line">
            <span class="auth-switch-line__rule" aria-hidden="true"></span>
            <span class="muted-text">
              {{ authMode === "login" ? "没有账号？" : "已有账号？" }}
            </span>
            <button
              class="auth-switch-link"
              type="button"
              @click="authMode = authMode === 'login' ? 'register' : 'login'"
            >
              {{ authMode === "login" ? "立即注册" : "立即登录" }}
            </button>
            <span class="auth-switch-line__rule" aria-hidden="true"></span>
          </div>
        </article>
      </div>
    </section>
  </main>
</template>
