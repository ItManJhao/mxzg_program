package com.ayjs.mxzg.repository.platform;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Getter;

/**
 * @Author: CWJ
 * @Date: 2020/8/20
 **/
@Table(name = "server", autoCreate = false)
@Getter
public class Server extends AbstractEntity {
    @Id
    @Column(name = "id", comment = "服务器ID")
    private int id;
    @Column(name = "extranet_host", comment = "服务器外网地址")
    private String extranetHost;
    @Column(name = "intranet_host", comment = "内网地址")
    private String intranetHost;
    @Column(name = "parent_id", comment = "服务器id")
    private int parentId;
    //@Column(name="game_port",comment = "游戏端口")
//   @Column(name="http_port",comment = "HTTP端口")
//   @Column(name="server_name",comment = "服务器名称")
//   @Column(name="note",comment = "服务器备注")
//   @Column(name="is_new",comment ="是否是新服，0.否，1.是")
//   @Column(name="type",comment = "服务器类型：0.正式服，1.测试服，2.审核服")
//   @Column(name="status",comment = "分区状态：0未开放，1爆满，2流畅")
//   @Column(name="defend_end_time",comment = "维护时间，唯一用来判断是否是维护状态的字段")
//   @Column(name="open_time",comment = "开服时间")
//   @Column(name="heart_beat_time",comment = "服务器的心跳时间")
    @Column(name = "db_host", comment = "数据库地址")
    private String dbHost;
    @Column(name = "db_port", comment = "数据库端口")
    private int dbPort;
    @Column(name = "db_user", comment = "数据库用户名")
    private String dbUser;
    @Column(name = "db_password", comment = "数据库密码")
    private String dbPassword;
//   @Column(name="msg",comment = "服务器提示信息")

    @Column(name = "db_game_database", comment = "游戏数据库名")
    private String dbGameDatabase;
    @Column(name = "db_log_database", comment = "日志数据库名")
    private String dbLogDatabase;
//   @Column(name="role_nums",comment = "注册数")
//   @Column(name="role_nums_limit",comment = "注册阈值")
//   @Column(name="group_id",comment = "分组，默认是1组")
//   @Column(name="created_at",comment = "创建时间")
//   @Column(name="updated_at",comment = "修改时间")

}
