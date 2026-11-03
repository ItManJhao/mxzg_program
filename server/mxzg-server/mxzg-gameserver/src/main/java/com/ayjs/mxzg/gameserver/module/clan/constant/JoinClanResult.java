package com.ayjs.mxzg.gameserver.module.clan.constant;

/**
 * 申请加入公会验证结果
 */
public enum JoinClanResult {

    //0：验证通过 2：已加入公会 3:公会人数已满

    VERIFYING_PASS(0),

    CLAN_NOW_JOIN(2),

    CLAN_MEMBER_MAX(3);

    private int type;

    JoinClanResult(int type) {
        this.type = type;
    }

    public int getType() {
        return type;
    }
}

