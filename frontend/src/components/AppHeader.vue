<script setup>
const props = defineProps({
  activePage: {
    type: String,
    default: "home"
  },
  userDisplayName: {
    type: String,
    default: "当前用户"
  }
});

const emit = defineEmits(["navigate", "logout"]);

const navItems = [
  { name: "home", label: "首页" },
  { name: "appointments", label: "预约挂号" },
  { name: "members", label: "就诊人管理" },
  { name: "notices", label: "我的预约" }
];
</script>

<template>
  <header class="app-header app-header--nav">
    <div class="app-header__brand app-header__brand--nav">
      <span class="brand-wordmark">HosCare+</span>

      <nav class="app-nav">
        <button
          v-for="item in navItems"
          :key="item.name"
          :class="['app-nav__item', { active: activePage === item.name }]"
          type="button"
          @click="emit('navigate', item.name)"
        >
          {{ item.label }}
        </button>
      </nav>
    </div>

    <div class="app-userbox">
      <div class="app-userbox__avatar">{{ userDisplayName.slice(0, 1).toUpperCase() }}</div>
      <span>{{ userDisplayName }}</span>
      <button class="app-userbox__logout" type="button" @click="emit('logout')">
        退出登录
      </button>
    </div>
  </header>
</template>
