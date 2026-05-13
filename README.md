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
- 后端：Spring Boot 3 + H2

## 启动顺序

1. 进入 `backend/`，执行 `mvn spring-boot:run`
2. 进入 `frontend/`，执行 `npm install`
3. 执行 `npm run dev`

## 默认端口

- 前端：`5173`
- 后端：`8080`

## 当前已提供的示例能力

- Spring Boot 健康检查接口：`/api/health`
- Spring Boot 医生列表接口：`/api/doctors`
- Vue 首页展示后端状态与医生信息
