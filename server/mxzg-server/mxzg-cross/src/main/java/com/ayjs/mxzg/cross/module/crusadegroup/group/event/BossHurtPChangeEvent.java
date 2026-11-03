package com.ayjs.mxzg.cross.module.crusadegroup.group.event;

import lombok.Value;

/**
 * 最终boss伤害(玩家)
 */
@Value(staticConstructor = "of")
public class BossHurtPChangeEvent {
    private long rid;

    private long nowHurt;//当前伤害
    private int serverId;//服務器id
}
