package com.ayjs.mxzg.gameserver.module.chat.constant;

import java.util.HashMap;
import java.util.Map;

/**
 * @description:
 * @author: CWJ
 * @date: 2019/10/12 18:01
 */
public enum ChatType {
    /**
     * 系统消息(1)
     */
    SYSTEM(1, false, false, false, 0),
    /**
     * 世界聊天(2)
     */
    WORLD(2, true, true, true, 908),
    /**
     * 军团聊天(3)
     */
    CLAN(3, true, true, true, 909),
//    /**
//     * 喇叭(4)
//     */
//    HORN(4),
    /**
     * 私聊(5)
     */
    PRIVATE_CHAT(5, false, false, false, 0),
    /**
     * 跨服(6)
     */
    CROSS_CHAT(6, true, true, true, 907),
    /**
     * 同省(7)
     */
    PROVINCE_CHAT(7, false, false, false, 0),
    /**
     * 讨伐团跨服(8)
     */
    CROSS_CRUGROUP_CHAT(8, false, false, true, 910),
    /**
     * 国战聊天
     */
    COUNTRY_WAR(9, false, true, false, 0),
    ;

    private final int value;
    private final boolean shareHero;
    private final boolean shareBattle;
    private final boolean shareSeason;
    //至尊段位赛对应的分享公告id
    private final int seasonNoticeIdx;
    /**
     * 缓存map
     */
    private static Map<Integer, ChatType> chatTypeMap = new HashMap<>();

    static {
        for (ChatType chatType : ChatType.values()) {
            chatTypeMap.put(chatType.getValue(), chatType);
        }
    }

    private ChatType(int value, boolean shareHero, boolean shareBattle, boolean shareSeason, int seasonNoticeIdx) {
        this.value = value;
        this.shareHero = shareHero;
        this.shareBattle = shareBattle;
        this.shareSeason = shareSeason;
        this.seasonNoticeIdx = seasonNoticeIdx;
    }

    /**
     * 获取值
     *
     * @return
     */
    public int getValue() {
        return this.value;
    }

    public int getSeasonNoticeIdx() {
        return seasonNoticeIdx;
    }


    /**
     * 根据聊天类型id获取聊天类型对象
     *
     * @param typeId 聊天类型
     * @return
     * @author ruan 2013-2-17
     */
    public final static ChatType valueOf(int typeId) {
        return chatTypeMap.get(typeId);
    }

    public boolean isShareHero() {
        return shareHero;
    }

    public boolean isShareBattle() {
        return shareBattle;
    }

    public boolean isShareSeason() {
        return shareSeason;
    }
}
