# API 文档

## 1. 文档说明

本文档面向 `hospital-appointment-hub` 项目的前后端联调、接口测试和项目答辩说明，整理了当前系统已实现的完整接口列表、请求示例、响应示例和状态码说明。

当前后端服务默认地址：

- 本地开发：`http://localhost:8080`
- 接口统一前缀：`/api`

完整请求地址示例：

- `http://localhost:8080/api/departments`

---

## 2. 通用约定

### 2.1 鉴权方式

除注册、登录接口外，其余 `/api/**` 接口默认都需要登录。

请求头格式：

```http
Authorization: Bearer <token>
```

说明：

- `token` 由注册成功或登录成功接口返回。
- 后端会同时校验 `JWT` 和 `Redis` 中缓存的 token。
- 若 token 缺失、过期、格式错误或与 Redis 中记录不一致，接口会返回 `401`。

### 2.2 请求与响应格式

- 请求体默认使用 `application/json`
- 响应体统一为 JSON

统一响应结构：

```json
{
  "code": 200,
  "message": "请求成功",
  "data": {},
  "timestamp": "2026-05-14T12:30:45.123Z"
}
```

字段说明：

- `code`：业务状态码，通常与 HTTP 状态码一致
- `message`：结果描述
- `data`：响应数据，成功时返回对象、数组、字符串或 `null`
- `timestamp`：后端返回时间

### 2.3 分页返回格式

部分分页接口直接返回 MyBatis-Plus 分页对象，常见结构如下：

```json
{
  "code": 200,
  "message": "请求成功",
  "data": {
    "records": [],
    "total": 18,
    "size": 10,
    "current": 1,
    "pages": 2
  },
  "timestamp": "2026-05-14T12:30:45.123Z"
}
```

### 2.4 参数校验失败格式

当请求参数不合法时，返回示例：

```json
{
  "code": 400,
  "message": "请求参数错误或格式不正确",
  "data": {
    "errors": [
      {
        "field": "phone",
        "message": "手机号码格式错误，请输入正确的手机号码"
      }
    ]
  },
  "timestamp": "2026-05-14T12:30:45.123Z"
}
```

---

## 3. 接口总览

### 3.1 患者认证接口

| 接口 | 方法 | 说明 | 是否鉴权 |
| --- | --- | --- | --- |
| `/api/patient/register/phone` | `POST` | 手机号注册 | 否 |
| `/api/patient/register/email` | `POST` | 邮箱注册 | 否 |
| `/api/patient/login/phone` | `POST` | 手机号登录 | 否 |
| `/api/patient/login/email` | `POST` | 邮箱登录 | 否 |
| `/api/patient/logout` | `POST` | 退出登录 | 是 |

### 3.2 科室与医生接口

| 接口 | 方法 | 说明 | 是否鉴权 |
| --- | --- | --- | --- |
| `/api/departments` | `GET` | 获取启用中的科室列表 | 是 |
| `/api/doctors` | `GET` | 按科室分页查询医生 | 是 |
| `/api/doctors/{id}` | `GET` | 查询医生详情 | 是 |
| `/api/schedules` | `GET` | 查询医生未来 7 天排班 | 是 |

### 3.3 就诊人管理接口

| 接口 | 方法 | 说明 | 是否鉴权 |
| --- | --- | --- | --- |
| `/api/family-member` | `POST` | 新增就诊人 | 是 |
| `/api/family-member` | `GET` | 获取当前患者的就诊人列表 | 是 |
| `/api/family-member/{id}` | `GET` | 获取就诊人详情 | 是 |
| `/api/family-member/{id}` | `PUT` | 修改就诊人 | 是 |
| `/api/family-member/{id}/default` | `PUT` | 设置默认就诊人 | 是 |
| `/api/family-member/{id}` | `DELETE` | 删除就诊人 | 是 |

### 3.4 预约挂号接口

