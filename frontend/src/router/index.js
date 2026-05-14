import { createRouter, createWebHistory } from "vue-router";

const routes = [
  {
    path: "/",
    component: () => import("@/views/layout/index.vue"),
    meta: { requiresAuth: true },
    children: [
      {
        path: "",
        redirect: { name: "home" }
      },
      {
        path: "home",
        name: "home",
        component: () => import("@/views/home/index.vue"),
        meta: { title: "首页" }
      },
      {
        path: "appointments",
        name: "appointments",
        component: () => import("@/views/appointments/index.vue"),
        meta: { title: "预约挂号" }
      },
      {
        path: "members",
        name: "members",
        component: () => import("@/views/members/index.vue"),
        meta: { title: "就诊人管理" }
      },
      {
        path: "notices",
        name: "notices",
        component: () => import("@/views/notices/index.vue"),
        meta: { title: "我的预约" }
      }
    ]
  },
  {
    path: "/login",
    name: "login",
    component: () => import("@/views/login/index.vue"),
    meta: { title: "登录", guestOnly: true }
  },
  {
    path: "/:pathMatch(.*)*",
    redirect: "/"
  }
];

const router = createRouter({
  history: createWebHistory(),
  routes,
  scrollBehavior() {
    return {
      top: 0,
      left: 0
    };
  }
});

export default router;
