package com.ayjs.mxzg.gameserver.module.backpack.decomposition;

import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.backpack.service.processor.ThingType;
import com.ayjs.mxzg.protocol.BackPackGMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * 普通道具分解
 *
 * @author hyx
 */
@Component
public class FashionDecomposition implements ThingDecomposition {

    @Autowired
    private ThingService thingService;

    @Override
    public ThingType getType() {
        return ThingType.FASHION;
    }

    @Override
    public void decomposition(long rid, BackPackGMsg.ResBackPackItem item, GameEvent gameEvent) {
        thingService.cost(rid, ImmutableThing.of(item.getItemType(), item.getNum()), gameEvent);
    }
}
