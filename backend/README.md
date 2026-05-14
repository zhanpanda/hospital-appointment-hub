# 后端启动说明

## 项目说明

本目录为医院预约挂号系统后端，技术栈为：

- `Spring Boot 3.3.5`
- `Java 17`
- `MyBatis-Plus`
- `MySQL`
- `Redis`

启动类：

- `com.hospital.appointmenthub.HospitalAppointmentHubApplication`

## 启动前准备

启动后端前，请先确认本机已经安装并启动以下环境：

- `JDK 17`
- `Maven`
- `MySQL`
- `Redis`

可使用以下命令检查：

```powershell
java -version
mvn -v
```

## 配置文件位置

当前开发环境配置文件：

- `backend/src/main/resources/application-dev.yml`

当前默认配置为：

### MySQL

- 地址：`localhost:3306`
- 数据库名：`hospital-appointment-hub`
- 用户名：`root`
- 密码：`1234`

### Redis

- 地址：`localhost:6379`
- 密码：`1234`

如果你的本地环境不一致，请先修改 `application-dev.yml` 中对应配置。

## 数据库初始化

项目中提供了初始化 SQL 文件：

- `backend/src/main/resources/sql/init.sql`


默认访问地址：

- `http://localhost:8080`

## 常见问题

### 1. MySQL 连接失败

请检查：

- MySQL 是否已启动
- 数据库 `hospital-appointment-hub` 是否已创建
- 用户名和密码是否正确

### 2. Redis 连接失败

请检查：

- Redis 是否已启动
- Redis 密码是否正确
- `6379` 端口是否可用

### 3. 端口占用

如果 `8080` 被占用，可以在配置文件中增加：

```yaml
server:
  port: 8081
```

## 补充说明

- 当前登录态依赖 `Redis`
- 登录/注册成功后会将 token 写入 Redis
- 登出时会删除 Redis 中对应 token
- 如果修改了后端代码，请记得重新启动后端程序