| 接口 | 方法 | 说明 | 是否鉴权 |
| --- | --- | --- | --- |
| `/api/appointments` | `GET` | 分页查询我的预约 | 是 |
| `/api/appointments` | `POST` | 提交预约 | 是 |
| `/api/appointments/{id}/cancel` | `PUT` | 取消预约 | 是 |

---

## 4. 详细接口说明

## 4.1 患者认证接口

### 4.1.1 手机号注册

- 请求方法：`POST`
- 请求路径：`/api/patient/register/phone`
- 是否鉴权：否

请求体：

```json
{
  "phone": "13812345678",
  "password": "abc12345",
  "confirmPassword": "abc12345"
}
```

参数说明：

- `phone`：手机号，必填，格式必须为大陆手机号
- `password`：密码，必填，长度 8-20 位，必须同时包含字母和数字
- `confirmPassword`：确认密码，必填，必须与 `password` 一致

成功响应示例：

```json
{
  "code": 200,
  "message": "请求成功",
  "data": "eyJhbGciOiJIUzI1NiJ9.phone-register-token-demo",
  "timestamp": "2026-05-14T12:30:45.123Z"
}
```

失败响应示例：

```json
{
  "code": 409,
  "message": "手机号已存在",
  "data": null,
  "timestamp": "2026-05-14T12:30:45.123Z"
}
```

### 4.1.2 邮箱注册

- 请求方法：`POST`
- 请求路径：`/api/patient/register/email`
- 是否鉴权：否

请求体：

```json
{
  "email": "demo@example.com",
  "password": "abc12345",
  "confirmPassword": "abc12345"
}
```

成功响应示例：

```json
{
  "code": 200,
  "message": "请求成功",
  "data": "eyJhbGciOiJIUzI1NiJ9.email-register-token-demo",
  "timestamp": "2026-05-14T12:30:45.123Z"
}
```

### 4.1.3 手机号登录

- 请求方法：`POST`
- 请求路径：`/api/patient/login/phone`
- 是否鉴权：否

请求体：

```json
{
  "phone": "13812345678",
  "password": "abc12345"
}
```

成功响应示例：

```json
{
  "code": 200,
  "message": "请求成功",
  "data": "eyJhbGciOiJIUzI1NiJ9.phone-login-token-demo",
  "timestamp": "2026-05-14T12:30:45.123Z"
}
```

失败响应示例：

```json
{
  "code": 401,
  "message": "密码错误",
  "data": null,
  "timestamp": "2026-05-14T12:30:45.123Z"
}
```

### 4.1.4 邮箱登录

- 请求方法：`POST`
- 请求路径：`/api/patient/login/email`
- 是否鉴权：否

请求体：

```json
{
  "email": "demo@example.com",
  "password": "abc12345"
}
```

成功响应示例：

```json
{
  "code": 200,
  "message": "请求成功",
  "data": "eyJhbGciOiJIUzI1NiJ9.email-login-token-demo",
  "timestamp": "2026-05-14T12:30:45.123Z"
}
```

### 4.1.5 退出登录

- 请求方法：`POST`
- 请求路径：`/api/patient/logout`
- 是否鉴权：是

请求头：

```http
Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.logout-token-demo
```

成功响应示例：

```json
{
  "code": 200,
  "message": "请求成功",
  "data": null,
  "timestamp": "2026-05-14T12:30:45.123Z"
}
```

---

## 4.2 科室与医生接口

### 4.2.1 获取科室列表

- 请求方法：`GET`
- 请求路径：`/api/departments`
- 是否鉴权：是

成功响应示例：

```json
{
  "code": 200,
  "message": "请求成功",
  "data": [
    {
      "id": 1,
      "name": "内科",
      "sortOrder": 1,
      "status": 1,
      "createdAt": "2026-05-10T08:00:00",
      "updatedAt": "2026-05-10T08:00:00"
    },
    {
      "id": 2,
      "name": "外科",
      "sortOrder": 2,
      "status": 1,
      "createdAt": "2026-05-10T08:00:00",
      "updatedAt": "2026-05-10T08:00:00"
    }
  ],
  "timestamp": "2026-05-14T12:30:45.123Z"
}
```

