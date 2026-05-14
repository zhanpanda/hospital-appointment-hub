/*
 Navicat Premium Data Transfer

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 80034 (8.0.34)
 Source Host           : localhost:3306
 Source Schema         : hospital-appointment-hub

 Target Server Type    : MySQL
 Target Server Version : 80034 (8.0.34)
 File Encoding         : 65001

 Date: 14/05/2026 19:02:24
*/
CREATE DATABASE IF NOT EXISTS `hospital-appointment-hub`;
USE `hospital-appointment-hub`;
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for appointments
-- ----------------------------
DROP TABLE IF EXISTS `appointments`;
CREATE TABLE `appointments`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '预约ID',
  `appointment_no` bigint NOT NULL COMMENT '预约号（全局唯一，由Redis生成）',
  `patient_id` int NOT NULL COMMENT '患者ID（操作账号）',
  `member_id` int NOT NULL COMMENT '就诊人ID',
  `doctor_id` int NOT NULL COMMENT '医生ID',
  `schedule_id` int NOT NULL COMMENT '排班ID',
  `department_id` int NOT NULL COMMENT '科室ID（冗余，方便查询）',
  `appointment_date` date NOT NULL COMMENT '预约日期',
  `time_slot` tinyint NOT NULL COMMENT '预约时段：1-上午，2-下午',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态：1-待就诊，2-已取消，3-已完成',
  `cancel_time` datetime NULL DEFAULT NULL COMMENT '取消时间',
  `notification_sent` tinyint NULL DEFAULT 0 COMMENT '是否已发送通知：0-未发送，1-已发送',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注/注意事项',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '预约创建时间',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_member_dept_date`(`member_id` ASC, `department_id` ASC, `appointment_date` ASC) USING BTREE,
  UNIQUE INDEX `appointment_no`(`appointment_no` ASC) USING BTREE,
  INDEX `idx_patient`(`patient_id` ASC) USING BTREE,
  INDEX `idx_member`(`member_id` ASC) USING BTREE,
  INDEX `idx_doctor_date`(`doctor_id` ASC, `appointment_date` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_appointment_no`(`appointment_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '预约记录表（同一就诊人同一科室同一天只能预约一次）' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of appointments
-- ----------------------------
INSERT INTO `appointments` VALUES (8, 321035430847840264, 7, 10, 1, 443, 1, '2026-05-16', 1, 2, '2026-05-14 19:01:48', 0, '用户主动取消预约', '2026-05-14 19:01:26', '2026-05-14 19:01:26');
INSERT INTO `appointments` VALUES (9, 321035452322676745, 7, 10, 1, 350, 1, '2026-05-15', 2, 2, '2026-05-14 19:01:41', 0, '用户主动取消预约', '2026-05-14 19:01:32', '2026-05-14 19:01:32');

-- ----------------------------
-- Table structure for departments
-- ----------------------------
DROP TABLE IF EXISTS `departments`;
CREATE TABLE `departments`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '科室ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '科室名称（内科、外科、儿科等）',
  `sort_order` int NULL DEFAULT 0 COMMENT '排序序号',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态：1-启用，0-停用',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '科室表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of departments
-- ----------------------------
INSERT INTO `departments` VALUES (1, '内科', 1, 1, '2026-05-14 15:07:33', '2026-05-14 15:07:33');
INSERT INTO `departments` VALUES (2, '外科', 2, 1, '2026-05-14 15:07:33', '2026-05-14 15:07:33');
INSERT INTO `departments` VALUES (3, '儿科', 3, 1, '2026-05-14 15:07:33', '2026-05-14 15:07:33');
INSERT INTO `departments` VALUES (4, '妇产科', 4, 1, '2026-05-14 15:07:33', '2026-05-14 15:07:33');
INSERT INTO `departments` VALUES (5, '骨科', 5, 1, '2026-05-14 15:07:33', '2026-05-14 15:07:33');
INSERT INTO `departments` VALUES (6, '眼科', 6, 1, '2026-05-14 15:07:33', '2026-05-14 15:07:33');
INSERT INTO `departments` VALUES (7, '皮肤科', 7, 1, '2026-05-14 15:07:33', '2026-05-14 15:07:33');
INSERT INTO `departments` VALUES (8, '口腔科', 8, 1, '2026-05-14 15:07:33', '2026-05-14 15:07:33');
INSERT INTO `departments` VALUES (9, '耳鼻喉科', 9, 1, '2026-05-14 15:07:33', '2026-05-14 15:07:33');
INSERT INTO `departments` VALUES (10, '神经内科', 10, 1, '2026-05-14 15:07:33', '2026-05-14 15:07:33');
INSERT INTO `departments` VALUES (11, '泌尿外科', 11, 1, '2026-05-14 15:07:33', '2026-05-14 15:07:33');
INSERT INTO `departments` VALUES (12, '心血管内科', 12, 1, '2026-05-14 15:07:33', '2026-05-14 15:07:33');
INSERT INTO `departments` VALUES (13, '消化内科', 13, 1, '2026-05-14 15:07:33', '2026-05-14 15:07:33');
INSERT INTO `departments` VALUES (14, '呼吸内科', 14, 1, '2026-05-14 15:07:33', '2026-05-14 15:07:33');
INSERT INTO `departments` VALUES (15, '内分泌科', 15, 1, '2026-05-14 15:07:33', '2026-05-14 15:07:33');
INSERT INTO `departments` VALUES (16, '中医科', 16, 1, '2026-05-14 15:07:33', '2026-05-14 15:07:33');
INSERT INTO `departments` VALUES (17, '康复科', 17, 1, '2026-05-14 15:07:33', '2026-05-14 15:07:33');
INSERT INTO `departments` VALUES (18, '急诊科', 18, 1, '2026-05-14 15:07:33', '2026-05-14 15:07:33');
INSERT INTO `departments` VALUES (19, '麻醉科', 19, 1, '2026-05-14 15:07:33', '2026-05-14 15:07:33');
INSERT INTO `departments` VALUES (20, '放射科', 20, 1, '2026-05-14 15:07:33', '2026-05-14 15:07:33');

-- ----------------------------
-- Table structure for doctors
-- ----------------------------
DROP TABLE IF EXISTS `doctors`;
CREATE TABLE `doctors`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '医生ID',
  `department_id` int NOT NULL COMMENT '所属科室ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '医生姓名',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '职称（主任医师/副主任医师/主治医师/住院医师）',
  `specialty` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '专长描述',
  `introduction` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '医生简介',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态：1-在岗，0-离职',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_department`(`department_id` ASC) USING BTREE,
  INDEX `idx_name`(`name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 48 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '医生表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of doctors
-- ----------------------------
INSERT INTO `doctors` VALUES (1, 1, '张明远', '主任医师', '高血压、冠心病、心力衰竭、心律失常等心血管疾病诊治', '从事内科临床工作30余年，中华医学会心血管病分会委员，主持多项国家级科研项目，在冠心病介入治疗方面经验丰富，累计完成心脏介入手术超5000例。', 1, '2026-05-14 15:35:53', '2026-05-14 15:35:53');
INSERT INTO `doctors` VALUES (2, 1, '李晓华', '副主任医师', '糖尿病、甲状腺疾病、痛风、骨质疏松等内分泌代谢疾病', '医学博士，曾赴美国梅奥诊所进修，擅长内分泌代谢疾病的个体化治疗，发表SCI论文20余篇，主持省级课题3项。', 1, '2026-05-14 15:35:53', '2026-05-14 15:35:53');
INSERT INTO `doctors` VALUES (3, 1, '王建国', '主治医师', '慢性胃炎、消化性溃疡、功能性胃肠病、幽门螺杆菌感染', '毕业于北京大学医学部，从事内科工作12年，擅长胃肠镜操作及内镜下治疗，年完成胃肠镜检查超2000例。', 1, '2026-05-14 15:35:53', '2026-05-14 15:35:53');
INSERT INTO `doctors` VALUES (4, 2, '刘志强', '主任医师', '肝胆胰脾外科、腹腔镜微创手术、胃肠道肿瘤根治术', '外科主任，博士生导师，从事普外科工作28年，完成腹腔镜胆囊切除术超3000例，获省科技进步奖2项，在微创外科领域有深厚造诣。', 1, '2026-05-14 15:35:53', '2026-05-14 15:35:53');
INSERT INTO `doctors` VALUES (5, 2, '陈伟', '副主任医师', '甲状腺、乳腺疾病的外科治疗，甲状腺癌根治术', '中国医师协会外科分会委员，擅长甲状腺癌根治术和乳腺癌保乳手术，年手术量超500台，术后并发症率低于行业平均水平。', 1, '2026-05-14 15:35:53', '2026-05-14 15:35:53');
INSERT INTO `doctors` VALUES (6, 2, '赵峰', '主治医师', '腹股沟疝、切口疝修补术，下肢静脉曲张微创治疗', '医学硕士，熟练掌握各类疝修补术，率先开展日间疝手术，患者术后当天即可出院，深受好评。', 1, '2026-05-14 15:35:53', '2026-05-14 15:35:53');
INSERT INTO `doctors` VALUES (7, 3, '周丽娜', '主任医师', '儿童呼吸系统疾病、哮喘、过敏性鼻炎、反复呼吸道感染', '儿科主任，从事儿科临床25年，中华医学会儿科学分会呼吸学组委员，在儿童哮喘规范化管理方面经验丰富，建立儿童哮喘管理档案超3000份。', 1, '2026-05-14 15:35:53', '2026-05-14 15:35:53');
INSERT INTO `doctors` VALUES (8, 3, '孙婷婷', '主治医师', '小儿消化系统疾病、儿童营养指导、食物过敏', '医学硕士，擅长儿童腹泻、便秘、食物过敏等常见疾病的诊治，开设儿童营养门诊，深受患儿家长信赖，年门诊量超8000人次。', 1, '2026-05-14 15:35:53', '2026-05-14 15:35:53');
INSERT INTO `doctors` VALUES (9, 4, '吴美玲', '主任医师', '高危妊娠管理、妇科肿瘤诊治、腹腔镜子宫切除术', '妇产科主任，省医学会妇产科学分会副主任委员，在高危妊娠处理和妇科微创手术方面有深厚造诣，年完成复杂剖宫产手术超300例。', 1, '2026-05-14 15:35:53', '2026-05-14 15:35:53');
INSERT INTO `doctors` VALUES (10, 4, '郑雅琴', '副主任医师', '月经失调、不孕不育、更年期综合征、多囊卵巢综合征', '从事妇产科工作18年，曾在北京协和医院进修生殖内分泌，对不孕症的诊治有独到见解，帮助超千对夫妇成功受孕。', 1, '2026-05-14 15:35:53', '2026-05-14 15:35:53');
INSERT INTO `doctors` VALUES (11, 5, '冯刚', '主任医师', '脊柱外科、腰椎间盘突出症、颈椎病、脊柱侧弯矫正', '骨科主任，博士生导师，省骨科质量控制中心主任，率先开展椎间孔镜微创手术，手术创伤小、恢复快，年脊柱手术超600例。', 1, '2026-05-14 15:35:53', '2026-05-14 15:35:53');
INSERT INTO `doctors` VALUES (12, 5, '马骏', '副主任医师', '关节置换、运动损伤、关节镜手术、半月板修复', '曾赴德国学习关节置换技术，擅长膝关节和髋关节置换术，年关节置换手术超200例，术后患者满意度达98%。', 1, '2026-05-14 15:35:53', '2026-05-14 15:35:53');
INSERT INTO `doctors` VALUES (13, 6, '林雪', '主任医师', '白内障、青光眼、眼底病、黄斑病变诊治', '眼科主任，擅长白内障超声乳化手术和青光眼微创手术，累计完成白内障手术超万例，手术时间短、恢复快，患者口碑极佳。', 1, '2026-05-14 15:35:53', '2026-05-14 15:35:53');
INSERT INTO `doctors` VALUES (14, 6, '何峰', '主治医师', '近视防控、角膜塑形镜验配、小儿斜弱视、视功能训练', '眼视光学专业毕业，获国际角膜塑形学会认证，专注青少年近视防控工作10年，已为3000余名青少年建立近视防控档案。', 1, '2026-05-14 15:35:53', '2026-05-14 15:35:53');
INSERT INTO `doctors` VALUES (15, 7, '陈雅文', '主任医师', '银屑病、白癜风、湿疹、痤疮、过敏性皮肤病', '皮肤科主任，中华医学会皮肤性病学分会委员，从事皮肤科临床30年，在中西医结合治疗皮肤病方面有独特方法，疗效显著。', 1, '2026-05-14 15:35:53', '2026-05-14 15:35:53');
INSERT INTO `doctors` VALUES (16, 7, '黄磊', '副主任医师', '皮肤美容、激光祛斑、注射美容、疤痕修复', '擅长各种光电美容治疗，拥有M22、热玛吉、皮秒等多种设备操作认证，为求美者提供个性化皮肤管理方案。', 1, '2026-05-14 15:35:53', '2026-05-14 15:35:53');
INSERT INTO `doctors` VALUES (17, 8, '沈健', '主任医师', '种植牙、全口义齿修复、复杂阻生牙拔除', '口腔科主任，省口腔医学会副会长，率先开展即刻种植技术，累计完成种植牙手术超5000颗，成功率98.5%以上。', 1, '2026-05-14 15:35:53', '2026-05-14 15:35:53');
INSERT INTO `doctors` VALUES (18, 8, '杨柳', '副主任医师', '牙齿正畸、隐形矫正、儿童早期矫治', '隐适美认证医师，擅长青少年及成人牙齿正畸治疗，已完成正畸病例超2000例，注重美观与功能的统一。', 1, '2026-05-14 15:35:53', '2026-05-14 15:35:53');
INSERT INTO `doctors` VALUES (19, 9, '高翔', '主任医师', '鼻内镜手术、咽喉微创手术、中耳炎、耳鸣', '耳鼻喉科主任，擅长鼻内镜下鼻窦手术和声带息肉切除术，年完成鼻内镜手术超400例，术后复发率低。', 1, '2026-05-14 15:35:53', '2026-05-14 15:35:53');
INSERT INTO `doctors` VALUES (20, 9, '许慧', '主治医师', '过敏性鼻炎、儿童腺样体肥大、听力障碍', '在过敏性鼻炎的免疫治疗方面有深入研究，擅长儿童腺样体肥大的保守治疗和手术评估，态度温和，深受患儿喜爱。', 1, '2026-05-14 15:35:53', '2026-05-14 15:35:53');
INSERT INTO `doctors` VALUES (21, 10, '唐志宏', '主任医师', '脑卒中、帕金森病、癫痫、头痛眩晕', '神经内科主任，博士生导师，省卒中学会会长，建立卒中绿色通道，急性脑梗死溶栓治疗时间缩短至30分钟以内。', 1, '2026-05-14 15:35:53', '2026-05-14 15:35:53');
INSERT INTO `doctors` VALUES (22, 10, '蒋丽', '副主任医师', '失眠、焦虑抑郁、老年痴呆、神经系统退行性疾病', '医学博士，中国睡眠研究会会员，开设睡眠障碍专病门诊，采用药物联合认知行为治疗，改善患者睡眠质量。', 1, '2026-05-14 15:35:53', '2026-05-14 15:35:53');
INSERT INTO `doctors` VALUES (23, 11, '韩强', '主任医师', '前列腺增生微创手术、泌尿系结石、泌尿系统肿瘤', '泌尿外科主任，擅长经尿道前列腺电切术和输尿管软镜碎石术，年手术量超800例，微创手术占比90%以上。', 1, '2026-05-14 15:35:53', '2026-05-14 15:35:53');
INSERT INTO `doctors` VALUES (24, 11, '孟涛', '主治医师', '男性不育、性功能障碍、精索静脉曲张', '医学硕士，专注于男性生殖健康领域，采用中西医结合方法治疗男性不育症，已帮助数百对夫妇圆了生育梦。', 1, '2026-05-14 15:35:53', '2026-05-14 15:35:53');
INSERT INTO `doctors` VALUES (25, 12, '秦志远', '主任医师', '冠心病介入治疗、起搏器植入、心力衰竭综合管理', '心血管内科主任，博士生导师，省心血管病学会主任委员，年完成冠脉介入手术超1000例，是国内最早开展TAVI手术的专家之一。', 1, '2026-05-14 15:35:53', '2026-05-14 15:35:53');
INSERT INTO `doctors` VALUES (26, 12, '魏芳', '副主任医师', '高血压精准治疗、血脂异常、心肌病', '从事心血管内科工作15年，在难治性高血压诊治方面经验丰富，参与编写《中国高血压防治指南》。', 1, '2026-05-14 15:35:53', '2026-05-14 15:35:53');
INSERT INTO `doctors` VALUES (27, 13, '沈宏', '主任医师', '早期胃癌筛查、ERCP、肝硬化食管静脉曲张治疗', '消化内科主任，擅长内镜下黏膜剥离术（ESD）和内镜逆行胰胆管造影（ERCP），年完成四级内镜手术超300例。', 1, '2026-05-14 15:35:53', '2026-05-14 15:35:53');
INSERT INTO `doctors` VALUES (28, 13, '丁敏', '主治医师', '炎症性肠病、肠易激综合征、慢性便秘', '医学博士，在克罗恩病和溃疡性结肠炎的生物制剂治疗方面有丰富经验，开设IBD专病门诊。', 1, '2026-05-14 15:35:53', '2026-05-14 15:35:53');
INSERT INTO `doctors` VALUES (29, 14, '苏建国', '主任医师', '慢性阻塞性肺疾病、哮喘、肺结节、肺癌早期诊断', '呼吸内科主任，省呼吸病学会副主任委员，擅长支气管镜检查和肺结节穿刺活检，新冠疫情期间担任专家组组长。', 1, '2026-05-14 15:35:53', '2026-05-14 15:35:53');
INSERT INTO `doctors` VALUES (30, 14, '袁洁', '主治医师', '慢性咳嗽、过敏性鼻炎合并哮喘、睡眠呼吸暂停综合征', '医学硕士，在慢性咳嗽的病因诊断和治疗方面有独到经验，开展睡眠呼吸监测，帮助患者改善睡眠质量。', 1, '2026-05-14 15:35:53', '2026-05-14 15:35:53');
INSERT INTO `doctors` VALUES (31, 15, '钱明华', '主任医师', '糖尿病综合管理、甲状腺结节、垂体肾上腺疾病', '内分泌科主任，省内分泌学会副主任委员，建立糖尿病全程管理平台，管理糖尿病患者超万人，血糖达标率行业领先。', 1, '2026-05-14 15:35:53', '2026-05-14 15:35:53');
INSERT INTO `doctors` VALUES (32, 15, '梅琳', '副主任医师', '妊娠期糖尿病、儿童生长发育、性早熟', '医学博士，在妊娠期糖尿病的血糖管理方面经验丰富，开设生长发育门诊，帮助众多矮小症儿童实现追赶生长。', 1, '2026-05-14 15:35:53', '2026-05-14 15:35:53');
INSERT INTO `doctors` VALUES (33, 16, '卢国栋', '主任医师', '中医调理亚健康、脾胃病、失眠、月经不调', '中医科主任，全国名老中医学术继承人，从事中医临床40年，善用经方治疗疑难杂症，深受患者信赖。', 1, '2026-05-14 15:35:53', '2026-05-14 15:35:53');
INSERT INTO `doctors` VALUES (34, 16, '白静', '副主任医师', '针灸推拿、颈椎病、腰椎病、面瘫', '擅长针灸配合推拿治疗各类疼痛性疾病，独创\"通络温针灸\"疗法，对面瘫和颈椎病的治疗有独特疗效。', 1, '2026-05-14 15:35:53', '2026-05-14 15:35:53');
INSERT INTO `doctors` VALUES (35, 17, '石磊', '主任医师', '脑卒中后康复、骨折术后康复、运动损伤康复', '康复科主任，省康复医学会副会长，带领团队建立\"早期介入-系统评估-个体化方案\"的康复模式，患者功能恢复率显著提高。', 1, '2026-05-14 15:35:53', '2026-05-14 15:35:53');
INSERT INTO `doctors` VALUES (36, 17, '范雪', '主治医师', '脊柱侧弯康复、产后康复、儿童发育迟缓康复', '擅长运用物理治疗和作业治疗相结合的方法，为患者制定个性化康复方案，在产后盆底肌康复方面经验丰富。', 1, '2026-05-14 15:35:53', '2026-05-14 15:35:53');
INSERT INTO `doctors` VALUES (37, 18, '武军', '主任医师', '急危重症抢救、心肺复苏、中毒急救、创伤急救', '急诊科主任，从事急诊工作25年，参与制定多项急诊抢救流程，在群体性中毒事件和重大创伤抢救中表现出色。', 1, '2026-05-14 15:35:53', '2026-05-14 15:35:53');
INSERT INTO `doctors` VALUES (38, 18, '姚莉', '主治医师', '急性胸痛鉴别、急性腹痛诊治、发热待查', '医学硕士，在急诊一线工作10年，对急腹症的快速诊断和急性胸痛的危险分层有丰富经验，反应迅速，处理果断。', 1, '2026-05-14 15:35:53', '2026-05-14 15:35:53');
INSERT INTO `doctors` VALUES (39, 19, '耿涛', '主任医师', '老年患者麻醉、小儿麻醉、无痛分娩、困难气道处理', '麻醉科主任，省麻醉学会常委，擅长高龄危重患者的围术期麻醉管理，保障超过80岁高龄患者手术麻醉安全超千例。', 1, '2026-05-14 15:35:53', '2026-05-14 15:35:53');
INSERT INTO `doctors` VALUES (40, 19, '宁静', '副主任医师', '术后镇痛管理、癌痛治疗、慢性疼痛介入治疗', '在术后多模式镇痛和癌痛规范化治疗方面有深入研究，让患者在围术期享受到更舒适的治疗体验。', 1, '2026-05-14 15:35:53', '2026-05-14 15:35:53');
INSERT INTO `doctors` VALUES (41, 20, '崔志华', '主任医师', 'CT/MRI影像诊断、肺结节分析、肿瘤影像分期', '放射科主任，省放射学会副主任委员，在早期肺癌低剂量CT筛查和肿瘤影像分期方面经验丰富，年审阅影像报告超万份。', 1, '2026-05-14 15:35:53', '2026-05-14 15:35:53');
INSERT INTO `doctors` VALUES (42, 20, '廖芳', '副主任医师', '介入放射治疗、血管造影、肿瘤栓塞化疗', '擅长肝癌介入治疗和子宫肌瘤栓塞术，年完成介入手术超300例，以微创方式为患者提供精准治疗。', 1, '2026-05-14 15:35:53', '2026-05-14 15:35:53');
INSERT INTO `doctors` VALUES (43, 1, '陈志华', '主任医师', '呼吸系统疾病、慢性阻塞性肺疾病、支气管哮喘、肺部感染', '呼吸内科学科带头人，从事呼吸内科临床工作35年，省呼吸病学会常委，在慢性阻塞性肺疾病的规范化治疗方面经验丰富，主持国家自然科学基金项目2项。', 1, '2026-05-14 15:57:03', '2026-05-14 15:57:03');
INSERT INTO `doctors` VALUES (44, 1, '林小红', '副主任医师', '慢性肾病、肾功能衰竭、血液透析、腹膜透析', '医学博士，曾赴日本东京大学医学部研修，擅长慢性肾脏病的一体化治疗，在延缓肾功能恶化方面有独到经验，管理透析患者超500人。', 1, '2026-05-14 15:57:03', '2026-05-14 15:57:03');
INSERT INTO `doctors` VALUES (45, 1, '黄文斌', '主治医师', '类风湿关节炎、系统性红斑狼疮、强直性脊柱炎、痛风', '风湿免疫专业硕士，擅长生物制剂治疗风湿免疫性疾病，对难治性类风湿关节炎的个体化治疗有深入研究，患者随访依从率高。', 1, '2026-05-14 15:57:03', '2026-05-14 15:57:03');
INSERT INTO `doctors` VALUES (46, 1, '杨柳青', '副主任医师', '贫血、白血病、淋巴瘤、血小板减少性紫癜', '血液病学博士，省血液学会委员，在急性白血病的规范化疗和靶向治疗方面经验丰富，主持省级课题2项，发表核心期刊论文15篇。', 1, '2026-05-14 15:57:03', '2026-05-14 15:57:03');
INSERT INTO `doctors` VALUES (47, 1, '马晓东', '主治医师', '病毒性肝炎、肝硬化、脂肪肝、自身免疫性肝病', '毕业于复旦大学医学院，从事肝病临床工作10年，擅长慢性乙型肝炎的抗病毒治疗和肝硬化并发症的处理，年门诊量超6000人次。', 1, '2026-05-14 15:57:03', '2026-05-14 15:57:03');

-- ----------------------------
-- Table structure for family_members
-- ----------------------------
DROP TABLE IF EXISTS `family_members`;
CREATE TABLE `family_members`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '就诊人ID',
  `patient_id` int NOT NULL COMMENT '所属患者ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '就诊人姓名',
  `id_card` varchar(18) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '身份证号',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '手机号',
  `gender` tinyint NULL DEFAULT NULL COMMENT '性别：1-男，2-女',
  `birth_date` date NULL DEFAULT NULL COMMENT '出生日期',
  `relationship` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '与患者关系：本人/配偶/子女/父母/其他',
  `is_default` tinyint NULL DEFAULT 0 COMMENT '是否默认就诊人：1-是，0-否',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_patient_card`(`patient_id` ASC, `id_card` ASC) USING BTREE,
  INDEX `idx_patient`(`patient_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '就诊人表（一个患者可添加多个就诊人）' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of family_members
-- ----------------------------
INSERT INTO `family_members` VALUES (9, 7, '张三', '320106199205056789', '13800138000', 2, '1992-05-05', '3', 0, '2026-05-14 18:49:02', '2026-05-14 18:50:14');
INSERT INTO `family_members` VALUES (10, 7, '李四', '110105199001011234', '13800138000', 1, '1990-01-01', '1', 1, '2026-05-14 18:50:15', '2026-05-14 18:50:15');

-- ----------------------------
-- Table structure for patients
-- ----------------------------
DROP TABLE IF EXISTS `patients`;
CREATE TABLE `patients`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '患者ID',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '手机号（手机号或邮箱二选一必填）',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '邮箱',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '加密后的密码',
  `status` tinyint NULL DEFAULT 1 COMMENT '账号状态：1-正常，0-禁用',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `phone`(`phone` ASC) USING BTREE,
  UNIQUE INDEX `email`(`email` ASC) USING BTREE,
  INDEX `idx_phone`(`phone` ASC) USING BTREE,
  INDEX `idx_email`(`email` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '患者用户表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of patients
-- ----------------------------
INSERT INTO `patients` VALUES (7, '18378393456', NULL, '$2a$10$BttjvejuhWCXHSE5m9am2OMDBxiYNe2k9zjkFTP4yrZraLuisLl8K', 1, '2026-05-14 18:46:46', '2026-05-14 18:46:46');

-- ----------------------------
-- Table structure for schedules
-- ----------------------------
DROP TABLE IF EXISTS `schedules`;
CREATE TABLE `schedules`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '排班ID',
  `doctor_id` bigint NOT NULL COMMENT '医生ID',
  `schedule_date` date NOT NULL COMMENT '排班日期',
  `time_slot` tinyint NOT NULL COMMENT '时段：1-上午，2-下午',
  `total_quota` int NOT NULL DEFAULT 0 COMMENT '总号源数',
  `remaining_quota` int NOT NULL DEFAULT 0 COMMENT '剩余可预约数',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态：1-可预约，2-已约满，3-停诊',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_doctor_date_period`(`doctor_id` ASC, `schedule_date` ASC, `time_slot` ASC) USING BTREE,
  INDEX `idx_doctor_date`(`doctor_id` ASC, `schedule_date` ASC) USING BTREE,
  INDEX `idx_date`(`schedule_date` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 698 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '医生排班表（未来7天内）' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of schedules
-- ----------------------------
INSERT INTO `schedules` VALUES (349, 1, '2026-05-15', 1, 30, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (350, 1, '2026-05-15', 2, 30, 30, 1, '2026-05-14 19:00:34', '2026-05-14 19:01:31');
INSERT INTO `schedules` VALUES (351, 2, '2026-05-15', 1, 25, 8, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (352, 2, '2026-05-15', 2, 25, 25, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (353, 3, '2026-05-15', 1, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (354, 3, '2026-05-15', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (355, 4, '2026-05-15', 1, 30, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (356, 4, '2026-05-15', 2, 30, 30, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (357, 5, '2026-05-15', 1, 25, 25, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (358, 5, '2026-05-15', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (359, 6, '2026-05-15', 1, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (360, 6, '2026-05-15', 2, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (361, 7, '2026-05-15', 1, 25, 5, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (362, 7, '2026-05-15', 2, 25, 25, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (363, 8, '2026-05-15', 1, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (364, 8, '2026-05-15', 2, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (365, 9, '2026-05-15', 1, 25, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (366, 9, '2026-05-15', 2, 25, 25, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (367, 10, '2026-05-15', 1, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (368, 10, '2026-05-15', 2, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (369, 11, '2026-05-15', 1, 30, 30, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (370, 11, '2026-05-15', 2, 30, 30, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (371, 12, '2026-05-15', 1, 25, 25, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (372, 12, '2026-05-15', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (373, 13, '2026-05-15', 1, 30, 18, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (374, 13, '2026-05-15', 2, 30, 30, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (375, 14, '2026-05-15', 1, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (376, 14, '2026-05-15', 2, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (377, 15, '2026-05-15', 1, 25, 25, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (378, 15, '2026-05-15', 2, 25, 25, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (379, 16, '2026-05-15', 1, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (380, 16, '2026-05-15', 2, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (381, 17, '2026-05-15', 1, 15, 8, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (382, 17, '2026-05-15', 2, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (383, 18, '2026-05-15', 1, 10, 10, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (384, 18, '2026-05-15', 2, 10, 10, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (385, 19, '2026-05-15', 1, 25, 25, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (386, 19, '2026-05-15', 2, 25, 25, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (387, 20, '2026-05-15', 1, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (388, 20, '2026-05-15', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (389, 21, '2026-05-15', 1, 25, 12, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (390, 21, '2026-05-15', 2, 25, 25, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (391, 22, '2026-05-15', 1, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (392, 22, '2026-05-15', 2, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (393, 23, '2026-05-15', 1, 25, 25, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (394, 23, '2026-05-15', 2, 25, 25, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (395, 24, '2026-05-15', 1, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (396, 24, '2026-05-15', 2, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (397, 25, '2026-05-15', 1, 30, 8, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (398, 25, '2026-05-15', 2, 30, 30, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (399, 26, '2026-05-15', 1, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (400, 26, '2026-05-15', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (401, 27, '2026-05-15', 1, 25, 25, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (402, 27, '2026-05-15', 2, 25, 25, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (403, 28, '2026-05-15', 1, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (404, 28, '2026-05-15', 2, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (405, 29, '2026-05-15', 1, 30, 18, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (406, 29, '2026-05-15', 2, 30, 30, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (407, 30, '2026-05-15', 1, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (408, 30, '2026-05-15', 2, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (409, 31, '2026-05-15', 1, 25, 25, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (410, 31, '2026-05-15', 2, 25, 25, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (411, 32, '2026-05-15', 1, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (412, 32, '2026-05-15', 2, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (413, 33, '2026-05-15', 1, 30, 0, 2, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (414, 33, '2026-05-15', 2, 30, 30, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (415, 34, '2026-05-15', 1, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (416, 34, '2026-05-15', 2, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (417, 35, '2026-05-15', 1, 20, 12, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (418, 35, '2026-05-15', 2, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (419, 36, '2026-05-15', 1, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (420, 36, '2026-05-15', 2, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (421, 37, '2026-05-15', 1, 40, 28, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (422, 37, '2026-05-15', 2, 40, 40, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (423, 38, '2026-05-15', 1, 30, 30, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (424, 38, '2026-05-15', 2, 30, 30, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (425, 39, '2026-05-15', 1, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (426, 39, '2026-05-15', 2, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (427, 40, '2026-05-15', 1, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (428, 40, '2026-05-15', 2, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (429, 41, '2026-05-15', 1, 25, 25, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (430, 41, '2026-05-15', 2, 25, 25, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (431, 42, '2026-05-15', 1, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (432, 42, '2026-05-15', 2, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (433, 43, '2026-05-15', 1, 25, 25, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (434, 43, '2026-05-15', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (435, 44, '2026-05-15', 1, 20, 12, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (436, 44, '2026-05-15', 2, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (437, 45, '2026-05-15', 1, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (438, 45, '2026-05-15', 2, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (439, 46, '2026-05-15', 1, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (440, 46, '2026-05-15', 2, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (441, 47, '2026-05-15', 1, 20, 0, 2, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (442, 47, '2026-05-15', 2, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (443, 1, '2026-05-16', 1, 20, 6, 1, '2026-05-14 19:00:34', '2026-05-14 19:01:26');
INSERT INTO `schedules` VALUES (444, 1, '2026-05-16', 2, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (445, 2, '2026-05-16', 1, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (446, 2, '2026-05-16', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (447, 3, '2026-05-16', 1, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (448, 3, '2026-05-16', 2, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (449, 4, '2026-05-16', 1, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (450, 4, '2026-05-16', 2, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (451, 5, '2026-05-16', 1, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (452, 5, '2026-05-16', 2, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (453, 6, '2026-05-16', 1, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (454, 6, '2026-05-16', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (455, 7, '2026-05-16', 1, 20, 12, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (456, 7, '2026-05-16', 2, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (457, 8, '2026-05-16', 1, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (458, 8, '2026-05-16', 2, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (459, 9, '2026-05-16', 1, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (460, 9, '2026-05-16', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (461, 10, '2026-05-16', 1, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (462, 10, '2026-05-16', 2, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (463, 11, '2026-05-16', 1, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (464, 11, '2026-05-16', 2, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (465, 12, '2026-05-16', 1, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (466, 12, '2026-05-16', 2, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (467, 13, '2026-05-16', 1, 20, 8, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (468, 13, '2026-05-16', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (469, 14, '2026-05-16', 1, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (470, 14, '2026-05-16', 2, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (471, 15, '2026-05-16', 1, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (472, 15, '2026-05-16', 2, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (473, 16, '2026-05-16', 1, 10, 10, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (474, 16, '2026-05-16', 2, 10, 10, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (475, 17, '2026-05-16', 1, 10, 4, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (476, 17, '2026-05-16', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (477, 18, '2026-05-16', 1, 10, 10, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (478, 18, '2026-05-16', 2, 10, 10, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (479, 19, '2026-05-16', 1, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (480, 19, '2026-05-16', 2, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (481, 20, '2026-05-16', 1, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (482, 20, '2026-05-16', 2, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (483, 21, '2026-05-16', 1, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (484, 21, '2026-05-16', 2, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (485, 22, '2026-05-16', 1, 10, 10, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (486, 22, '2026-05-16', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (487, 23, '2026-05-16', 1, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (488, 23, '2026-05-16', 2, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (489, 24, '2026-05-16', 1, 10, 10, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (490, 24, '2026-05-16', 2, 10, 10, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (491, 25, '2026-05-16', 1, 20, 10, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (492, 25, '2026-05-16', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (493, 26, '2026-05-16', 1, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (494, 26, '2026-05-16', 2, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (495, 27, '2026-05-16', 1, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (496, 27, '2026-05-16', 2, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (497, 28, '2026-05-16', 1, 10, 10, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (498, 28, '2026-05-16', 2, 10, 10, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (499, 29, '2026-05-16', 1, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (500, 29, '2026-05-16', 2, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (501, 30, '2026-05-16', 1, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (502, 30, '2026-05-16', 2, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (503, 31, '2026-05-16', 1, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (504, 31, '2026-05-16', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (505, 32, '2026-05-16', 1, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (506, 32, '2026-05-16', 2, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (507, 33, '2026-05-16', 1, 20, 0, 2, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (508, 33, '2026-05-16', 2, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (509, 34, '2026-05-16', 1, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (510, 34, '2026-05-16', 2, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (511, 35, '2026-05-16', 1, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (512, 35, '2026-05-16', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (513, 36, '2026-05-16', 1, 10, 10, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (514, 36, '2026-05-16', 2, 10, 10, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (515, 37, '2026-05-16', 1, 40, 32, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (516, 37, '2026-05-16', 2, 40, 40, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (517, 38, '2026-05-16', 1, 30, 30, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (518, 38, '2026-05-16', 2, 30, 30, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (519, 39, '2026-05-16', 1, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (520, 39, '2026-05-16', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (521, 40, '2026-05-16', 1, 10, 10, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (522, 40, '2026-05-16', 2, 10, 10, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (523, 41, '2026-05-16', 1, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (524, 41, '2026-05-16', 2, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (525, 42, '2026-05-16', 1, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (526, 42, '2026-05-16', 2, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (527, 43, '2026-05-16', 1, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (528, 43, '2026-05-16', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (529, 44, '2026-05-16', 1, 10, 10, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (530, 44, '2026-05-16', 2, 10, 10, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (531, 45, '2026-05-16', 1, 10, 10, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (532, 45, '2026-05-16', 2, 10, 10, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (533, 46, '2026-05-16', 1, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (534, 46, '2026-05-16', 2, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (535, 47, '2026-05-16', 1, 15, 0, 2, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (536, 47, '2026-05-16', 2, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (537, 1, '2026-05-17', 1, 10, 6, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (538, 1, '2026-05-17', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (539, 2, '2026-05-17', 1, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (540, 2, '2026-05-17', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (541, 3, '2026-05-17', 1, 10, 10, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (542, 3, '2026-05-17', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (543, 4, '2026-05-17', 1, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (544, 4, '2026-05-17', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (545, 5, '2026-05-17', 1, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (546, 5, '2026-05-17', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (547, 6, '2026-05-17', 1, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (548, 6, '2026-05-17', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (549, 7, '2026-05-17', 1, 15, 4, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (550, 7, '2026-05-17', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (551, 8, '2026-05-17', 1, 10, 10, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (552, 8, '2026-05-17', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (553, 9, '2026-05-17', 1, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (554, 9, '2026-05-17', 2, 10, 10, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (555, 10, '2026-05-17', 1, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (556, 10, '2026-05-17', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (557, 11, '2026-05-17', 1, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (558, 11, '2026-05-17', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (559, 12, '2026-05-17', 1, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (560, 12, '2026-05-17', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (561, 13, '2026-05-17', 1, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (562, 13, '2026-05-17', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (563, 14, '2026-05-17', 1, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (564, 14, '2026-05-17', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (565, 15, '2026-05-17', 1, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (566, 15, '2026-05-17', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (567, 16, '2026-05-17', 1, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (568, 16, '2026-05-17', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (569, 17, '2026-05-17', 1, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (570, 17, '2026-05-17', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (571, 18, '2026-05-17', 1, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (572, 18, '2026-05-17', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (573, 19, '2026-05-17', 1, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (574, 19, '2026-05-17', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (575, 20, '2026-05-17', 1, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (576, 20, '2026-05-17', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (577, 21, '2026-05-17', 1, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (578, 21, '2026-05-17', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (579, 22, '2026-05-17', 1, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (580, 22, '2026-05-17', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (581, 23, '2026-05-17', 1, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (582, 23, '2026-05-17', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (583, 24, '2026-05-17', 1, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (584, 24, '2026-05-17', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (585, 25, '2026-05-17', 1, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (586, 25, '2026-05-17', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (587, 26, '2026-05-17', 1, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (588, 26, '2026-05-17', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (589, 27, '2026-05-17', 1, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (590, 27, '2026-05-17', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (591, 28, '2026-05-17', 1, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (592, 28, '2026-05-17', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (593, 29, '2026-05-17', 1, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (594, 29, '2026-05-17', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (595, 30, '2026-05-17', 1, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (596, 30, '2026-05-17', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (597, 31, '2026-05-17', 1, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (598, 31, '2026-05-17', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (599, 32, '2026-05-17', 1, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (600, 32, '2026-05-17', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (601, 33, '2026-05-17', 1, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (602, 33, '2026-05-17', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (603, 34, '2026-05-17', 1, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (604, 34, '2026-05-17', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (605, 35, '2026-05-17', 1, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (606, 35, '2026-05-17', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (607, 36, '2026-05-17', 1, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (608, 36, '2026-05-17', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (609, 37, '2026-05-17', 1, 50, 38, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (610, 37, '2026-05-17', 2, 50, 42, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (611, 38, '2026-05-17', 1, 40, 32, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (612, 38, '2026-05-17', 2, 40, 40, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (613, 39, '2026-05-17', 1, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (614, 39, '2026-05-17', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (615, 40, '2026-05-17', 1, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (616, 40, '2026-05-17', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (617, 41, '2026-05-17', 1, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (618, 41, '2026-05-17', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (619, 42, '2026-05-17', 1, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (620, 42, '2026-05-17', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (621, 43, '2026-05-17', 1, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (622, 43, '2026-05-17', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (623, 44, '2026-05-17', 1, 10, 10, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (624, 44, '2026-05-17', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (625, 45, '2026-05-17', 1, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (626, 45, '2026-05-17', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (627, 46, '2026-05-17', 1, 10, 10, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (628, 46, '2026-05-17', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (629, 47, '2026-05-17', 1, 10, 0, 2, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (630, 47, '2026-05-17', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (631, 1, '2026-05-18', 1, 30, 10, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (632, 1, '2026-05-18', 2, 30, 30, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (633, 2, '2026-05-18', 1, 25, 25, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (634, 2, '2026-05-18', 2, 25, 0, 2, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (635, 3, '2026-05-18', 1, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (636, 3, '2026-05-18', 2, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (637, 4, '2026-05-18', 1, 30, 18, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (638, 4, '2026-05-18', 2, 30, 30, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (639, 5, '2026-05-18', 1, 25, 25, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (640, 5, '2026-05-18', 2, 25, 25, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (641, 6, '2026-05-18', 1, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (642, 6, '2026-05-18', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (643, 7, '2026-05-18', 1, 30, 22, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (644, 7, '2026-05-18', 2, 30, 30, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (645, 8, '2026-05-18', 1, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (646, 8, '2026-05-18', 2, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (647, 9, '2026-05-18', 1, 25, 12, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (648, 9, '2026-05-18', 2, 25, 25, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (649, 10, '2026-05-18', 1, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (650, 10, '2026-05-18', 2, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (651, 11, '2026-05-18', 1, 30, 30, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (652, 11, '2026-05-18', 2, 30, 30, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (653, 12, '2026-05-18', 1, 25, 25, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (654, 12, '2026-05-18', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (655, 13, '2026-05-18', 1, 30, 16, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (656, 13, '2026-05-18', 2, 30, 30, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (657, 14, '2026-05-18', 1, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (658, 14, '2026-05-18', 2, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (659, 15, '2026-05-18', 1, 25, 25, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (660, 15, '2026-05-18', 2, 25, 25, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (661, 16, '2026-05-18', 1, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (662, 16, '2026-05-18', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (663, 17, '2026-05-18', 1, 15, 5, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (664, 17, '2026-05-18', 2, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (665, 18, '2026-05-18', 1, 10, 10, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (666, 18, '2026-05-18', 2, 10, 10, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (667, 19, '2026-05-18', 1, 25, 25, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (668, 19, '2026-05-18', 2, 25, 25, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (669, 20, '2026-05-18', 1, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (670, 20, '2026-05-18', 2, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (671, 21, '2026-05-18', 1, 25, 8, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (672, 21, '2026-05-18', 2, 25, 25, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (673, 22, '2026-05-18', 1, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (674, 22, '2026-05-18', 2, 0, 0, 3, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (675, 23, '2026-05-18', 1, 25, 25, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (676, 23, '2026-05-18', 2, 25, 25, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (677, 24, '2026-05-18', 1, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (678, 24, '2026-05-18', 2, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (679, 25, '2026-05-18', 1, 30, 14, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (680, 25, '2026-05-18', 2, 30, 30, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (681, 26, '2026-05-18', 1, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (682, 26, '2026-05-18', 2, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (683, 27, '2026-05-18', 1, 25, 25, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (684, 27, '2026-05-18', 2, 25, 25, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (685, 28, '2026-05-18', 1, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (686, 28, '2026-05-18', 2, 15, 15, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (687, 29, '2026-05-18', 1, 30, 22, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (688, 29, '2026-05-18', 2, 30, 30, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (689, 30, '2026-05-18', 1, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (690, 30, '2026-05-18', 2, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (691, 31, '2026-05-18', 1, 25, 25, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (692, 31, '2026-05-18', 2, 25, 25, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (693, 32, '2026-05-18', 1, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (694, 32, '2026-05-18', 2, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (695, 33, '2026-05-18', 1, 30, 4, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (696, 33, '2026-05-18', 2, 30, 30, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');
INSERT INTO `schedules` VALUES (697, 34, '2026-05-18', 1, 20, 20, 1, '2026-05-14 19:00:34', '2026-05-14 19:00:34');

SET FOREIGN_KEY_CHECKS = 1;
