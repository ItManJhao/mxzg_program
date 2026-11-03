package com.ayjs.mxzg.gameserver.web.support;

import lombok.Getter;
import lombok.Setter;

/**
 * @Author: CWJ
 * @Date: 2020/2/16
 **/
@Getter
@Setter
public class ChatData {

    /**
     * 服务器id
     */
    private int serverId;
    /**
     * 玩家rid
     */
    private long rid;
    /**
     * 玩家名字
     */
    private String name;
    /**
     * 聊天内容
     */
    private String context;
    /**
     * 聊天时间
     */
    private int time;

    /**
     * 频道id
     * * 世界聊天(2)
     * * 军团聊天(3)
     * * 跨服(6)
     * * 同省(7)
     */
    private int chatType;

    private long clanId;

    private String clanName;

    private String province;
}
