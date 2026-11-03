package com.ayjs.mxzg.gameserver.module.clan.constant;

/**
 * 加锁从上往下加
 *
 * @Author: CWJ
 * @Date: 2019/11/9
 **/
public interface ClanLock {

    /**
     * 工会成员变化锁
     */
    String CLAN_CHANGE_LOCK = "CLAN_CHANGE_LOCK";

    /***
     * 工会捐献锁
     */
    String CLAN_DONATE_LOCK = "CLAN_DONATE_LOCK";

    /***
     * 工会副本锁
     */
    String CLAN_DUNGEON_LOCK = "CLAN_DUNGEON_LOCK";

    /***
     * 加经验锁
     */
    String CLAN_ADD_EXP_LOCK = "CLAN_ADD_EXP_LOCK";

    /**
     * 工会玩家锁
     */
    String CLAN_ROLE_LOCK = "CLAN_ROLE_LOCK";
}
