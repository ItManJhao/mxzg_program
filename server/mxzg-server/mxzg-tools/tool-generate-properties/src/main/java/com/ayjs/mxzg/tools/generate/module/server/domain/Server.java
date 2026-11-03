package com.ayjs.mxzg.tools.generate.module.server.domain;

import lombok.Data;
import org.hibernate.annotations.Proxy;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "server")
@Data
@Proxy(lazy = false)
public class Server {
    /**
     * CREATE TABLE `server` (
     * `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '服务器ID',
     * `extranet_host` varchar(200) NOT NULL DEFAULT '' COMMENT '服务器外网地址',
     * `intranet_host` varchar(200) NOT NULL DEFAULT '' COMMENT '内网地址',
     * `game_port` int(11) NOT NULL DEFAULT '0' COMMENT '游戏端口',
     * `http_port` int(11) NOT NULL DEFAULT '0' COMMENT 'HTTP端口',
     * `server_name` varchar(200) NOT NULL DEFAULT '' COMMENT '服务器名称',
     * `note` text COMMENT '服务器备注',
     * `is_new` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否是新服，0.否，1.是',
     * `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '分区状态：0未开放，1爆满，2流畅，3维护',
     * `open_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '开服时间',
     * `defend_end_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '维护时间',
     * `db_host` varchar(100) NOT NULL DEFAULT '' COMMENT '数据库地址',
     * `db_port` int(11) NOT NULL DEFAULT '0' COMMENT '数据库端口',
     * `db_user` varchar(50) NOT NULL DEFAULT '' COMMENT '数据库用户名',
     * `db_password` varchar(50) NOT NULL DEFAULT '' COMMENT '数据库密码',
     * `msg` varchar(255) NOT NULL DEFAULT '' COMMENT '服务器提示信息',
     * `db_game_database` varchar(50) NOT NULL DEFAULT '' COMMENT '游戏数据库名',
     * `db_log_database` varchar(50) NOT NULL DEFAULT '' COMMENT '日志数据库名',
     * `created_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
     * `updated_at` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '修改时间',
     * PRIMARY KEY (`id`),
     * KEY `is_new` (`is_new`) USING BTREE,
     * KEY `status` (`status`) USING BTREE
     * ) ENGINE=InnoDB AUTO_INCREMENT=1014 DEFAULT CHARSET=utf8 COMMENT='区服务器表';
     */
    @Id
    @Column(name = "id")
    private Long id;
    @Column(name = "extranet_host")
    private String extranet_host;
    @Column(name = "intranet_host")
    private String intranet_host;
    @Column(name = "game_port")
    private int game_port;
    @Column(name = "http_port")
    private int http_port;
    @Column(name = "server_name")
    private String server_name;
    @Column(name = "note")
    private String note;
    @Column(name = "is_new")
    private int is_new;
    @Column(name = "status")
    private int status;
    @Column(name = "open_time")
    private int open_time;
    @Column(name = "defend_end_time")
    private int defend_end_time;
    @Column(name = "db_host")
    private String db_host;
    @Column(name = "db_port")
    private int db_port;
    @Column(name = "db_user")
    private String db_user;
    @Column(name = "db_password")
    private String db_password;
    @Column(name = "msg")
    private String msg;
    @Column(name = "db_game_database")
    private String db_game_database;
    @Column(name = "db_log_database")
    private String db_log_database;
    @Column(name = "created_at")
    private int created_at;
    @Column(name = "updated_at")
    private int updated_at;


}
