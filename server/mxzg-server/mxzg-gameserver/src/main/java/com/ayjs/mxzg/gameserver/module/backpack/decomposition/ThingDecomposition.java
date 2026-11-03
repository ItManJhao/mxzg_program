package com.ayjs.mxzg.gameserver.module.backpack.decomposition;

import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.module.backpack.service.processor.ThingType;
import com.ayjs.mxzg.protocol.BackPackGMsg;

/**
 * 道具分解
 *
 * @author hyx
 */
public interface ThingDecomposition {

    ThingType getType();

    void decomposition(long rid, BackPackGMsg.ResBackPackItem item, GameEvent gameEvent);

}
