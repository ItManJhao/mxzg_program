package com.ayjs.mxzg.gameserver.module.hero.event;

import com.ayjs.mxzg.config.struct.GameEvent;
import lombok.Value;

/**
 * 皮肤激活事件
 * @author hyx
 */
@Value(staticConstructor = "of")
public class FashionActiveEvent {

    public long rid;

    /**
     * 皮肤id
     */
    public int fashionId;

    /**
     * 激活途径 0为永久激活，1为期限激活
     */
    public int status;

    public GameEvent gameEvent;

}
