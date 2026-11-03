package com.ayjs.mxzg.gameserver.module.hero.event;

import com.ayjs.mxzg.config.struct.GameEvent;
import lombok.Value;

import java.util.List;

/**
 * 皮肤过期事件
 * @author hyx
 */
@Value(staticConstructor = "of")
public class FashionExpiresEvent {

    public long rid;

    public List<Integer> fashionList ;

    public GameEvent gameEvent;

}
