package com.ayjs.mxzg.gameserver.module.dungeon.event;

import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Value;

/**
 * 庇护所商店购买
 * @author hyx
 */
@Value(staticConstructor = "of")
public class DungeonShopEvent {

    private long rid;

    private int idx;

    private ImmutableList<ImmutableThing> item_cost;

    private ImmutableList<ImmutableThing> item_add;


}