### 4.2.2 按科室分页查询医生

- 请求方法：`GET`
- 请求路径：`/api/doctors`
- 是否鉴权：是

查询参数：

- `departmentId`：科室 ID，必填
- `pageNum`：页码，选填，默认 `1`
- `pageSize`：每页条数，选填，默认 `10`

请求示例：

```http
GET /api/doctors?departmentId=1&pageNum=1&pageSize=10
```

成功响应示例：

```json
{
  "code": 200,
  "message": "请求成功",
  "data": {
    "records": [
      {
        "id": 101,
        "name": "张医生",
        "title": "主任医师",
        "specialty": "擅长高血压、冠心病、慢性病管理"
      },
      {
        "id": 102,
        "name": "李医生",
        "title": "副主任医师",
        "specialty": "擅长呼吸系统疾病诊疗"
      }
    ],
    "total": 2,
    "size": 10,
    "current": 1,
    "pages": 1
  },
  "timestamp": "2026-05-14T12:30:45.123Z"
}
```

失败响应示例：

```json
{
  "code": 400,
  "message": "请求参数错误或格式不正确",
  "data": {
    "errors": [
      {
        "field": "departmentId",
        "message": "科室ID不能为空"
      }
    ]
  },
  "timestamp": "2026-05-14T12:30:45.123Z"
}
```

### 4.2.3 查询医生详情

- 请求方法：`GET`
- 请求路径：`/api/doctors/{id}`
- 是否鉴权：是

请求示例：

```http
GET /api/doctors/101
```

成功响应示例：

```json
{
  "code": 200,
  "message": "请求成功",
  "data": {
    "id": 101,
    "departmentId": 1,
    "name": "张医生",
    "title": "主任医师",
    "specialty": "擅长高血压、冠心病、慢性病管理",
    "introduction": "从事内科临床工作 20 余年，具备丰富门诊经验。"
  },
  "timestamp": "2026-05-14T12:30:45.123Z"
}
```

失败响应示例：

```json
{
  "code": 404,
  "message": "医生不存在",
  "data": null,
  "timestamp": "2026-05-14T12:30:45.123Z"
}
```

### 4.2.4 查询医生未来 7 天排班

- 请求方法：`GET`
- 请求路径：`/api/schedules`
- 是否鉴权：是

查询参数：

- `doctorId`：医生 ID，必填

请求示例：

```http
GET /api/schedules?doctorId=101
```

成功响应示例：

```json
{
  "code": 200,
  "message": "请求成功",
  "data": [
    {
      "scheduleDate": "2026-05-14",
      "morning": {
        "id": 1001,
        "timeSlot": 1,
        "totalQuota": 20,
        "remainingQuota": 6,
        "status": 1
      },
      "afternoon": {
        "id": 1002,
        "timeSlot": 2,
        "totalQuota": 20,
        "remainingQuota": 0,
        "status": 2
      }
    },
    {
      "scheduleDate": "2026-05-15",
      "morning": null,
      "afternoon": {
        "id": 1003,
        "timeSlot": 2,
        "totalQuota": 15,
        "remainingQuota": 15,
        "status": 1
      }
    }
  ],
  "timestamp": "2026-05-14T12:30:45.123Z"
}
```

状态说明：

- `timeSlot`：`1-上午`，`2-下午`
- `status`：`1-可预约`，`2-已约满`，`3-停诊`

---

## 4.3 就诊人管理接口

### 4.3.1 新增就诊人

- 请求方法：`POST`
- 请求路径：`/api/family-member`
- 是否鉴权：是

请求体：

