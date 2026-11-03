package com.ayjs.mxzg.gameserver.module.chat.constant;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

/**
 *  聊天信息推送类
 * @author Rondo
 * @Date 2021-05-09 14:37:38
 */
@Getter
@Setter
public class ChatDto {
    // 区服
    private String server_id;
    // 用户账号
    private String qid;
    // 角色名
    private String name;
    // 消息类型 1 私聊；2 喇叭；3 邮件；4 世界；5 国家；6 工会/帮会；7 队伍；8 附近；9 其他
    private int type;
    // 消息内容
    private String content;
    // 用户ip地址
    private String ip;
    // 私聊对象账号，消息类型为1 私聊时，所私聊的账号(当帐号为其他平台帐号时为0)
    private String toqid;
    // 私聊对象昵称，消息类型为1 私聊时，所私聊的昵称
    private String toname;
    // 游戏方对应的唯一用户帐号
    private String third_qid;
    // 私聊对象游戏方对应的唯一账号，消息类型为1 私聊时，所私聊的游戏方对应的唯一账号
    private String third_toqid;
    // 生成时间
    private LocalDateTime time;

}
