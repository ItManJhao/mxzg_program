package com.ayjs.mxzg.gameserver.module.backpack.use;

import com.ayjs.mxzg.config.excel.entity.CItem;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.module.backpack.service.Rewards;

/**
 * 物品使用接口
 */
public interface ThingUse {

    ThingUseType getType();

    /**
     * 使用物品
     */
    Rewards use(long rid, CItem cItem, int num, GameEvent event);
}