```json
{
  "name": "张三",
  "idCard": "110105199001011234",
  "phone": "13812345678",
  "relationship": 1,
  "isDefault": true
}
```

参数说明：

- `relationship`：与患者关系，`1-本人`，`2-配偶`，`3-子女`，`4-父母`，`5-其他`
- `isDefault`：是否默认就诊人，`true/false`

成功响应示例：

```json
{
  "code": 200,
  "message": "请求成功",
  "data": null,
  "timestamp": "2026-05-14T12:30:45.123Z"
}
```

说明：

- 后端会根据身份证号自动解析 `birthDate` 和 `gender`
- 如果当前新增的就诊人设为默认，则同一患者名下其他默认就诊人会被取消默认状态

### 4.3.2 获取就诊人列表

- 请求方法：`GET`
- 请求路径：`/api/family-member`
- 是否鉴权：是

成功响应示例：

```json
{
  "code": 200,
  "message": "请求成功",
  "data": [
    {
      "id": 1,
      "name": "张三",
      "idCard": "1101**********1234",
      "phone": "138****5678",
      "relationship": 1,
      "isDefault": true
    },
    {
      "id": 2,
      "name": "李四",
      "idCard": "3203**********5678",
      "phone": "139****1234",
      "relationship": 4,
      "isDefault": false
    }
  ],
  "timestamp": "2026-05-14T12:30:45.123Z"
}
```

说明：

- 列表接口会对身份证号和手机号进行脱敏

### 4.3.3 获取就诊人详情

- 请求方法：`GET`
- 请求路径：`/api/family-member/{id}`
- 是否鉴权：是

请求示例：

```http
GET /api/family-member/1
```

成功响应示例：

```json
{
  "code": 200,
  "message": "请求成功",
  "data": {
    "id": 1,
    "name": "张三",
    "idCard": "110105199001011234",
    "phone": "13812345678",
    "gender": 1,
    "birthDate": "1990-01-01",
    "relationship": 1,
    "isDefault": true
  },
  "timestamp": "2026-05-14T12:30:45.123Z"
}
```

状态说明：

- `gender`：`1-男`，`2-女`

### 4.3.4 修改就诊人

- 请求方法：`PUT`
- 请求路径：`/api/family-member/{id}`
- 是否鉴权：是

请求体：

```json
{
  "name": "张三",
  "idCard": "110105199001011234",
  "phone": "13812345679",
  "relationship": 1,
  "isDefault": false
}
```

成功响应示例：

```json
{
  "code": 200,
  "message": "请求成功",
  "data": null,
  "timestamp": "2026-05-14T12:30:45.123Z"
}
```

### 4.3.5 设置默认就诊人

- 请求方法：`PUT`
- 请求路径：`/api/family-member/{id}/default`
- 是否鉴权：是

请求示例：

```http
PUT /api/family-member/2/default
```

成功响应示例：

```json
{
  "code": 200,
  "message": "请求成功",
  "data": null,
  "timestamp": "2026-05-14T12:30:45.123Z"
}
```

### 4.3.6 删除就诊人

- 请求方法：`DELETE`
- 请求路径：`/api/family-member/{id}`
- 是否鉴权：是

请求示例：

```http
DELETE /api/family-member/2
```

成功响应示例：

```json
{
  "code": 200,
  "message": "请求成功",
  "data": null,
  "timestamp": "2026-05-14T12:30:45.123Z"
}
```

失败响应示例：

```json
{
  "code": 404,
  "message": "就诊人不存在",
  "data": null,
  "timestamp": "2026-05-14T12:30:45.123Z"
}
```

---

## 4.4 预约挂号接口

### 4.4.1 分页查询我的预约

- 请求方法：`GET`
- 请求路径：`/api/appointments`
- 是否鉴权：是

查询参数：

- `pageNum`：页码，选填，默认 `1`
- `pageSize`：每页条数，选填，默认 `10`

请求示例：

