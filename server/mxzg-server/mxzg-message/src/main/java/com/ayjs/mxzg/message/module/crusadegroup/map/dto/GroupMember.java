package com.ayjs.mxzg.message.module.crusadegroup.map.dto;

import lombok.Builder;
import lombok.Getter;

/**
 * 讨伐团成员
 */
@Getter
@Builder
public class GroupMember {

    private long rid; //角色id
    private int knighthoodId;   //爵位
    private String nick;   //昵称
    private String guild_name; //公会名称
    private int head_id; //头像id
    private int border_id; //头像框id
    private long fighting; //神兵精华
    private int last_offline_time;    //最后离线时间 0代表在线
    private int position;    //0 成员 1 指挥官 2团长
    private int level;  //等级
    private int serverId;   //服务器id

}
