# hospital-appointment-hub

当前仓库已初始化为前后端分离结构：

```text
├── backend/
│   ├── src/
│   ├── 数据库初始化脚本/
│   ├── pom.xml
│   └── README.md
├── frontend/
│   ├── src/
│   ├── package.json
│   └── README.md
```

## 技术栈

- 前端：Vue 3 + Vite
- 后端：Spring Boot 3 + MyBatis-Plus + MySQL

## 启动顺序

1. 进入 `backend/`，执行 `mvn spring-boot:run`
2. 进入 `frontend/`，执行 `npm install`
3. 执行 `npm run dev`

## 默认端口

- 前端：`5173`
- 后端：`8080`

## 当前前端已对接的能力

- 患者手机号 / 邮箱注册：`/api/patient/register/*`
- 患者手机号 / 邮箱登录：`/api/patient/login/*`
- 科室列表：`/api/departments`
- 按科室分页查询医生与医生详情：`/api/doctors`
- 就诊人新增、编辑、删除、设默认：`/api/family-member`

## 联调说明

- 前端开发服务器已通过 Vite 代理 `/api` 到 `http://localhost:8080`
- 后端业务接口默认要求携带 `Authorization: Bearer <token>` 请求头
- 预约记录与排班控制器目前仍未开放具体接口，因此本轮前端未接入这两块
