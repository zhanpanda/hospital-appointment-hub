
CREATE TABLE departments (
                             id INT PRIMARY KEY AUTO_INCREMENT COMMENT '科室ID',
                             name VARCHAR(50) NOT NULL UNIQUE COMMENT '科室名称（内科、外科、儿科等）',
                             sort_order INT DEFAULT 0 COMMENT '排序序号',
                             status TINYINT DEFAULT 1 COMMENT '状态：1-启用，0-停用',
                             created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                             updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT '科室表';


CREATE TABLE doctors (
                         id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '医生ID',
                         department_id INT NOT NULL COMMENT '所属科室ID',
                         name VARCHAR(50) NOT NULL COMMENT '医生姓名',
                         title VARCHAR(50) COMMENT '职称（主任医师/副主任医师/主治医师/住院医师）',
                         specialty TEXT COMMENT '专长描述',
                         introduction TEXT COMMENT '医生简介',
                         avatar VARCHAR(255) COMMENT '医生照片',
                         status TINYINT DEFAULT 1 COMMENT '状态：1-在岗，0-离职',
                         created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                         updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                         INDEX idx_department (department_id),
                         INDEX idx_name (name)
) COMMENT '医生表';

CREATE TABLE schedules (
                           id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '排班ID',
                           doctor_id BIGINT NOT NULL COMMENT '医生ID',
                           schedule_date DATE NOT NULL COMMENT '排班日期',
                           time_slot TINYINT NOT NULL COMMENT '时段：1-上午，2-下午',
                           total_quota INT NOT NULL DEFAULT 0 COMMENT '总号源数',
                           remaining_quota INT NOT NULL DEFAULT 0 COMMENT '剩余可预约数',
                           status TINYINT DEFAULT 1 COMMENT '状态：1-可预约，2-已约满，3-停诊',
                           created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                           updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                           UNIQUE KEY uk_doctor_date_period (doctor_id, schedule_date, time_slot),
                           INDEX idx_doctor_date (doctor_id, schedule_date),
                           INDEX idx_date (schedule_date)
) COMMENT '医生排班表（未来7天内）';


CREATE TABLE appointments (
                              id INT PRIMARY KEY AUTO_INCREMENT COMMENT '预约ID',
                              appointment_no VARCHAR(32) NOT NULL UNIQUE COMMENT '预约号（唯一标识，如 AP202401010001）',
                              patient_id INT NOT NULL COMMENT '患者ID（操作账号）',
                              member_id INT NOT NULL COMMENT '就诊人ID',
                              doctor_id INT NOT NULL COMMENT '医生ID',
                              schedule_id INT NOT NULL COMMENT '排班ID',
                              department_id INT NOT NULL COMMENT '科室ID（冗余，方便查询）',
                              appointment_date DATE NOT NULL COMMENT '预约日期',
                              time_slot TINYINT NOT NULL COMMENT '预约时段：1-上午，2-下午',
                              status TINYINT DEFAULT 1 COMMENT '状态：1-待就诊，2-已取消，3-已完成',
                              cancel_time DATETIME COMMENT '取消时间',
                              notification_sent TINYINT DEFAULT 0 COMMENT '是否已发送通知：0-未发送，1-已发送',
                              remark VARCHAR(500) COMMENT '备注/注意事项',
                              created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '预约创建时间',
                              updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                              INDEX idx_patient (patient_id),
                              INDEX idx_member (member_id),
                              INDEX idx_doctor_date (doctor_id, appointment_date),
                              INDEX idx_status (status),
                              INDEX idx_appointment_no (appointment_no),
                              UNIQUE KEY uk_member_dept_date (member_id, department_id, appointment_date)
) COMMENT '预约记录表（同一就诊人同一科室同一天只能预约一次）';