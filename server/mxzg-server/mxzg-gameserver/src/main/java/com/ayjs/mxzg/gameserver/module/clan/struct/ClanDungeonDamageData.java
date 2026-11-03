package com.ayjs.mxzg.gameserver.module.clan.struct;

import lombok.Data;

/**
 * 公会副本伤害实体类
 */
@Data
public class ClanDungeonDamageData {

    private long rid;

    private long bossHp;

    private int rank;

}
