package com.ayjs.mxzg.gameserver.module.clan.constant;

/**
 * 公会创建验证结果
 */
public enum CreateClanResult {

     //0：验证通过 1：已加入公会 2：公会名字为空 3：公会名字含有违规字符 5:名字重复，6：宝石不够，7：充值额度不够

    VERIFYING_PASS(0),

    JOIN_CLAN(1),

    NULL_CLAN_NAME(2),

    ILLEGAL_STRING(3),

    REPETITION_CLAN_NAME(5),

    GEM(6),

    RECHARGE(7);


    private int type;

    CreateClanResult(int type) {
        this.type = type;
    }

    public int getType() {
        return type;
    }

}
