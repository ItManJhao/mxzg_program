package com.ayjs.mxzg.gameserver.module.crusadegroup.occupation.event;

import lombok.Value;

/**
 * 最终boss 玩家单场伤害
 */
@Value(staticConstructor = "of")
public class BossHurtEvent {
    private long rid;

    private long bossHurt;
}
