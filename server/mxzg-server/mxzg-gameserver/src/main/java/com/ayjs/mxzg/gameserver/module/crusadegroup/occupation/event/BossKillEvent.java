package com.ayjs.mxzg.gameserver.module.crusadegroup.occupation.event;

import lombok.Value;

/**
 * 讨伐团，最终boss击杀事件（此事件要在BossHurtEvent事件之后抛出）
 */
@Value(staticConstructor = "of")
public class BossKillEvent {
}
