package com.ayjs.mxzg.cross.module.crusadegroup.group.event;

import lombok.Value;

/**
 * 最终boss伤害(讨伐团)
 */
@Value(staticConstructor = "of")
public class BossHurtChangeEvent {
    private int cgId;//讨伐团id

    private long nowHurt;//当前伤害

}
