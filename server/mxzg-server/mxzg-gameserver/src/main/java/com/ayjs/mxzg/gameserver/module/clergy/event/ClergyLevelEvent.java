package com.ayjs.mxzg.gameserver.module.clergy.event;

import lombok.Value;

/**
 * 神职等级上升
 * @author hyx
 */
@Value(staticConstructor = "of")
public class ClergyLevelEvent {

    private long rid;

    private int newLevel;

}
