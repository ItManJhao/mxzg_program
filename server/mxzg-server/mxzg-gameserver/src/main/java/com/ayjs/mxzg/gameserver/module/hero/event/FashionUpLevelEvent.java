package com.ayjs.mxzg.gameserver.module.hero.event;


import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import lombok.Value;

/**
 * 皮肤升级事件
 * @author hyx
 */
@Value(staticConstructor = "of")
public class FashionUpLevelEvent {

    private long rid;

    private int fashionId;

    private int level;

    private GameEvent gameEvent;

}
