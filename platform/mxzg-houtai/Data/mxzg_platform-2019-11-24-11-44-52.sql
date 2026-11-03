/*
Navicat MySQL Data Transfer

Source Server         : data
Source Server Version : 50643
Source Host           : 182.254.197.214:3306
Source Database       : mxzg_platform

Target Server Type    : MYSQL
Target Server Version : 50643
File Encoding         : 65001

Date: 2019-11-12 21:30:00
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `bms_active`
-- ----------------------------
DROP TABLE IF EXISTS `bms_active`;
CREATE TABLE `bms_active` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '活动ID',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '活动名称',
  `type_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '活动类型id',
  `start_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '开始时间',
  `end_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '结束时间',
  `clear_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '清除时间',
  `limit_days` tinyint(3) NOT NULL DEFAULT '0' COMMENT '开服第N天开启',
  `desc` text COMMENT '活动描述',
  `data_file` varchar(255) NOT NULL DEFAULT '' COMMENT '活动数据文件名',
  `server_ids` varchar(255) NOT NULL DEFAULT '' COMMENT '已经发送过的服务器id列，多个用英文逗号隔开',
  `updated_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '修改时间',
  `created_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2000001 DEFAULT CHARSET=utf8 COMMENT='活动列表';

-- ----------------------------
-- Records of bms_active
-- ----------------------------
-- INSERT INTO `bms_active` VALUES ('1000001', '七彩华章（兑换商店）', '44', '0', '0', '0', '44七彩华章（兑换商店）活动描述', 'promotioncolourfulshops.xlsx', '100005', '1573563575', '1573562228');

-- ----------------------------
-- Table structure for `bms_active_type`
-- ----------------------------
DROP TABLE IF EXISTS `bms_active_type`;
CREATE TABLE `bms_active_type` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '活动类型ID',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '活动类型名称',
  `desc` varchar(255) NOT NULL DEFAULT '' COMMENT '活动类型描述',
  `updated_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '修改时间',
  `created_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '状态，0.失效，1.有效',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8 COMMENT='活动类型列表';

-- ----------------------------
-- Records of bms_active_type
-- ----------------------------
INSERT INTO `bms_active_type` VALUES ('37', '许愿达标', '测试配置', '1573561949', '1573561949', '0');
INSERT INTO `bms_active_type` VALUES ('38', '占星阵任务', '测试配置', '1573561967', '1573561967', '0');
INSERT INTO `bms_active_type` VALUES ('39', '超值礼包', '测试配置', '1573561980', '1573561980', '0');
INSERT INTO `bms_active_type` VALUES ('40', '召唤达标', '测试配置', '1573562001', '1573561994', '0');
INSERT INTO `bms_active_type` VALUES ('41', '先知馈赠', '测试配置', '1573562021', '1573562014', '0');
INSERT INTO `bms_active_type` VALUES ('42', '祭坛兑换', '测试配置', '1573562035', '1573562035', '0');
INSERT INTO `bms_active_type` VALUES ('43', '召唤水晶', '测试配置', '1573562049', '1573562049', '0');
INSERT INTO `bms_active_type` VALUES ('44', '七彩华章', '限时兑换活动-测试配置', '1573562065', '1573562065', '0');
INSERT INTO `bms_active_type` VALUES ('45', '登录有礼', '测试配置', '1573562079', '1573562079', '0');
INSERT INTO `bms_active_type` VALUES ('46', '碎片进化', '测试配置', '1573562093', '1573562093', '0');
INSERT INTO `bms_active_type` VALUES ('48', '累计充值', '测试配置', '1573562108', '1573562108', '0');

-- ----------------------------
-- Table structure for `bms_nav`
-- ----------------------------
DROP TABLE IF EXISTS `bms_nav`;
CREATE TABLE `bms_nav` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(30) DEFAULT NULL COMMENT '导航名称',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否在菜单中显示：0.不显示，1.显示',
  `pid` mediumint(8) NOT NULL DEFAULT '0' COMMENT '父级id',
  `url` varchar(60) DEFAULT NULL COMMENT 'url地址',
  `orderby` tinyint(1) NOT NULL DEFAULT '0' COMMENT '在同级中的显示排序，越小越在前面',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '类型：0.后台菜单，1.权限菜单',
  `created_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=100216 DEFAULT CHARSET=utf8 COMMENT='后台菜单列表';

-- ----------------------------
-- Records of bms_nav
-- ----------------------------
INSERT INTO `bms_nav` VALUES ('10001', '后台管理', '1', '0', '###', '4', '0', '1575519631');
INSERT INTO `bms_nav` VALUES ('10002', '菜单管理', '1', '10001', 'Navlist/index', '0', '0', '1575519631');
INSERT INTO `bms_nav` VALUES ('10003', '权限管理', '1', '10001', 'Rootlist/index', '1', '0', '1575519631');
INSERT INTO `bms_nav` VALUES ('100004', '管理员管理', '1', '10001', 'Adminlist/index', '2', '0', '0');
INSERT INTO `bms_nav` VALUES ('100005', '服务器管理', '1', '0', '###', '1', '0', '0');
INSERT INTO `bms_nav` VALUES ('100006', '渠道列表', '1', '100005', 'Channel/index', '2', '0', '0');
INSERT INTO `bms_nav` VALUES ('100007', '服务器列表', '1', '100005', 'Server/index', '1', '0', '0');
INSERT INTO `bms_nav` VALUES ('100008', '渠道服务器', '1', '100005', 'ChannelServer/index', '3', '0', '0');
INSERT INTO `bms_nav` VALUES ('100009', '大区管理', '1', '100005', '###', '4', '0', '0');
INSERT INTO `bms_nav` VALUES ('100010', '大区列表', '1', '100009', 'BigServer/index', '0', '0', '0');
INSERT INTO `bms_nav` VALUES ('100011', '运营工具', '1', '0', '###', '2', '0', '0');
INSERT INTO `bms_nav` VALUES ('100012', '活动管理', '1', '100011', '###', '0', '0', '0');
INSERT INTO `bms_nav` VALUES ('100013', '活动列表', '1', '100012', 'Active/index', '0', '0', '0');
INSERT INTO `bms_nav` VALUES ('100014', '活动类型', '1', '100012', 'ActiveType/index', '1', '0', '0');
INSERT INTO `bms_nav` VALUES ('100015', '邮件管理', '1', '100011', '###', '1', '0', '0');
INSERT INTO `bms_nav` VALUES ('100016', '邮件模板', '1', '100015', 'Mailtemplate/index', '0', '0', '0');
INSERT INTO `bms_nav` VALUES ('100017', '邮件列表', '1', '100015', 'Mail/index', '1', '0', '0');
INSERT INTO `bms_nav` VALUES ('100018', '公告管理', '1', '100011', '###', '2', '0', '0');
INSERT INTO `bms_nav` VALUES ('100019', '弹屏公告', '1', '100018', 'Notice/index', '0', '0', '0');
INSERT INTO `bms_nav` VALUES ('100020', '跑马灯公告', '1', '100018', 'Marquee/index', '1', '0', '0');
INSERT INTO `bms_nav` VALUES ('100021', '激活码', '1', '100011', '###', '3', '0', '0');
INSERT INTO `bms_nav` VALUES ('100022', '礼包列表', '1', '100021', 'Gift/index', '0', '0', '0');
INSERT INTO `bms_nav` VALUES ('100023', '角色管理', '1', '100011', '###', '4', '0', '0');
INSERT INTO `bms_nav` VALUES ('100024', '角色列表', '1', '100023', 'UserServer/index', '0', '0', '0');
INSERT INTO `bms_nav` VALUES ('100025', '白名单列表', '1', '100023', 'WhiteList/index', '1', '0', '0');
INSERT INTO `bms_nav` VALUES ('100026', '充值管理', '1', '100011', '###', '5', '0', '0');
INSERT INTO `bms_nav` VALUES ('100027', '订单列表', '1', '100026', 'Recharge/index', '0', '0', '0');
INSERT INTO `bms_nav` VALUES ('100028', '刷新游戏配置', '1', '100165', 'ReloadConfig/reload', '0', '0', '0');
INSERT INTO `bms_nav` VALUES ('100029', '模拟充值', '1', '100026', 'VirtualRecharge/index', '1', '0', '0');
INSERT INTO `bms_nav` VALUES ('100030', '添加服务器', '0', '100007', 'Server/add', '0', '1', '0');
INSERT INTO `bms_nav` VALUES ('100031', '维护（踢下线）', '0', '100007', 'Server/defend', '1', '1', '0');
INSERT INTO `bms_nav` VALUES ('100032', '编辑服务器', '0', '100007', 'Server/edit', '2', '1', '0');
INSERT INTO `bms_nav` VALUES ('100033', '发送开服时间', '0', '100007', 'Server/ajax_send_optime', '3', '1', '0');
INSERT INTO `bms_nav` VALUES ('100034', '添加服务器ajax', '0', '100007', 'Server/ajax_add', '4', '1', '0');
INSERT INTO `bms_nav` VALUES ('100035', '编辑服务器ajax', '0', '100007', 'Server/ajax_updata', '5', '1', '0');
INSERT INTO `bms_nav` VALUES ('100036', '维护（踢下线）ajax', '0', '100007', 'Server/ajax_defend', '6', '1', '0');
INSERT INTO `bms_nav` VALUES ('100037', '添加渠道', '0', '100006', 'Channel/add', '0', '1', '0');
INSERT INTO `bms_nav` VALUES ('100038', '添加渠道ajax', '0', '100006', 'Channel/ajax_add', '1', '1', '0');
INSERT INTO `bms_nav` VALUES ('100039', '编辑渠道', '0', '100006', 'Channel/edit', '2', '1', '0');
INSERT INTO `bms_nav` VALUES ('100040', '编辑渠道ajax', '0', '100006', 'Channel/ajax_updata', '3', '1', '0');
INSERT INTO `bms_nav` VALUES ('100041', '添加渠道服务器', '0', '100008', 'ChannelServer/add', '0', '1', '0');
INSERT INTO `bms_nav` VALUES ('100042', '添加渠道服务器ajax', '0', '100008', 'ChannelServer/ajax_add', '1', '1', '0');
INSERT INTO `bms_nav` VALUES ('100043', '编辑渠道服务器', '0', '100008', 'ChannelServer/edit', '2', '1', '0');
INSERT INTO `bms_nav` VALUES ('100044', '编辑渠道服务器ajax', '0', '100008', 'ChannelServer/ajax_updata', '3', '1', '0');
INSERT INTO `bms_nav` VALUES ('100045', '添加大区', '0', '100010', 'BigServer/add', '0', '1', '0');
INSERT INTO `bms_nav` VALUES ('100046', '添加大区ajax', '0', '100010', 'BigServer/ajax_add', '1', '1', '0');
INSERT INTO `bms_nav` VALUES ('100047', '编辑大区', '0', '100010', 'BigServer/edit', '2', '1', '0');
INSERT INTO `bms_nav` VALUES ('100048', '编辑大区ajax', '0', '100010', 'BigServer/ajax_updata', '3', '1', '0');
INSERT INTO `bms_nav` VALUES ('100049', '添加活动', '0', '100013', 'Active/add', '0', '1', '0');
INSERT INTO `bms_nav` VALUES ('100050', '添加活动ajax', '0', '100013', 'Active/ajax_add', '1', '1', '0');
INSERT INTO `bms_nav` VALUES ('100051', '上传excel文件', '0', '100011', 'Active/excel_upload', '7', '1', '0');
INSERT INTO `bms_nav` VALUES ('100052', '编辑活动', '0', '100013', 'Active/edit', '2', '1', '0');
INSERT INTO `bms_nav` VALUES ('100053', '编辑活动ajax', '0', '100013', 'Active/ajax_updata', '3', '1', '0');
INSERT INTO `bms_nav` VALUES ('100054', '活动发送服务器', '0', '100013', 'Active/server', '4', '1', '0');
INSERT INTO `bms_nav` VALUES ('100055', '活动发送服务器ajax', '0', '100013', 'Active/ajax_server', '5', '1', '0');
INSERT INTO `bms_nav` VALUES ('100056', '添加活动类型', '0', '100014', 'ActiveType/add', '0', '1', '0');
INSERT INTO `bms_nav` VALUES ('100057', '添加活动类型ajax', '0', '100014', 'ActiveType/ajax_add', '1', '1', '0');
INSERT INTO `bms_nav` VALUES ('100058', '编辑活动类型', '0', '100014', 'ActiveType/edit', '2', '1', '0');
INSERT INTO `bms_nav` VALUES ('100059', '编辑活动类型ajax', '0', '100014', 'ActiveType/ajax_updata', '3', '1', '0');
INSERT INTO `bms_nav` VALUES ('100060', '添加邮件模板', '0', '100016', 'Mailtemplate/add', '0', '1', '0');
INSERT INTO `bms_nav` VALUES ('100061', '添加邮件模板ajax', '0', '100016', 'Mailtemplate/ajax_add', '1', '1', '0');
INSERT INTO `bms_nav` VALUES ('100062', '编辑邮件模板', '0', '100016', 'Mailtemplate/edit', '2', '1', '0');
INSERT INTO `bms_nav` VALUES ('100063', '编辑邮件模板ajax', '0', '100016', 'Mailtemplate/ajax_updata', '3', '1', '0');
INSERT INTO `bms_nav` VALUES ('100064', '添加邮件', '0', '100017', 'Mail/add', '0', '1', '0');
INSERT INTO `bms_nav` VALUES ('100065', '添加邮件ajax', '0', '100017', 'Mail/ajax_add', '1', '1', '0');
INSERT INTO `bms_nav` VALUES ('100066', '编辑邮件', '0', '100017', 'Mail/edit', '2', '1', '0');
INSERT INTO `bms_nav` VALUES ('100067', '编辑邮件ajax', '0', '100017', 'Mail/ajax_updata', '3', '1', '0');
INSERT INTO `bms_nav` VALUES ('100068', '审核邮件', '0', '100017', 'Mail/ajax_send', '4', '1', '0');
INSERT INTO `bms_nav` VALUES ('100069', '添加弹屏公告', '0', '100019', 'Notice/add', '0', '1', '0');
INSERT INTO `bms_nav` VALUES ('100070', '添加弹屏公告ajax', '0', '100019', 'Notice/ajax_add', '1', '1', '0');
INSERT INTO `bms_nav` VALUES ('100071', '编辑弹屏公告', '0', '100019', 'Notice/edit', '2', '1', '0');
INSERT INTO `bms_nav` VALUES ('100072', '编辑弹屏公告ajax', '0', '100019', 'Notice/ajax_updata', '3', '1', '0');
INSERT INTO `bms_nav` VALUES ('100073', '添加跑马灯', '0', '100020', 'Marquee/add', '0', '1', '0');
INSERT INTO `bms_nav` VALUES ('100074', '添加跑马灯ajax', '0', '100020', 'Marquee/ajax_add', '1', '1', '0');
INSERT INTO `bms_nav` VALUES ('100075', '编辑跑马灯', '0', '100020', 'Marquee/edit', '2', '1', '0');
INSERT INTO `bms_nav` VALUES ('100076', '编辑跑马灯ajax', '0', '100020', 'Marquee/ajax_updata', '3', '1', '0');
INSERT INTO `bms_nav` VALUES ('100077', '开启跑马灯', '0', '100020', 'Marquee/ajax_open', '4', '1', '0');
INSERT INTO `bms_nav` VALUES ('100078', '关闭跑马灯', '0', '100020', 'Marquee/ajax_close', '5', '1', '0');
INSERT INTO `bms_nav` VALUES ('100079', '添加礼包', '0', '100022', 'Gift/add', '0', '1', '0');
INSERT INTO `bms_nav` VALUES ('100080', '添加礼包ajax', '0', '100022', 'Gift/ajax_add', '1', '1', '0');
INSERT INTO `bms_nav` VALUES ('100081', '编辑礼包', '0', '100022', 'Gift/edit', '2', '1', '0');
INSERT INTO `bms_nav` VALUES ('100082', '编辑礼包ajax', '0', '100022', 'Gift/ajax_updata', '3', '1', '0');
INSERT INTO `bms_nav` VALUES ('100083', '上传道具', '0', '100207', 'Gift/item', '4', '1', '0');
INSERT INTO `bms_nav` VALUES ('100084', '上传道具ajax', '0', '100207', 'Gift/ajax_item', '5', '1', '0');
INSERT INTO `bms_nav` VALUES ('100085', '兑换码', '0', '100022', 'Gift/code', '6', '1', '0');
INSERT INTO `bms_nav` VALUES ('100086', '追加兑换码', '0', '100022', 'Gift/addcode', '7', '1', '0');
INSERT INTO `bms_nav` VALUES ('100087', '追加兑换码ajax', '0', '100022', 'Gift/ajax_add_code', '8', '1', '0');
INSERT INTO `bms_nav` VALUES ('100088', '导出兑换码', '0', '100022', 'Gift/exportcode', '9', '1', '0');
INSERT INTO `bms_nav` VALUES ('100089', '添加封禁', '0', '100024', 'UserServer/oprate', '0', '1', '0');
INSERT INTO `bms_nav` VALUES ('100090', '添加封禁ajax', '0', '100024', 'UserServer/ajax_oprate', '1', '1', '0');
INSERT INTO `bms_nav` VALUES ('100091', '解除封号', '0', '100024', 'UserServer/ajax_yes_play', '2', '1', '0');
INSERT INTO `bms_nav` VALUES ('100092', '解除禁言', '0', '100024', 'UserServer/ajax_yes_chat', '3', '1', '0');
INSERT INTO `bms_nav` VALUES ('100093', '封禁日志', '0', '100024', 'UserServer/opratelog', '4', '1', '0');
INSERT INTO `bms_nav` VALUES ('100094', '角色替换', '0', '100024', 'UserServer/replace', '5', '1', '0');
INSERT INTO `bms_nav` VALUES ('100095', '角色替换ajax', '0', '100024', 'UserServer/ajax_replace', '6', '1', '0');
INSERT INTO `bms_nav` VALUES ('100096', '添加白名单', '0', '100025', 'WhiteList/add', '0', '1', '0');
INSERT INTO `bms_nav` VALUES ('100097', '添加白名单ajax', '0', '100025', 'WhiteList/ajax_add', '1', '1', '0');
INSERT INTO `bms_nav` VALUES ('100098', '删除白名单', '0', '100025', 'WhiteList/ajax_del', '2', '1', '0');
INSERT INTO `bms_nav` VALUES ('100099', '上传商品', '0', '100207', 'VirtualRecharge/upproduct', '0', '1', '0');
INSERT INTO `bms_nav` VALUES ('100100', '上传商品ajax', '0', '100207', 'VirtualRecharge/ajax_upproduct', '1', '1', '0');
INSERT INTO `bms_nav` VALUES ('100101', '商品列表', '0', '100207', 'VirtualRecharge/product', '2', '1', '0');
INSERT INTO `bms_nav` VALUES ('100102', '模拟充值', '0', '100029', 'VirtualRecharge/add', '3', '1', '0');
INSERT INTO `bms_nav` VALUES ('100103', '模拟充值ajax', '0', '100029', 'VirtualRecharge/ajax_add', '4', '1', '0');
INSERT INTO `bms_nav` VALUES ('100104', '刷新游戏配置ajax', '0', '100028', 'ReloadConfig/ajax_reload', '0', '1', '0');
INSERT INTO `bms_nav` VALUES ('100105', '首页', '0', '100108', 'Index/index', '0', '1', '0');
INSERT INTO `bms_nav` VALUES ('100106', '登录', '0', '100108', 'Login/index', '1', '1', '0');
INSERT INTO `bms_nav` VALUES ('100107', '退出', '0', '100108', 'Login/quit', '2', '1', '0');
INSERT INTO `bms_nav` VALUES ('100108', '登出', '0', '100011', '###', '8', '0', '0');
INSERT INTO `bms_nav` VALUES ('100109', '首页2', '0', '100108', 'Index/main', '3', '1', '0');
INSERT INTO `bms_nav` VALUES ('100110', '添加菜单', '0', '10002', 'Navlist/add', '0', '1', '0');
INSERT INTO `bms_nav` VALUES ('100111', '添加菜单ajax', '0', '10002', 'Navlist/ajax_add', '1', '1', '0');
INSERT INTO `bms_nav` VALUES ('100112', '编辑菜单', '0', '10002', 'Navlist/edit', '2', '1', '0');
INSERT INTO `bms_nav` VALUES ('100113', '编辑菜单ajax', '0', '10002', 'Navlist/ajax_updata', '3', '1', '0');
INSERT INTO `bms_nav` VALUES ('100114', '修改排序', '0', '100011', 'Public/order', '9', '1', '0');
INSERT INTO `bms_nav` VALUES ('100115', '修改菜单状态', '0', '10002', 'Navlist/ajax_updata_status', '4', '1', '0');
INSERT INTO `bms_nav` VALUES ('100116', '添加权限', '0', '10003', 'Rootlist/add', '0', '1', '0');
INSERT INTO `bms_nav` VALUES ('100117', '添加权限ajax', '0', '10003', 'Rootlist/ajax_add', '1', '1', '0');
INSERT INTO `bms_nav` VALUES ('100118', '编辑权限', '0', '10003', 'Rootlist/edit', '2', '1', '0');
INSERT INTO `bms_nav` VALUES ('100119', '编辑权限ajax', '0', '10003', 'Rootlist/ajax_updata', '3', '1', '0');
INSERT INTO `bms_nav` VALUES ('100120', '添加管理员', '0', '100004', 'Adminlist/add', '0', '1', '0');
INSERT INTO `bms_nav` VALUES ('100121', '添加管理员ajax', '0', '100004', 'Adminlist/ajax_add', '1', '1', '0');
INSERT INTO `bms_nav` VALUES ('100122', '编辑管理员', '0', '100004', 'Adminlist/edit', '2', '1', '0');
INSERT INTO `bms_nav` VALUES ('100123', '编辑管理员ajax', '0', '100004', 'Adminlist/ajax_updata', '3', '1', '0');
INSERT INTO `bms_nav` VALUES ('100124', '修改管理员状态', '0', '100004', 'Adminlist/ajax_updata_status', '4', '1', '0');
INSERT INTO `bms_nav` VALUES ('100125', '审核模拟充值', '0', '100029', 'VirtualRecharge/ajax_send', '5', '1', '0');
INSERT INTO `bms_nav` VALUES ('100126', '角色替换日志', '0', '100024', 'UserServer/replacelog', '7', '1', '0');
INSERT INTO `bms_nav` VALUES ('100127', '后台操作日志', '1', '10001', 'RequestLog/index', '3', '0', '0');
INSERT INTO `bms_nav` VALUES ('100128', '信息查询', '1', '0', '###', '2', '0', '0');
INSERT INTO `bms_nav` VALUES ('100129', '玩家信息查询', '1', '100128', 'Role/index', '0', '0', '0');
INSERT INTO `bms_nav` VALUES ('100130', '聊天管理', '1', '100011', '###', '6', '0', '0');
INSERT INTO `bms_nav` VALUES ('100131', '敏感词列表', '1', '100130', 'SensitiveWord/index', '0', '0', '0');
INSERT INTO `bms_nav` VALUES ('100132', '添加敏感词', '0', '100131', 'SensitiveWord/add', '0', '1', '0');
INSERT INTO `bms_nav` VALUES ('100133', '添加敏感词ajax', '0', '100131', 'SensitiveWord/ajax_add', '1', '1', '0');
INSERT INTO `bms_nav` VALUES ('100134', '发送敏感词', '0', '100131', 'SensitiveWord/send', '2', '1', '0');
INSERT INTO `bms_nav` VALUES ('100135', '发送敏感词ajax', '0', '100131', 'SensitiveWord/ajax_send', '3', '1', '0');
INSERT INTO `bms_nav` VALUES ('100136', '发送敏感词记录', '0', '100131', 'SensitiveWord/send_log', '4', '1', '0');
INSERT INTO `bms_nav` VALUES ('100137', '删除敏感词', '0', '100131', 'SensitiveWord/ajax_delete', '5', '1', '0');
INSERT INTO `bms_nav` VALUES ('100138', '角色信息详情', '0', '100129', 'Role/info', '0', '1', '0');
INSERT INTO `bms_nav` VALUES ('100139', '玩家公会科技信息', '0', '100129', 'Role/clan_skill', '1', '1', '0');
INSERT INTO `bms_nav` VALUES ('100140', '玩家背包信息', '0', '100129', 'Role/back_pack', '2', '1', '0');
INSERT INTO `bms_nav` VALUES ('100141', '英雄装备信息', '0', '100129', 'Role/hero_equip', '3', '1', '0');
INSERT INTO `bms_nav` VALUES ('100142', '英雄精灵信息', '0', '100129', 'Role/hero_rune', '4', '1', '0');
INSERT INTO `bms_nav` VALUES ('100143', '玩家操作日志', '1', '100128', '###', '1', '0', '0');
INSERT INTO `bms_nav` VALUES ('100144', '道具日志', '1', '100143', 'ItemLog/index', '0', '0', '0');
INSERT INTO `bms_nav` VALUES ('100145', '英雄获得/消耗日志', '1', '100143', 'HeroLog/index', '3', '0', '0');
INSERT INTO `bms_nav` VALUES ('100146', '上传流水事件', '0', '100207', 'Gift/gameevent', '5', '1', '0');
INSERT INTO `bms_nav` VALUES ('100147', '上传流水事件ajax', '0', '100207', 'Gift/ajax_gameevent', '5', '1', '0');
INSERT INTO `bms_nav` VALUES ('100148', '上传英雄', '0', '100207', 'Gift/hero', '5', '1', '0');
INSERT INTO `bms_nav` VALUES ('100149', '上传英雄ajax', '0', '100207', 'Gift/ajax_hero', '5', '1', '0');
INSERT INTO `bms_nav` VALUES ('100150', '导出道具日志', '0', '100144', 'ItemLog/export', '0', '1', '0');
INSERT INTO `bms_nav` VALUES ('100151', '导出英雄获得/消耗日志', '0', '100145', 'HeroLog/export', '0', '1', '0');
INSERT INTO `bms_nav` VALUES ('100152', '数据分析', '1', '0', '###', '1', '0', '0');
INSERT INTO `bms_nav` VALUES ('100153', '数据总览', '1', '100152', '###', '0', '0', '0');
INSERT INTO `bms_nav` VALUES ('100154', '每日总览', '1', '100153', 'OverviewDay/index', '0', '0', '0');
INSERT INTO `bms_nav` VALUES ('100155', '分区总览', '1', '100153', 'OverviewServer/index', '1', '0', '0');
INSERT INTO `bms_nav` VALUES ('100156', '开服当天数据', '1', '100153', 'OverviewOpen/index', '2', '0', '0');
INSERT INTO `bms_nav` VALUES ('100157', '渠道占比', '1', '100153', 'OverviewChannel/index', '3', '0', '0');
INSERT INTO `bms_nav` VALUES ('100158', '金币日志', '1', '100143', 'GoldLog/index', '1', '0', '0');
INSERT INTO `bms_nav` VALUES ('100159', '金币日志导出', '0', '100158', 'GoldLog/export', '0', '1', '0');
INSERT INTO `bms_nav` VALUES ('100160', '钻石日志', '1', '100143', 'GemLog/index', '2', '0', '0');
INSERT INTO `bms_nav` VALUES ('100161', '钻石日志导出', '0', '100160', 'GemLog/export', '0', '1', '0');
INSERT INTO `bms_nav` VALUES ('100162', '运营数据', '1', '100152', '###', '1', '0', '0');
INSERT INTO `bms_nav` VALUES ('100163', '实时新增', '1', '100162', 'OperateData/RealAdd', '0', '0', '0');
INSERT INTO `bms_nav` VALUES ('100164', '发送服务器日志', '0', '100013', 'Active/send_server_log', '6', '1', '0');
INSERT INTO `bms_nav` VALUES ('100165', '后端特殊操作', '1', '100011', '###', '7', '0', '0');
INSERT INTO `bms_nav` VALUES ('100166', '热更--更新后端代码', '1', '100165', 'ReloadConfig/hot_update', '1', '0', '0');
INSERT INTO `bms_nav` VALUES ('100167', '热更--更新后端代码ajax', '0', '100166', 'ReloadConfig/ajax_hot_reload', '0', '1', '0');
INSERT INTO `bms_nav` VALUES ('100168', '实时在线', '1', '100162', 'OperateData/RealOnline', '1', '0', '0');
INSERT INTO `bms_nav` VALUES ('100169', '每日留存', '1', '100162', 'OperateData/RetainDay', '2', '0', '0');
INSERT INTO `bms_nav` VALUES ('100170', '等级关卡流失', '1', '100162', 'OperateData/CheckpointLoss', '3', '0', '0');
INSERT INTO `bms_nav` VALUES ('100171', '上传公会科技配置', '0', '100207', 'Role/UpClanSkillConfig', '5', '1', '0');
INSERT INTO `bms_nav` VALUES ('100172', '上传公会科技配置ajax', '0', '100207', 'Role/ajax_UpClanSkillConfig', '6', '1', '0');
INSERT INTO `bms_nav` VALUES ('100173', '充值区间留存', '1', '100162', 'OperateData/RetainRechargeInterval', '4', '0', '0');
INSERT INTO `bms_nav` VALUES ('100174', '游戏数据', '1', '100152', '###', '2', '0', '0');
INSERT INTO `bms_nav` VALUES ('100175', '商城消费道具统计', '1', '100174', 'GameData/ShopLog', '0', '0', '0');
INSERT INTO `bms_nav` VALUES ('100176', '道具统计', '1', '100174', 'GameData/ItemStatis', '1', '0', '0');
INSERT INTO `bms_nav` VALUES ('100177', '道具统计详情', '1', '100174', 'GameData/ItemStatisDetails', '2', '0', '0');
INSERT INTO `bms_nav` VALUES ('100178', '渠道版本号管理', '1', '100165', 'ChannelVersion/index', '2', '0', '0');
INSERT INTO `bms_nav` VALUES ('100179', '添加渠道版本号', '0', '100178', 'ChannelVersion/add', '0', '1', '0');
INSERT INTO `bms_nav` VALUES ('100180', '添加渠道版本号ajax', '0', '100178', 'ChannelVersion/ajax_add', '1', '1', '0');
INSERT INTO `bms_nav` VALUES ('100181', '修改渠道版本号', '0', '100178', 'ChannelVersion/edit', '2', '1', '0');
INSERT INTO `bms_nav` VALUES ('100182', '修改渠道版本号ajax', '0', '100178', 'ChannelVersion/ajax_updata', '3', '1', '0');
INSERT INTO `bms_nav` VALUES ('100183', '道具每日库存统计', '1', '100174', 'GameData/ItemDay', '3', '0', '0');
INSERT INTO `bms_nav` VALUES ('100184', '充值数据', '1', '100152', '###', '3', '0', '0');
INSERT INTO `bms_nav` VALUES ('100185', '充值Ltv统计', '1', '100184', 'RechargeData/LtvDay', '0', '0', '0');
INSERT INTO `bms_nav` VALUES ('100186', '分组管理', '1', '100011', '###', '10', '0', '0');
INSERT INTO `bms_nav` VALUES ('100187', '分组列表', '1', '100186', 'Group/index', '0', '0', '0');
INSERT INTO `bms_nav` VALUES ('100188', '添加分组', '0', '100187', 'Group/add', '0', '1', '0');
INSERT INTO `bms_nav` VALUES ('100189', '添加分组ajax', '0', '100187', 'Group/ajax_add', '1', '1', '0');
INSERT INTO `bms_nav` VALUES ('100190', '修改分组', '0', '100187', 'Group/edit', '2', '1', '0');
INSERT INTO `bms_nav` VALUES ('100191', '修改分组ajax', '0', '100187', 'Group/ajax_updata', '3', '1', '0');
INSERT INTO `bms_nav` VALUES ('100192', '充值商品统计', '1', '100184', 'RechargeData/ProductStatis', '1', '0', '0');
INSERT INTO `bms_nav` VALUES ('100193', '消费类型统计', '1', '100174', 'GameData/EventStatis', '4', '0', '0');
INSERT INTO `bms_nav` VALUES ('100194', '玩家充值排行', '1', '100184', 'RechargeData/RechargeRanking', '2', '0', '0');
INSERT INTO `bms_nav` VALUES ('100195', '每日在线峰值', '1', '100162', 'OperateData/OnlineApex', '5', '0', '0');
INSERT INTO `bms_nav` VALUES ('100196', '聊天滚动详情', '1', '100130', 'Chat/ChatLog', '1', '0', '0');
INSERT INTO `bms_nav` VALUES ('100197', '聊天滚动ajax', '0', '100196', 'Chat/ajax_ChatLog', '0', '1', '0');
INSERT INTO `bms_nav` VALUES ('100198', '获取服务器的公会数据', '0', '100196', 'Chat/getClanData', '1', '1', '0');
INSERT INTO `bms_nav` VALUES ('100199', '每日总览c', '1', '100153', 'OverviewDay/index_copy', '4', '0', '0');
INSERT INTO `bms_nav` VALUES ('100200', '每日留存c', '1', '100162', 'OperateData/RetainDayCopy', '6', '0', '0');
INSERT INTO `bms_nav` VALUES ('100201', '等级关卡流失导出', '0', '100170', 'OperateData/CheckpointLossExport', '0', '1', '0');
INSERT INTO `bms_nav` VALUES ('100202', '补单', '0', '100027', 'Recharge/ajax_supply_order', '0', '1', '0');
INSERT INTO `bms_nav` VALUES ('100203', '首充数据', '1', '100184', 'RechargeData/FirstRecharge', '3', '0', '0');
INSERT INTO `bms_nav` VALUES ('100204', '道具统计详情导出', '0', '100177', 'GameData/ItemStatisDetailsExport', '0', '1', '0');
INSERT INTO `bms_nav` VALUES ('100205', '每日首充统计', '1', '100184', 'RechargeData/FirstRechargeDay', '4', '0', '0');
INSERT INTO `bms_nav` VALUES ('100206', '在线时长', '1', '100162', 'OperateData/OnlineLength', '7', '0', '0');
INSERT INTO `bms_nav` VALUES ('100207', '上传资源', '1', '100011', 'UploadResource/index', '11', '0', '0');
INSERT INTO `bms_nav` VALUES ('100208', '导出订单', '0', '100027', 'Recharge/export', '1', '1', '0');
INSERT INTO `bms_nav` VALUES ('100209', '充值区间统计', '1', '100184', 'RechargeData/RechargeInterval', '5', '0', '0');
INSERT INTO `bms_nav` VALUES ('100210', '英雄宝石信息', '0', '100129', 'Role/hero_jewel', '5', '1', '0');
INSERT INTO `bms_nav` VALUES ('100211', '英雄神装信息', '0', '100129', 'Role/hero_god_equip', '6', '1', '0');
INSERT INTO `bms_nav` VALUES ('100212', '删除公告', '0', '100019', 'Notice/ajax_delete', '4', '1', '0');
INSERT INTO `bms_nav` VALUES ('100213', '批量添加邮件', '0', '100017', 'Mail/adds', '5', '1', '0');
INSERT INTO `bms_nav` VALUES ('100214', '批量添加邮件ajax', '0', '100017', 'Mail/ajax_adds', '6', '1', '0');
INSERT INTO `bms_nav` VALUES ('100215', '批量审核邮件', '0', '100017', 'Mail/ajax_sends', '7', '1', '0');

-- ----------------------------
-- Table structure for `bms_users`
-- ----------------------------
DROP TABLE IF EXISTS `bms_users`;
CREATE TABLE `bms_users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '//用户名',
  `password` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '//登录密码',
  `belongs_to` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '所属人名字',
  `root_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '权限组id',
  `comment` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '备注',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态：0.关闭，1.开启',
  `updated_at` int(11) NOT NULL DEFAULT '0' COMMENT '//更新时间',
  `created_at` int(11) NOT NULL DEFAULT '0' COMMENT '//创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=100019 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='后台管理员表';

-- ----------------------------
-- Records of bms_users
-- ----------------------------
INSERT INTO `bms_users` VALUES ('100001', 'admin', 'b7ed399e506be3d17c811e937c14bf5b', '超级管理员', '1001', '', '1', '1585724368', '1572077384');
INSERT INTO `bms_users` VALUES ('100002', 'liushuhui', '5a5a8b5da7bf188ef49301cbfa3240ef', '刘淑慧', '1005', '', '1', '1576239964', '1575537488');
INSERT INTO `bms_users` VALUES ('100003', 'tangyangbo', 'afe7a3982a35e27395843df1ec8268f5', '唐洋波', '1001', '', '1', '1584843010', '1575537543');
INSERT INTO `bms_users` VALUES ('100004', 'fanjiali', '14e1b600b1fd579f47433b88e8d85291', '范家立', '1003', '', '1', '1575537770', '1575537575');
INSERT INTO `bms_users` VALUES ('100005', 'huangyuyuan', '14e1b600b1fd579f47433b88e8d85291', '黄昱源', '1002', '', '1', '1575537780', '1575537604');
INSERT INTO `bms_users` VALUES ('100006', 'keyiyouxi', '57735e0950e18f7791ff8fa6e35b5fb0', '可以游戏', '1006', '', '1', '1575884936', '1575556489');
INSERT INTO `bms_users` VALUES ('100007', 'chenweijian', '14e1b600b1fd579f47433b88e8d85291', '陈伟建', '1002', '', '1', '1575861525', '1575861525');
INSERT INTO `bms_users` VALUES ('100008', 'yaoqiyi', '960cb0351847a9f83547d16b5008db08', '姚老板', '1005', '', '1', '1576153540', '1575884737');
INSERT INTO `bms_users` VALUES ('100009', 'keyiyunying', '8294389b19ab27196b5917c0b1529cc9', '可以游戏-运营（梓琦）', '1004', '', '1', '1575884864', '1575884864');
INSERT INTO `bms_users` VALUES ('100010', 'keyikefu', 'd469082da3a03123caad3b05bd02f1ef', '可以游戏-客服', '1007', '', '1', '1575884898', '1575884898');
INSERT INTO `bms_users` VALUES ('100011', 'qiutingting', '73713dc3d80e02b55d6c345b8d009756', '邱婷婷', '1008', '', '1', '1578476534', '1575945986');
INSERT INTO `bms_users` VALUES ('100012', 'cuienzhi', 'a33eca94944e95047e74a10e5bd569e2', '崔恩智', '1003', '', '1', '1575990417', '1575990417');
INSERT INTO `bms_users` VALUES ('100013', 'zhangruibo', '901f8cd0a128a8d5be2aa64f5373a95f', '张瑞博', '1008', '', '1', '1578476504', '1575991370');
INSERT INTO `bms_users` VALUES ('100014', 'luyuqiu', 'c20146504ad8e05e41b159ea569a12cb', '陆宇秋', '1009', '', '1', '1576063399', '1576063176');
INSERT INTO `bms_users` VALUES ('100015', 'wangyan', '14e1b600b1fd579f47433b88e8d85291', '王严', '1003', '', '1', '1584586732', '1581697517');
INSERT INTO `bms_users` VALUES ('100016', 'wuhua', 'e9ec67b4e932ec928f35a3bead4c2a9f', '吴华', '1002', '', '1', '1582087144', '1582087144');
INSERT INTO `bms_users` VALUES ('100017', 'linjieru', '8e292ec32b6dc18af70cc83a0031e28a', '林洁茹', '1010', '', '1', '1584934718', '1584934651');
INSERT INTO `bms_users` VALUES ('100018', 'meiyingchun', 'ce9637ef33717d0d0a170ad3abd98003', '梅迎春', '1002', '', '1', '1585659121', '1585659121');

-- ----------------------------
-- Table structure for `bms_users_root`
-- ----------------------------
DROP TABLE IF EXISTS `bms_users_root`;
CREATE TABLE `bms_users_root` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '权限组名称',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态：0.关闭，1.开启',
  `channels_id` text COMMENT '渠道权限id集',
  `menu_id` text COMMENT '权限集合，包括菜单权限和功能权限',
  `created_at` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1011 DEFAULT CHARSET=utf8 COMMENT='后台管理员权限组表';

-- ----------------------------
-- Records of bms_users_root
-- ----------------------------
INSERT INTO `bms_users_root` VALUES ('1001', '超级管理员', '1', '-1,1,100000,100001,100002,100003,', '-1,100005,100007,100030,100031,100032,100033,100034,100035,100036,100006,100037,100038,100039,100040,100008,100041,100042,100043,100044,100009,100010,100045,100046,100047,100048,100152,100153,100154,100155,100156,100157,100199,100162,100163,100168,100169,100170,100201,100173,100195,100200,100206,100174,100175,100176,100177,100204,100183,100193,100184,100185,100192,100194,100203,100205,100209,100011,100012,100013,100049,100050,100052,100053,100054,100055,100164,100014,100056,100057,100058,100059,100015,100016,100060,100061,100062,100063,100017,100064,100065,100066,100067,100068,100213,100214,100215,100018,100019,100069,100070,100071,100072,100212,100020,100073,100074,100075,100076,100077,100078,100021,100022,100079,100080,100081,100082,100085,100086,100087,100088,100023,100024,100089,100090,100091,100092,100093,100094,100095,100126,100025,100096,100097,100098,100026,100027,100202,100208,100029,100102,100103,100125,100130,100131,100132,100133,100134,100135,100136,100137,100196,100197,100198,100051,100165,100028,100104,100166,100167,100178,100179,100180,100181,100182,100108,100105,100106,100107,100109,100114,100186,100187,100188,100189,100190,100191,100207,100099,100100,100101,100083,100084,100146,100147,100148,100149,100171,100172,100128,100129,100138,100139,100140,100141,100142,100210,100211,100143,100144,100150,100158,100159,100160,100161,100145,100151,10001,10002,100110,100111,100112,100113,100115,10003,100116,100117,100118,100119,100004,100120,100121,100122,100123,100124,100127,', '1572074563');
INSERT INTO `bms_users_root` VALUES ('1002', '技术', '1', '-1,1,100000,100001,100002,100003,', '100005,100007,100006,100008,100009,100010,100011,100012,100013,100014,100015,100016,100060,100061,100062,100063,100017,100064,100065,100066,100067,100018,100019,100020,100021,100022,100023,100024,100089,100090,100091,100092,100093,100025,100096,100097,100026,100027,100202,100029,100102,100103,100130,100131,100132,100133,100134,100135,100136,100137,100196,100197,100198,100051,100165,100028,100104,100166,100167,100178,100179,100180,100181,100182,100108,100105,100106,100107,100109,100114,100101,100128,100129,100138,100139,100140,100141,100142,100143,100144,100150,100158,100159,100160,100161,100145,100151,100127,', '1572074854');
INSERT INTO `bms_users_root` VALUES ('1003', '策划', '1', '-1,1,100000,100001,100002,100003,', '100005,100007,100031,100032,100033,100035,100036,100006,100037,100038,100039,100040,100008,100041,100042,100043,100044,100009,100010,100045,100046,100047,100048,100152,100153,100154,100155,100156,100157,100199,100162,100163,100168,100169,100170,100201,100173,100195,100200,100206,100174,100175,100176,100177,100204,100183,100193,100184,100185,100192,100194,100203,100205,100209,100011,100012,100013,100049,100050,100052,100053,100054,100055,100164,100014,100056,100057,100058,100059,100015,100016,100060,100061,100062,100063,100017,100064,100065,100066,100067,100213,100214,100018,100019,100069,100070,100071,100072,100020,100073,100074,100075,100076,100077,100078,100021,100022,100079,100080,100081,100082,100085,100086,100087,100088,100023,100024,100089,100090,100091,100092,100093,100094,100095,100126,100025,100096,100097,100098,100026,100027,100202,100208,100029,100102,100103,100130,100131,100132,100133,100134,100135,100136,100137,100196,100197,100198,100051,100108,100105,100106,100107,100109,100114,100207,100099,100100,100101,100083,100084,100146,100147,100148,100149,100171,100172,100128,100129,100138,100139,100140,100141,100142,100210,100211,100143,100144,100150,100158,100159,100160,100161,100145,100151,100127,', '1575537438');
INSERT INTO `bms_users_root` VALUES ('1004', '可以游戏-运营', '1', '-1,1,100000,100001,100002,100003,', '100005,100007,100031,100032,100033,100035,100036,100006,100008,100041,100042,100043,100044,100009,100010,100045,100046,100047,100048,100152,100153,100154,100155,100156,100157,100199,100162,100163,100168,100169,100170,100201,100173,100195,100200,100206,100174,100175,100176,100177,100204,100183,100193,100184,100185,100192,100194,100203,100205,100209,100011,100012,100013,100049,100050,100052,100053,100054,100055,100164,100014,100015,100016,100060,100061,100062,100063,100017,100064,100065,100066,100067,100213,100214,100018,100019,100069,100070,100071,100072,100212,100020,100073,100074,100075,100076,100077,100078,100021,100022,100079,100080,100081,100082,100085,100086,100087,100088,100023,100024,100089,100090,100091,100092,100093,100094,100095,100126,100025,100096,100097,100098,100026,100027,100208,100029,100102,100103,100130,100131,100132,100133,100134,100135,100136,100137,100196,100197,100198,100051,100108,100105,100106,100107,100109,100114,100207,100101,100128,100129,100138,100139,100140,100141,100142,100210,100211,100143,100144,100150,100158,100159,100160,100161,100145,100151,100127,', '1575537450');
INSERT INTO `bms_users_root` VALUES ('1005', 'PM', '1', '-1,1,100000,100001,100002,100003,', '100005,100007,100030,100031,100032,100033,100034,100035,100036,100006,100037,100038,100039,100040,100008,100041,100042,100043,100044,100009,100010,100045,100046,100047,100048,100152,100153,100154,100155,100156,100157,100199,100162,100163,100168,100169,100170,100201,100173,100195,100200,100206,100174,100175,100176,100177,100204,100183,100193,100184,100185,100192,100194,100203,100205,100209,100011,100012,100013,100049,100050,100052,100053,100054,100055,100164,100014,100056,100057,100058,100059,100015,100016,100060,100061,100062,100063,100017,100064,100065,100066,100067,100068,100213,100214,100215,100018,100019,100069,100070,100071,100072,100212,100020,100073,100074,100075,100076,100077,100078,100021,100022,100079,100080,100081,100082,100085,100086,100087,100088,100023,100024,100089,100090,100091,100092,100093,100094,100095,100126,100025,100096,100097,100098,100026,100027,100202,100208,100029,100102,100103,100125,100130,100131,100132,100133,100134,100135,100136,100137,100196,100197,100198,100051,100165,100028,100104,100166,100167,100178,100179,100180,100181,100182,100108,100105,100106,100107,100109,100114,100207,100099,100100,100101,100083,100084,100146,100147,100148,100149,100171,100172,100128,100129,100138,100139,100140,100141,100142,100210,100211,100143,100144,100150,100158,100159,100160,100161,100145,100151,10001,10002,100110,100111,100112,100113,100115,10003,100116,100117,100118,100119,100004,100120,100121,100122,100123,100124,100127,', '1575537469');
INSERT INTO `bms_users_root` VALUES ('1006', '可以游戏-管理者', '1', '-1,1,100000,100001,100002,100003,', '100005,100007,100031,100032,100033,100035,100036,100006,100008,100041,100042,100043,100044,100009,100010,100045,100046,100047,100048,100152,100153,100154,100155,100156,100157,100199,100162,100163,100168,100169,100170,100201,100173,100195,100200,100206,100174,100175,100176,100177,100204,100183,100193,100184,100185,100192,100194,100203,100205,100209,100011,100012,100013,100049,100050,100052,100053,100054,100055,100164,100014,100015,100016,100060,100061,100062,100063,100017,100064,100065,100066,100067,100068,100213,100214,100215,100018,100019,100069,100070,100071,100072,100212,100020,100073,100074,100075,100076,100077,100078,100021,100022,100079,100080,100081,100082,100085,100086,100087,100088,100023,100024,100089,100090,100091,100092,100093,100094,100095,100126,100025,100096,100097,100098,100026,100027,100202,100208,100029,100102,100103,100125,100130,100131,100132,100133,100134,100135,100136,100137,100196,100197,100198,100051,100108,100105,100106,100107,100109,100114,100207,100101,100128,100129,100138,100139,100140,100141,100142,100210,100211,100143,100144,100150,100158,100159,100160,100161,100145,100151,100127,', '1575556452');
INSERT INTO `bms_users_root` VALUES ('1007', '可以游戏-客服', '1', '-1,1,100000,100001,100002,100003,', '100005,100007,100006,100008,100009,100010,100011,100012,100013,100015,100016,100060,100061,100062,100063,100017,100064,100065,100066,100067,100018,100019,100020,100023,100024,100089,100090,100091,100092,100093,100026,100027,100029,100102,100103,100130,100131,100132,100133,100134,100135,100136,100137,100196,100197,100198,100108,100105,100106,100107,100109,100114,100207,100101,100128,100129,100138,100139,100140,100141,100142,100210,100211,100143,100144,100150,100158,100159,100160,100161,100145,100151,', '1575882981');
INSERT INTO `bms_users_root` VALUES ('1008', '测试', '1', '-1,1,100000,100001,100002,100003,', '100005,100007,100031,100006,100008,100009,100010,100011,100012,100013,100164,100014,100015,100016,100060,100061,100062,100063,100017,100064,100065,100066,100067,100018,100019,100020,100021,100022,100023,100024,100089,100090,100091,100092,100093,100094,100095,100126,100025,100096,100097,100026,100027,100029,100102,100103,100130,100131,100132,100133,100134,100135,100136,100137,100196,100197,100198,100051,100108,100105,100106,100107,100109,100114,100207,100101,100128,100129,100138,100139,100140,100141,100142,100210,100211,100143,100144,100150,100158,100159,100160,100161,100145,100151,100127,', '1575882993');
INSERT INTO `bms_users_root` VALUES ('1009', '美术', '1', '-1,1,100000,100001,100002,100003,', '100005,100007,100006,100008,100009,100010,100152,100153,100154,100155,100156,100157,100199,100162,100168,100169,100200,100184,100185,100194,100011,100015,100016,100060,100061,100062,100063,100017,100064,100065,100066,100067,100068,100023,100024,100089,100090,100091,100092,100093,100025,100096,100097,100026,100027,100029,100102,100103,100125,100130,100131,100132,100133,100134,100135,100136,100196,100197,100198,100051,100108,100105,100106,100107,100109,100114,100207,100101,100128,100129,100138,100139,100140,100141,100142,100210,100211,100143,100144,100150,100158,100159,100160,100161,100145,100151,100127,', '1576063301');
INSERT INTO `bms_users_root` VALUES ('1010', '商务', '1', '-1,1,100000,100001,100002,100003,', '100005,100007,100006,100008,100009,100152,100153,100154,100155,100156,100157,100199,100162,100169,100200,100184,100185,100108,100105,100106,100107,100109,100114,', '1584934707');

-- ----------------------------
-- Table structure for `channel`
-- ----------------------------
DROP TABLE IF EXISTS `channel`;
CREATE TABLE `channel` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '渠道ID',
  `parent_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '父级（大）渠道id',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '渠道名称',
  `desc` varchar(255) NOT NULL DEFAULT '' COMMENT '渠道描述',
  `updated_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '修改时间',
  `created_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `parent_id` (`parent_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=200001 DEFAULT CHARSET=utf8 COMMENT='渠道表';


-- ----------------------------
-- Table structure for `gift`
-- ----------------------------
DROP TABLE IF EXISTS `gift`;
CREATE TABLE `gift` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '礼包ID',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '礼包名称',
  `note` varchar(255) NOT NULL DEFAULT '' COMMENT '备注',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '使用条件：礼包类型：0.普通码，1.通码，2.固定码',
  `code` varchar(50) NOT NULL DEFAULT '' COMMENT '固定码的code',
  `num` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '礼包数量',
  `use_num` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '普通码可使用次数',
  `gift_item` text COMMENT '礼包的道具，包括道具id和数量，用json字符串存储',
  `c_son_id` text COMMENT '使用条件：子渠道id集合，多个用英文逗号隔开',
  `sid` text COMMENT '使用条件：区服务器id集合，多个用英文逗号隔开，-1表示全服',
  `device_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '使用条件：0.无系统，1.安卓，2.ios',
  `vip` varchar(50) NOT NULL DEFAULT '0' COMMENT '使用条件：vip等级区间，例：12-21',
  `level` varchar(50) NOT NULL DEFAULT '0' COMMENT '使用条件：等级，例：12-21',
  `start_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '使用条件：开始时间',
  `end_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '使用条件：结束时间',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0.失效，1.生效',
  `updated_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '修改时间',
  `created_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20000001 DEFAULT CHARSET=utf8 COMMENT='礼包配置列表';


DROP TABLE IF EXISTS `gift_item`;
CREATE TABLE `gift_item` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '道具ID',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '道具名称',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '道具类型',
  `type_label` tinyint(1) NOT NULL DEFAULT '0' COMMENT '道具标签：1.装备，2.道具，3.碎片，4.特殊（精灵）',
  `quality` tinyint(1) NOT NULL DEFAULT '0' COMMENT '品质：1.绿，2.蓝，3.紫，4.橙，5.红，6.金',
  `star` tinyint(1) NOT NULL DEFAULT '0' COMMENT '星级',
  `type_name` varchar(255) NOT NULL DEFAULT '' COMMENT '道具类型名称',
  `created_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20000001 DEFAULT CHARSET=utf8 COMMENT='礼包道具';
-- ----------------------------
-- Records of gift
-- ----------------------------

-- ----------------------------
-- Table structure for `gift_code`
-- ----------------------------
DROP TABLE IF EXISTS `gift_code`;
CREATE TABLE `gift_code` (
  `code` varchar(50) NOT NULL DEFAULT '' COMMENT '激活码，礼包码',
  `role_id` varchar(128) NOT NULL DEFAULT '' COMMENT '角色id，礼包码的使用者，为空则未使用',
  `gift_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '礼包ID',
  `gift_name` varchar(255) NOT NULL DEFAULT '' COMMENT '礼包名称',
  `mark` varchar(150) NOT NULL DEFAULT '' COMMENT '标识',
  `created_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='礼包码列表';


DROP TABLE IF EXISTS `gift_code_log`;
CREATE TABLE `gift_code_log` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `code` varchar(50) NOT NULL DEFAULT '' COMMENT '激活码，礼包码',
  `role_id` varchar(128) NOT NULL DEFAULT '' COMMENT '角色id，礼包码的使用者',
  `gift_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '礼包ID',
  `gift_name` varchar(255) NOT NULL DEFAULT '' COMMENT '礼包名称',
  `mark` varchar(150) NOT NULL DEFAULT '' COMMENT '标识',
  `created_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20000001 DEFAULT CHARSET=utf8 COMMENT='礼包码使用流水';


-- ----------------------------
-- Table structure for `mail_template`
-- ----------------------------
DROP TABLE IF EXISTS `mail_template`;
CREATE TABLE `mail_template` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `title` varchar(200) NOT NULL COMMENT '邮件标题',
  `content` varchar(500) NOT NULL COMMENT '邮件内容',
  `item_data` text COMMENT '道具包裹，包括道具id和数量，用json字符串存储',
  `admin_id` int(11) NOT NULL DEFAULT '0' COMMENT '管理员id',
  `updated_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '修改时间',
  `created_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20001 DEFAULT CHARSET=utf8 COMMENT='邮件模板列表';

-- ----------------------------
-- Table structure for `mail_template`
-- ----------------------------
DROP TABLE IF EXISTS `mail`;
CREATE TABLE `mail` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `mail_template_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '邮件模板ID',
  `type` tinyint(1) NOT NULL DEFAULT '2' COMMENT '1.全服邮件，2.单服邮件',
  `title` varchar(200) NOT NULL DEFAULT '' COMMENT '邮件标题',
  `content` varchar(500) NOT NULL DEFAULT '' COMMENT '邮件内容',
  `item_data` text COMMENT '道具包裹，包括道具id和数量，用json字符串存储',
  `sid` text COMMENT '区服id，多个用英文逗号隔开',
  `role_ids` text COMMENT '角色id，多个用英文逗号隔开',
  `oprate_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '操作类型：0.手动添加，1.文件批量添加',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '状态：0.待审批，1.审批成功，2.审批失败',
  `note` text COMMENT '审核结果',
  `admin_id` int(11) NOT NULL DEFAULT '0' COMMENT '管理员id',
  `updated_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '修改时间',
  `created_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20000001 DEFAULT CHARSET=utf8 COMMENT='邮件列表';


-- ----------------------------
-- Table structure for `notice`
-- ----------------------------
DROP TABLE IF EXISTS `notice`;
CREATE TABLE `notice` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `name` varchar(200) NOT NULL DEFAULT '' COMMENT '标题',
  `label` varchar(200) NOT NULL DEFAULT '' COMMENT '标注',
  `device_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0.无系统，1.安卓，2.ios',
  `c_son_id` text COMMENT '子渠道id集合，多个用英文逗号隔开',
  `appellation`varchar(255) NOT NULL DEFAULT '' COMMENT '公告内容的称谓',
  `content` text COMMENT '公告内容',
  `sort` varchar(200) NOT NULL DEFAULT '' COMMENT '排序sort',
  `start_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '使用条件：开始时间',
  `end_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '使用条件：结束时间',
  `group_id` int(11) NOT NULL DEFAULT '10001' COMMENT '分组，默认是10001组',
  `is_show` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否显示：0.不显示，1.显示',
  `updated_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '修改时间',
  `created_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `device_type` (`device_type`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=20000001 DEFAULT CHARSET=utf8 COMMENT='公告列表';


DROP TABLE IF EXISTS `marquee`;
CREATE TABLE `marquee` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `name` varchar(200) NOT NULL DEFAULT '' COMMENT '标题',
  `device_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0.无系统，1.安卓，2.ios',
  `sid` text COMMENT '使用条件：区服务器id，为0为全部服务器',
  `c_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '大渠道id',
  `c_son_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '子渠道id',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0.关闭，1.开始',
  `content` text COMMENT '公告内容',
  `loop_count` varchar(50) NOT NULL DEFAULT '' COMMENT '跑马灯循环次数',
  `updated_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '修改时间',
  `created_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `device_type` (`device_type`) USING BTREE,
  KEY `c_id` (`c_id`) USING BTREE,
  KEY `c_son_id` (`c_son_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=20000001 DEFAULT CHARSET=utf8 COMMENT='跑马灯列表';


-- ----------------------------
-- Records of recharge
-- ----------------------------

-- ----------------------------
-- Table structure for `send_active_server`
DROP TABLE IF EXISTS `send_active_server`;
CREATE TABLE `send_active_server` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `active_id` int(11) unsigned NOT NULL COMMENT '活动ID',
  `active_name` varchar(255) NOT NULL DEFAULT '' COMMENT '活动名称',
  `active_type_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '活动类型id',
  `start_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '开始时间',
  `end_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '结束时间',
  `clear_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '清除时间',
  `server_id` varchar(255) NOT NULL DEFAULT '' COMMENT '发送的服务器id',
  `content` text COMMENT '发送的内容，json内容',
  `debug` text COMMENT '返回结果',
  `status` varchar(15) NOT NULL DEFAULT '' COMMENT '发送状态：200.成功',
  `admin_id` int(11) NOT NULL DEFAULT '0' COMMENT '发送管理员id',
  `created_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20000001 DEFAULT CHARSET=utf8 COMMENT='发送活动服务器的流水日志';

-- ----------------------------
-- Records of send_active_server
-- ----------------------------

-- ----------------------------
-- Table structure for `server`
-- ----------------------------
DROP TABLE IF EXISTS `server`;
CREATE TABLE `server` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '服务器ID',
  `extranet_host` varchar(200) NOT NULL DEFAULT '' COMMENT '服务器外网地址',
  `intranet_host` varchar(200) NOT NULL DEFAULT '' COMMENT '内网地址',
  `game_port` int(11) NOT NULL DEFAULT '0' COMMENT '游戏端口',
  `http_port` int(11) NOT NULL DEFAULT '0' COMMENT 'HTTP端口',
  `server_name` varchar(200) NOT NULL DEFAULT '' COMMENT '服务器名称',
  `note` text COMMENT '服务器备注',
  `is_new` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否是新服，0.否，1.是',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '服务器类型：0.正式服，1.测试服，2.审核服',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '分区状态：0未开放，1爆满，2流畅，3维护',
  `defend_end_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '维护时间，唯一用来判断是否是维护状态的字段',
  `open_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '开服时间',
  `heart_beat_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '服务器的心跳时间',
  `db_host` varchar(100) NOT NULL DEFAULT '' COMMENT '数据库地址',
  `db_port` int(11) NOT NULL DEFAULT '0' COMMENT '数据库端口',
  `db_user` varchar(50) NOT NULL DEFAULT '' COMMENT '数据库用户名',
  `db_password` varchar(50) NOT NULL DEFAULT '' COMMENT '数据库密码',
  `msg` varchar(255) NOT NULL DEFAULT '' COMMENT '服务器提示信息',
  `db_game_database` varchar(50) NOT NULL DEFAULT '' COMMENT '游戏数据库名',
  `db_log_database` varchar(50) NOT NULL DEFAULT '' COMMENT '日志数据库名',
  `role_nums` int(11) NOT NULL DEFAULT '0' COMMENT '创角数',
  `role_nums_limit` int(11) NOT NULL DEFAULT '0' COMMENT '创角阈值',
  `group_id` tinyint(1) NOT NULL DEFAULT '1' COMMENT '分组，默认是1组',
  `created_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updated_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`id`),
  KEY `is_new` (`is_new`) USING BTREE,
  KEY `status` (`status`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='区服务器表';

-- ----------------------------
-- Table structure for `server_channel`
-- ----------------------------
DROP TABLE IF EXISTS `server_channel`;
CREATE TABLE `server_channel` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `sid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '区服务器id',
  `big_server_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '大区id',
  `c_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '大渠道id',
  `c_son_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '子渠道id',
  `show_name` varchar(200) NOT NULL DEFAULT '' COMMENT '显示名称',
  `sort` varchar(200) NOT NULL DEFAULT '' COMMENT '渠道显示的顺序sort',
  `device_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '使用条件：0.所有系统，1.安卓，2.ios',
  `created_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `sid` (`sid`) USING BTREE,
  KEY `c_id` (`c_id`) USING BTREE,
  KEY `c_son_id` (`c_son_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=20000001 DEFAULT CHARSET=utf8 COMMENT='服务器与渠道的关系表';


-- ----------------------------
-- Table structure for `user`
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '平台用户自增id',
  `open_id` varchar(128) NOT NULL DEFAULT '' COMMENT '渠道用户id，就是玩家的登录账号',
  `c_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '大渠道id',
  `c_son_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '子渠道id',
  `device_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0.无系统，1.安卓，2.ios',
  `uuid` varchar(100) NOT NULL DEFAULT '' COMMENT '设备唯一标识码，适用安卓和ios',
  `last_login_sid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '玩家最后登录的区服务器id',
  `last_login_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '最后登录时间',
  `login_days` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '登录天数',
  `created_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `open_id` (`open_id`) USING BTREE,
  KEY `c_son_id` (`c_son_id`) USING BTREE,
  KEY `device_type` (`device_type`) USING BTREE,
  KEY `uuid` (`uuid`) USING BTREE,
  KEY `created_at` (`created_at`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=200000001 DEFAULT CHARSET=utf8 COMMENT='玩家信息表';

-- ----------------------------
-- Records of user
-- ----------------------------

-- ----------------------------
-- Table structure for `user_server`
-- ----------------------------
DROP TABLE IF EXISTS `user_server`;
CREATE TABLE `user_server` (
  `role_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '角色id',
  `c_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '大渠道id',
  `c_son_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '子渠道id',
  `user_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT 'user表id,账号的唯一标识',
  `sid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '区服务器id',
  `role_name` varchar(100) NOT NULL DEFAULT '' COMMENT '角色名',
  `fighting` int(11) NOT NULL DEFAULT '0' COMMENT '战斗力',
  `gem` bigint(11) NOT NULL DEFAULT '0' COMMENT '持有钻石',
  `vip` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT 'vip等级',
  `level` smallint(1) unsigned NOT NULL DEFAULT '0' COMMENT '等级',
  `today_online_time` int(11) NOT NULL DEFAULT '0' COMMENT '当天在线时长，单位秒',
  `online_time` int(11) NOT NULL DEFAULT '0' COMMENT '累计在线时长，单位秒',
  `total_recharge` int(11) NOT NULL DEFAULT '0' COMMENT '累计充值金额分',
  `invite_rid` bigint(20) NOT NULL DEFAULT '0' COMMENT '邀请人id',
  `last_update_time` int(11) NOT NULL DEFAULT '0' COMMENT '最后修改时间',
  `head_id` int(11) unsigned zerofill NOT NULL DEFAULT '00000000000' COMMENT '头像id',
  `border_id` int(11) NOT NULL DEFAULT '0' COMMENT '头像框id',
  `forbid_end_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '封号结束时间',
  `shutup_end_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '禁言结束时间',
  `created_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`role_id`),
  KEY `user_id` (`user_id`) USING BTREE,
  KEY `sid` (`sid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='玩家角色区服表';

-- ----------------------------
-- Records of user_server
-- ----------------------------

-- ----------------------------
-- Table structure for `white_list`
-- ----------------------------
DROP TABLE IF EXISTS `white_list`;
CREATE TABLE `white_list` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `uid` varchar(128) NOT NULL DEFAULT '' COMMENT '平台用户uid',
  `ip` varchar(15) NOT NULL DEFAULT '' COMMENT 'ip',
  `note` varchar(250) NOT NULL DEFAULT '' COMMENT '备注',
  `status` tinyint(1) DEFAULT '0' COMMENT '是否有效：0.已删除，1.正常',
  `created_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20000001 DEFAULT CHARSET=utf8 COMMENT='白名单列表';

-- ----------------------------
-- Records of white_list
-- ----------------------------
DROP TABLE IF EXISTS `recharge`;
CREATE TABLE `recharge` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `game_order_id` varchar(100) NOT NULL COMMENT '游戏订单号',
  `sdk_order_id` varchar(100) DEFAULT NULL COMMENT 'SDK单号订',
  `open_id` varchar(128) NOT NULL DEFAULT '' COMMENT '渠道用户id，就是玩家的登录账号',
  `role_id` bigint(20) DEFAULT NULL COMMENT '角色ID',
  `level` smallint(1) unsigned NOT NULL DEFAULT '0' COMMENT '等级',
  `vip` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT 'vip等级',
  `sid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '区服务器id',
  `ip` varchar(50) NOT NULL DEFAULT '' COMMENT 'ip',
  `goods_id` varchar(50) DEFAULT '0' COMMENT '商品ID',
  `pay_type` tinyint(1) DEFAULT '1' COMMENT '支付类型：1.内购，2.第三方支付（支付宝，微信等）',
  `money` DECIMAL(10,2) NOT NULL DEFAULT '0.00' COMMENT '充值的金额',
  `status` tinyint(4) DEFAULT '0' COMMENT '0.未支付，1.支付成功，2.支付失败，3.发货成功，4.发货失败，-11.重复订单',
  `is_test` tinyint(4) DEFAULT '0' COMMENT '是否是测试充值，0不是，1是',
  `extraInfo` varchar(200) DEFAULT '' COMMENT '额外参数',
  `server_status` int(11) DEFAULT '0' COMMENT '是否发送到服务器了 1发到了',
  `debug` varchar(100) DEFAULT '' COMMENT '发货的返回值',
  `request_url` text COMMENT '发货的完整请求',
  `device_type` tinyint(1) NOT NULL DEFAULT '3' COMMENT '充值的设备类型：1-pc、2-ios、3-android',
  `pay_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '支付时间',
  `updated_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '修改时间',
  `created_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2000000001 DEFAULT CHARSET=utf8 COMMENT='玩家充值列表';



DROP TABLE IF EXISTS `virtual_recharge`;
CREATE TABLE `virtual_recharge` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `product_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '商品ID',
  `role_id` text COMMENT '角色ID集合',
  `sid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '区服务器id',
  `debug` varchar(255) NOT NULL DEFAULT '' COMMENT '审核结果',
  `status` tinyint(1) DEFAULT '0' COMMENT '模拟充值的状态：0.待审批，1.充值成功，2.充值失败，3.审核不通过',
  `note` varchar(255) NOT NULL DEFAULT '' COMMENT '备注',
  `created_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2000000001 DEFAULT CHARSET=utf8 COMMENT='模拟充值列表';



DROP TABLE IF EXISTS `product`;
CREATE TABLE `product` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '商品ID',
  `product_name` varchar(200) DEFAULT '0' COMMENT '商品名称',
  `goods_id` varchar(50) DEFAULT '0' COMMENT '商品code',
  `three_product_id` varchar(50) NOT NULL DEFAULT '' COMMENT '第三方商品id',
  `product_type` tinyint(1) DEFAULT '0' COMMENT '商品类型：1 钻石充值，2成长基金，3月度投资，4星级养成礼，5每周福利，6每日限购（vip），7超值礼包，8特权礼包，9每月福利，10每日礼包（全民），11新服限购，12等级养成礼，13关卡养成礼，14中秋礼包，15狂欢时刻，16节日礼包，17通行证活动，18限时抢购，19首充，20召唤祈愿特权',
  `money` DECIMAL(10,2) NOT NULL DEFAULT '0.00' COMMENT '商品金额',
  `dollar_money` DECIMAL(10,2) NOT NULL DEFAULT '0.00' COMMENT '商品美金金额',
  `created_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2000000001 DEFAULT CHARSET=utf8 COMMENT='商品列表';



DROP TABLE IF EXISTS `recharge_callback`;
CREATE TABLE `recharge_callback` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `route` varchar(100) NOT NULL DEFAULT '' COMMENT '请求地址',
  `ip` varchar(50) NOT NULL DEFAULT '' COMMENT 'ip',
  `debug` varchar(100) NOT NULL DEFAULT '' COMMENT '返回值',
  `callback_str` text COMMENT '回调参数',
  `created_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2000000001 DEFAULT CHARSET=utf8 COMMENT='订单回调日志';


DROP TABLE IF EXISTS `recharge_log`;
CREATE TABLE `recharge_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `recharge_id` bigint(20) unsigned NOT NULL COMMENT '主键id',
  `game_order_id` varchar(100) NOT NULL COMMENT '游戏订单号',
  `sdk_order_id` varchar(100) DEFAULT NULL COMMENT 'SDK单号订',
  `open_id` varchar(128) NOT NULL DEFAULT '' COMMENT '渠道用户id，就是玩家的登录账号',
  `role_id` bigint(20) DEFAULT NULL COMMENT '角色ID',
  `sid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '区服务器id',
  `ip` varchar(50) NOT NULL DEFAULT '' COMMENT 'ip',
  `goods_id` varchar(50) DEFAULT '0' COMMENT '商品ID',
  `pay_type` tinyint(1) DEFAULT '1' COMMENT '支付类型：1.内购，2.第三方支付（支付宝，微信等）',
  `money` DECIMAL(10,2) NOT NULL DEFAULT '0.00' COMMENT '充值的金额',
  `status` tinyint(4) DEFAULT '0' COMMENT '0.未支付，1.支付成功，2.支付失败，3.发货成功，4.发货失败，-11.重复订单',
  `is_test` tinyint(4) DEFAULT '0' COMMENT '是否是测试充值，0不是，1是',
  `operate_type` tinyint(1) DEFAULT '1' COMMENT '日志类型：1.回调，2.补单',
  `extraInfo` varchar(200) DEFAULT '' COMMENT '额外参数',
  `server_status` int(11) DEFAULT '0' COMMENT '是否发送到服务器了 1发到了',
  `debug` varchar(100) DEFAULT '' COMMENT '发货的返回值',
  `request_url` text COMMENT '发货的完整请求',
  `device_type` tinyint(1) NOT NULL DEFAULT '3' COMMENT '充值的设备类型：1-pc、2-ios、3-android',
  `pay_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '支付时间',
  `created_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2000000001 DEFAULT CHARSET=utf8 COMMENT='玩家充值流水';


DROP TABLE IF EXISTS `big_server`;
CREATE TABLE `big_server` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '大区名称',
  `sort` varchar(200) NOT NULL DEFAULT '0' COMMENT '排序sort',
  `c_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '大渠道id',
  `c_son_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '子渠道id',
  `created_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20000001 DEFAULT CHARSET=utf8 COMMENT='大区列表';


DROP TABLE IF EXISTS `chat_forbid_log`;
CREATE TABLE `chat_forbid_log` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `rids` varchar(50) NOT NULL DEFAULT '' COMMENT '封号禁言的角色id集合，多个用英文逗号隔开',
  `forbid_end_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '封号结束时间',
  `shutup_end_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '禁言结束时间',
  `admin_id` int(11) NOT NULL DEFAULT '0' COMMENT '管理员id',
  `created_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20000001 DEFAULT CHARSET=utf8 COMMENT='封号禁言日志';


DROP TABLE IF EXISTS `role_replace_log`;
CREATE TABLE `role_replace_log` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `one_role_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT 'A角色id',
  `two_role_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT 'B角色id',
  `admin_id` int(11) NOT NULL DEFAULT '0' COMMENT '管理员id',
  `created_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20000001 DEFAULT CHARSET=utf8 COMMENT='互换角色日志';


DROP TABLE IF EXISTS `request_log`;
CREATE TABLE `request_log` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `url` varchar(255) NOT NULL DEFAULT '' COMMENT '请求路由',
  `url_name` varchar(255) NOT NULL DEFAULT '' COMMENT '请求路由名称',
  `params` text COMMENT '请求参数',
  `admin_id` int(11) NOT NULL DEFAULT '0' COMMENT '管理员id',
  `admin_name` varchar(150) NOT NULL DEFAULT '0' COMMENT '管理员名称',
  `created_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2000000001 DEFAULT CHARSET=utf8 COMMENT='请求日志';


DROP TABLE IF EXISTS `sensitive_word`;
CREATE TABLE `sensitive_word` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `sensitive_word` varchar(100) NOT NULL DEFAULT '' COMMENT '敏感词，包括正则符号',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '状态，0.失效，1.有效',
  `admin_id` int(11) NOT NULL DEFAULT '0' COMMENT '管理员id',
  `admin_name` varchar(150) NOT NULL DEFAULT '0' COMMENT '管理员名称',
  `created_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20000001 DEFAULT CHARSET=utf8 COMMENT='聊天敏感词列表';


DROP TABLE IF EXISTS `send_sensitive_word`;
CREATE TABLE `send_sensitive_word` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `sensitive_words` text COMMENT '发送敏感词集',
  `sid` varchar(255) NOT NULL DEFAULT '' COMMENT '要发送的服务器，多个用英文逗号隔开',
  `debug` text COMMENT '发送的结果',
  `admin_id` int(11) NOT NULL DEFAULT '0' COMMENT '管理员id',
  `admin_name` varchar(150) NOT NULL DEFAULT '' COMMENT '管理员名称',
  `created_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20000001 DEFAULT CHARSET=utf8 COMMENT='发送聊天敏感词列表';


DROP TABLE IF EXISTS `clan_skill_config`;
CREATE TABLE `clan_skill_config` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '加成id',
  `occupation` tinyint(1) NOT NULL DEFAULT '1' COMMENT '职业id',
  `ability` int(11) NOT NULL DEFAULT '0' COMMENT '公会科技加成类型',
  `name` varchar(150) NOT NULL DEFAULT '' COMMENT '加成名称',
  `num` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '加成数值',
  `created_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8 COMMENT='公会科技配置表';

INSERT INTO `clan_skill_config` VALUES ('1', '1', '1', '102', '生命', '30', '1589105421');
INSERT INTO `clan_skill_config` VALUES ('2', '2', '1', '201', '攻击', '30', '1589105421');
INSERT INTO `clan_skill_config` VALUES ('3', '3', '1', '207', '暴击', '30', '1589105421');
INSERT INTO `clan_skill_config` VALUES ('4', '4', '1', '222', '暴击伤害', '60', '1589105421');
INSERT INTO `clan_skill_config` VALUES ('5', '5', '1', '101', '速度', '3', '1589105421');
INSERT INTO `clan_skill_config` VALUES ('6', '6', '1', '270', '最终伤害增加', '30', '1589105421');
INSERT INTO `clan_skill_config` VALUES ('7', '1', '2', '102', '生命', '30', '1589105421');
INSERT INTO `clan_skill_config` VALUES ('8', '2', '2', '201', '攻击', '30', '1589105421');
INSERT INTO `clan_skill_config` VALUES ('9', '3', '2', '207', '暴击', '30', '1589105421');
INSERT INTO `clan_skill_config` VALUES ('10', '4', '2', '222', '暴击伤害', '60', '1589105421');
INSERT INTO `clan_skill_config` VALUES ('11', '5', '2', '101', '速度', '3', '1589105421');
INSERT INTO `clan_skill_config` VALUES ('12', '6', '2', '270', '最终伤害增加', '30', '1589105421');
INSERT INTO `clan_skill_config` VALUES ('13', '1', '3', '102', '生命', '30', '1589105421');
INSERT INTO `clan_skill_config` VALUES ('14', '2', '3', '201', '攻击', '30', '1589105421');
INSERT INTO `clan_skill_config` VALUES ('15', '3', '3', '212', '免控', '30', '1589105421');
INSERT INTO `clan_skill_config` VALUES ('16', '4', '3', '208', '抗暴', '30', '1589105421');
INSERT INTO `clan_skill_config` VALUES ('17', '5', '3', '101', '速度', '3', '1589105421');
INSERT INTO `clan_skill_config` VALUES ('18', '6', '3', '291', '伤害减免', '30', '1589105421');
INSERT INTO `clan_skill_config` VALUES ('19', '1', '4', '102', '生命', '30', '1589105421');
INSERT INTO `clan_skill_config` VALUES ('20', '2', '4', '201', '攻击', '30', '1589105421');
INSERT INTO `clan_skill_config` VALUES ('21', '3', '4', '219', '增空', '30', '1589105421');
INSERT INTO `clan_skill_config` VALUES ('22', '4', '4', '208', '抗暴', '30', '1589105421');
INSERT INTO `clan_skill_config` VALUES ('23', '5', '4', '101', '速度', '3', '1589105421');
INSERT INTO `clan_skill_config` VALUES ('24', '6', '4', '212', '免控', '30', '1589105421');

DROP TABLE IF EXISTS `astrolabe_star`;
CREATE TABLE `astrolabe_star` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `star` int(11) NOT NULL DEFAULT '0' COMMENT '星盘星级',
  `created_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8 COMMENT='星盘对应星级表';

-- ----------------------------
-- Records of astrolabe_star
-- ----------------------------
INSERT INTO `astrolabe_star` VALUES ('1', '25', '1589169469');
INSERT INTO `astrolabe_star` VALUES ('2', '27', '1589169469');
INSERT INTO `astrolabe_star` VALUES ('3', '29', '1589169469');
INSERT INTO `astrolabe_star` VALUES ('4', '31', '1589169469');
INSERT INTO `astrolabe_star` VALUES ('5', '33', '1589169469');
INSERT INTO `astrolabe_star` VALUES ('6', '35', '1589169469');
INSERT INTO `astrolabe_star` VALUES ('7', '37', '1589169469');
INSERT INTO `astrolabe_star` VALUES ('8', '39', '1589169469');
INSERT INTO `astrolabe_star` VALUES ('9', '42', '1589169469');
INSERT INTO `astrolabe_star` VALUES ('10', '45', '1589169469');
INSERT INTO `astrolabe_star` VALUES ('11', '48', '1589169469');
INSERT INTO `astrolabe_star` VALUES ('12', '51', '1589169469');
INSERT INTO `astrolabe_star` VALUES ('13', '54', '1589169469');
INSERT INTO `astrolabe_star` VALUES ('14', '57', '1589169469');
INSERT INTO `astrolabe_star` VALUES ('15', '60', '1589169469');


DROP TABLE IF EXISTS `astrolabe_skill`;
CREATE TABLE `astrolabe_skill` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `name` varchar(150) NOT NULL DEFAULT '' COMMENT '技能名称',
  `created_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8 COMMENT='星盘对应技能表';

-- ----------------------------
-- Records of astrolabe_skill
-- ----------------------------
INSERT INTO `astrolabe_skill` VALUES ('1', '火属性暴击率增加', '1589169482');
INSERT INTO `astrolabe_skill` VALUES ('2', '水属性暴击率增加', '1589169482');
INSERT INTO `astrolabe_skill` VALUES ('3', '木属性暴击率增加', '1589169482');
INSERT INTO `astrolabe_skill` VALUES ('4', '光属性暴击率增加', '1589169482');
INSERT INTO `astrolabe_skill` VALUES ('5', '暗属性暴击率增加', '1589169482');
INSERT INTO `astrolabe_skill` VALUES ('6', '火属性暴击伤害增加', '1589169482');
INSERT INTO `astrolabe_skill` VALUES ('7', '水属性暴击伤害增加', '1589169482');
INSERT INTO `astrolabe_skill` VALUES ('8', '木属性暴击伤害增加', '1589169482');
INSERT INTO `astrolabe_skill` VALUES ('9', '光属性暴击伤害增加', '1589169482');
INSERT INTO `astrolabe_skill` VALUES ('10', '暗属性暴击伤害增加', '1589169482');
INSERT INTO `astrolabe_skill` VALUES ('11', '火属性成长率增加', '1589169482');
INSERT INTO `astrolabe_skill` VALUES ('12', '水属性成长率增加', '1589169482');
INSERT INTO `astrolabe_skill` VALUES ('13', '木属性成长率增加', '1589169482');
INSERT INTO `astrolabe_skill` VALUES ('14', '光属性成长率增加', '1589169482');
INSERT INTO `astrolabe_skill` VALUES ('15', '暗属性成长率增加', '1589169482');


DROP TABLE IF EXISTS `game_event`;
CREATE TABLE `game_event` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '流水事件名称',
  `created_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2000001 DEFAULT CHARSET=utf8 COMMENT='流水事件配置表';

DROP TABLE IF EXISTS `hero`;
CREATE TABLE `hero` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '英雄名称',
  `elem` int(11) NOT NULL DEFAULT '0' COMMENT '英雄元素',
  `occupation` int(11) NOT NULL DEFAULT '0' COMMENT '英雄职业',
  `created_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2000001 DEFAULT CHARSET=utf8 COMMENT='英雄表';

DROP TABLE IF EXISTS `city`;
CREATE TABLE `city` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `pid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '上级ID',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '名称',
  `created_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1000001 DEFAULT CHARSET=utf8 COMMENT='城市表';

DROP TABLE IF EXISTS `channel_version`;
CREATE TABLE `channel_version` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `c_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '大渠道ID',
  `c_son_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '小渠道ID',
  `package_version` varchar(50) NOT NULL DEFAULT '' COMMENT '包版本',
  `version` varchar(50) NOT NULL DEFAULT '' COMMENT '资源版本',
  `is_past` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否已过审（过审标记）',
  `updated_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '修改时间',
  `created_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2000001 DEFAULT CHARSET=utf8 COMMENT='渠道版本表';



DROP TABLE IF EXISTS `group`;
CREATE TABLE `group` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '分组ID',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '分组名称',
  `is_new` tinyint(3) NOT NULL DEFAULT '0' COMMENT '是否是新服',
  `created_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20001 DEFAULT CHARSET=utf8 COMMENT='分组表';


DROP TABLE IF EXISTS `group_server`;
CREATE TABLE `group_server` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `sid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '服务器ID',
  `group_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '分组ID',
  `updated_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '修改时间',
  `created_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_sid` (`sid`,`group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=200001 DEFAULT CHARSET=utf8 COMMENT='区服分组关联表';


-- ----------------------------
-- Table structure for `mail_template`
-- ----------------------------
DROP TABLE IF EXISTS `do_special_sql`;
CREATE TABLE `do_special_sql` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `sid` text COMMENT '区服集合，多个用英文逗号隔开',
  `name` varchar(20) NOT NULL DEFAULT '' COMMENT '执行sql的数据库的后缀，data或者log',
  `sql` text COMMENT 'sql语句',
  `type` tinyint(3) NOT NULL DEFAULT '1' COMMENT '类型：1.查询，2.导出',
  `admin_id` int(11) NOT NULL DEFAULT '0' COMMENT '管理员id',
  `updated_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '修改时间',
  `created_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2000001 DEFAULT CHARSET=utf8 COMMENT='执行特殊sql';



DROP TABLE IF EXISTS `cost_recharge`;
CREATE TABLE `cost_recharge` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `sid` int(11) NOT NULL DEFAULT '0' COMMENT '区服ID',
  `role_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '角色ID',
  `total` int(11) NOT NULL DEFAULT '0' COMMENT '总值',
  `week` int(11) NOT NULL DEFAULT '0' COMMENT '周值',
  `daily` int(11) NOT NULL DEFAULT '0' COMMENT '日值',
  `debug` varchar(150) DEFAULT '' COMMENT '返回值',
  `request_url` text COMMENT '完整请求',
  `created_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2000001 DEFAULT CHARSET=utf8 COMMENT='扣除充值列表';


DROP TABLE IF EXISTS `cost_item`;
CREATE TABLE `cost_item` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `sid` int(11) NOT NULL DEFAULT '0' COMMENT '区服ID',
  `role_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '角色ID',
  `item` text COMMENT '道具json数据',
  `debug` varchar(150) DEFAULT '' COMMENT '返回值',
  `request_url` text COMMENT '完整请求',
  `created_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2000001 DEFAULT CHARSET=utf8 COMMENT='扣除道具列表';


DROP TABLE IF EXISTS `global_config`;
CREATE TABLE `global_config` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `role_nums_limit` int(11) NOT NULL DEFAULT '0' COMMENT '服务器创角阈值，做警告提示',
  `created_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2000001 DEFAULT CHARSET=utf8 COMMENT='全局配置列表';


DROP TABLE IF EXISTS `special_route`;
CREATE TABLE `global_config` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `route` varchar(150) NOT NULL DEFAULT '' COMMENT '请求路径',
  `param` text COMMENT '请求参数',
  `created_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10001 DEFAULT CHARSET=utf8 COMMENT='游戏特殊请求路径列表';


DROP TABLE IF EXISTS `mailbox_log`;
CREATE TABLE `mailbox_log` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `to_mail` varchar(150) NOT NULL DEFAULT '' COMMENT '邮件接收人邮箱',
  `mail_title` varchar(255) NOT NULL DEFAULT '' COMMENT '邮件标题',
  `mail_content` text COMMENT '邮件内容',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否发送成功：0.失败，1.成功',
  `created_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '发送时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1000001 DEFAULT CHARSET=utf8 COMMENT='发送邮件记录';


DROP TABLE IF EXISTS `attribute`;
CREATE TABLE `attribute` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '属性id',
  `name` varchar(150) NOT NULL DEFAULT '' COMMENT '属性名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=100001 DEFAULT CHARSET=utf8 COMMENT='属性表';


DROP TABLE IF EXISTS `dragon_level`;
CREATE TABLE `dragon_level` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `level` smallint(1) unsigned NOT NULL DEFAULT '0' COMMENT '等级',
  `grade` tinyint(1) NOT NULL DEFAULT '0' COMMENT '阶级',
  `attribute` varchar(255) NOT NULL DEFAULT '' COMMENT '属性',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=100001 DEFAULT CHARSET=utf8 COMMENT='圣龙等级属性表';


DROP TABLE IF EXISTS `holy_things`;
CREATE TABLE `holy_things` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '圣物id',
  `star` tinyint(1) NOT NULL DEFAULT '0' COMMENT '星级',
  `quality` tinyint(1) NOT NULL DEFAULT '0' COMMENT '品质：1.稀有，2.极品，3.普通',
  `skill` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '技能',
  `attribute` varchar(255) NOT NULL DEFAULT '' COMMENT '属性',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=100001 DEFAULT CHARSET=utf8 COMMENT='圣物属性表';