```http
GET /api/appointments?pageNum=1&pageSize=10
```

成功响应示例：

```json
{
  "code": 200,
  "message": "请求成功",
  "data": {
    "records": [
      {
        "id": 1,
        "appointmentNo": 319854236547,
        "memberId": 1,
        "memberName": "张三",
        "doctorId": 101,
        "doctorName": "张医生",
        "doctorTitle": "主任医师",
        "departmentId": 1,
        "departmentName": "内科",
        "scheduleId": 1001,
        "appointmentDate": "2026-05-15",
        "timeSlot": 1,
        "status": 1,
        "remark": "请按预约时段提前到院签到。",
        "createdAt": "2026-05-14T10:00:00",
        "canCancel": true
      }
    ],
    "total": 1,
    "size": 10,
    "current": 1,
    "pages": 1
  },
  "timestamp": "2026-05-14T12:30:45.123Z"
}
```

字段说明：

- `timeSlot`：`1-上午`，`2-下午`
- `status`：`1-待就诊`，`2-已取消`，`3-已完成`
- `canCancel`：是否允许取消，当前规则为预约后 30 分钟内可取消

### 4.4.2 提交预约

- 请求方法：`POST`
- 请求路径：`/api/appointments`
- 是否鉴权：是

请求体：

```json
{
  "scheduleId": 1001,
  "familyMemberId": 1
}
```

业务规则说明：

- 就诊人必须属于当前登录患者
- 排班必须存在
- 排班不能为停诊状态
- 排班必须有剩余号源
- 同一就诊人同一科室同一天只能预约一次

成功响应示例：

```json
{
  "code": 200,
  "message": "请求成功",
  "data": {
    "appointmentId": 1,
    "appointmentNo": 319854236547,
    "scheduleId": 1001,
    "familyMemberId": 1,
    "familyMemberName": "张三",
    "doctorId": 101,
    "departmentId": 1,
    "appointmentDate": "2026-05-15",
    "timeSlot": 1,
    "status": 1,
    "notices": [
      "请在就诊当日提前到院签到取号。",
      "请携带就诊人有效身份证件按时就诊。",
      "如需取消预约，请尽量提前操作。"
    ]
  },
  "timestamp": "2026-05-14T12:30:45.123Z"
}
```

失败响应示例 1：重复预约

```json
{
  "code": 409,
  "message": "同一就诊人同一科室同一天只能预约一次",
  "data": null,
  "timestamp": "2026-05-14T12:30:45.123Z"
}
```

失败响应示例 2：号源已满

```json
{
  "code": 422,
  "message": "当前号源已约满",
  "data": null,
  "timestamp": "2026-05-14T12:30:45.123Z"
}
```

失败响应示例 3：排班停诊

```json
{
  "code": 422,
  "message": "当前排班已停诊",
  "data": null,
  "timestamp": "2026-05-14T12:30:45.123Z"
}
```

### 4.4.3 取消预约

- 请求方法：`PUT`
- 请求路径：`/api/appointments/{id}/cancel`
- 是否鉴权：是

请求示例：

```http
PUT /api/appointments/1/cancel
```

业务规则说明：

- 只能取消当前登录用户自己的预约
- 只有状态为“待就诊”的预约才允许取消
- 当前实现限制为预约创建后 30 分钟内可取消
- 取消后会同步回补排班余号

成功响应示例：

```json
{
  "code": 200,
  "message": "请求成功",
  "data": null,
  "timestamp": "2026-05-14T12:30:45.123Z"
}
```

失败响应示例：

```json
{
  "code": 422,
  "message": "预约后30分钟内可取消，当前已不可取消",
  "data": null,
  "timestamp": "2026-05-14T12:30:45.123Z"
}
```

---

## 5. 状态码说明

### 5.1 通用状态码

