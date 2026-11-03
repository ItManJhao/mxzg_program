package com.ayjs.mxzg.message.module.chat.message;

import com.ayjs.mxzg.message.cross.CrossGroupMessage;
import lombok.Builder;
import lombok.Data;

import java.util.List;

/**
 * 跨服聊天消息
 */
@Data
@Builder
public class CrossChatMessage implements CrossGroupMessage {
    private int chatType; //聊天类型(1.系统2.世界3.军团,4.喇叭,5.私聊，6.跨服，7.同省)
    private long rid; //发送此聊天消息的玩家角色id(0为系统)
    private long clanId; //军团id(无军团为0)
    private int sendTime; //发送时间
    private int level; //玩家等级
    private int isVip; //是否VIP
    private int headId; //头像
    private String nick; //发送此聊天消息的玩家昵称(系统为空)
    private String clanName; //军团名称
    private String chatContent; //消息内容
    private int borderId; //头像框

    private int idx; //notice配置表ID
    private List<String> params; //参数
    private String province;// 省份
    private int cityId; // 城市id
    private int serverId;// 服务器id

    private int peerageLevel;//尊贵标识等级
}