| 状态码 | 含义 | 说明 |
| --- | --- | --- |
| `200` | 请求成功 | 请求处理成功 |
| `201` | 创建成功 | 当前项目中预留，暂未单独使用 |
| `400` | 请求参数错误或格式不正确 | 参数缺失、格式错误、校验失败 |
| `401` | 未授权访问 | 未登录、token 无效、token 过期、密码错误等 |
| `403` | 无权限访问 | 账号禁用、访问受限 |
| `404` | 请求资源不存在 | 医生不存在、就诊人不存在、预约记录不存在等 |
| `405` | 请求方法不被允许 | 请求方法错误 |
| `409` | 资源冲突 | 账号已存在、重复预约等 |
| `415` | 不支持的媒体类型 | Content-Type 不正确 |
| `422` | 请求无法处理 | 业务规则不满足，如号源已满、停诊、不可取消 |
| `429` | 请求过于频繁 | 当前项目中预留 |
| `500` | 服务器内部错误 | 服务异常或未捕获异常 |
| `503` | 服务不可用 | 当前项目中预留 |

### 5.2 项目中常见业务状态码与含义

| 状态码 | message 示例 | 说明 |
| --- | --- | --- |
| `401` | `用户未登录` | 缺少 token 或 Redis 校验失败 |
| `401` | `无效的token` | token 格式错误或验签失败 |
| `401` | `token已过期` | token 已过期 |
| `401` | `密码错误` | 登录密码不正确 |
| `403` | `账号被禁用` | 当前患者账号被禁用 |
| `404` | `账号不存在` | 登录账号不存在 |
| `404` | `医生不存在` | 医生 ID 无效或医生不可用 |
| `404` | `就诊人不存在` | 当前患者下未找到该就诊人 |
| `404` | `预约记录不存在` | 当前患者下未找到该预约 |
| `409` | `手机号已存在` | 手机号注册重复 |
| `409` | `邮箱已存在` | 邮箱注册重复 |
| `409` | `同一就诊人同一科室同一天只能预约一次` | 重复挂号限制 |
| `422` | `当前号源已约满` | 排班无剩余号源 |
| `422` | `当前排班已停诊` | 排班状态不可预约 |
| `422` | `当前预约状态不可取消` | 预约不是待就诊状态 |
| `422` | `预约后30分钟内可取消，当前已不可取消` | 超过取消时间窗口 |
| `500` | `服务器内部错误` | 非预期系统异常 |

---

## 6. 业务字段补充说明

### 6.1 关系字段 `relationship`

| 值 | 含义 |
| --- | --- |
| `1` | 本人 |
| `2` | 配偶 |
| `3` | 子女 |
| `4` | 父母 |
| `5` | 其他 |

### 6.2 性别字段 `gender`

| 值 | 含义 |
| --- | --- |
| `1` | 男 |
| `2` | 女 |

### 6.3 排班时段字段 `timeSlot`

| 值 | 含义 |
| --- | --- |
| `1` | 上午 |
| `2` | 下午 |

### 6.4 排班状态字段 `status`

排班接口中的 `status`：

| 值 | 含义 |
| --- | --- |
| `1` | 可预约 |
| `2` | 已约满 |
| `3` | 停诊 |

预约接口中的 `status`：

| 值 | 含义 |
| --- | --- |
| `1` | 待就诊 |
| `2` | 已取消 |
| `3` | 已完成 |

---

## 7. 联调建议

1. 注册或登录成功后，先保存返回的 token。
2. 后续请求统一在请求头中带上 `Authorization: Bearer <token>`。
3. 预约前建议先调用科室、医生、排班、就诊人接口拿到 `departmentId`、`doctorId`、`scheduleId`、`familyMemberId`。
4. 若接口返回 `400`，优先检查字段名、字段类型和参数格式。
5. 若接口返回 `401`，优先检查 token 是否缺失、是否过期、是否加了 `Bearer ` 前缀。
6. 若接口返回 `422`，说明不是技术错误，而是当前业务规则不允许继续操作。
