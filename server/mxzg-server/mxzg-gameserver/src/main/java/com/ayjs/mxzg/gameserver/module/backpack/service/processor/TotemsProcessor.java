package com.ayjs.mxzg.gameserver.module.backpack.service.processor;


import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.config.excel.cache.totems.TotemsLevelSysCache;
import com.ayjs.mxzg.config.excel.cache.totems.TotemsSysCache;
import com.ayjs.mxzg.config.excel.entity.totems.CTotems;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.module.backpack.service.Rewards;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingProcessor;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingSet;
import com.ayjs.mxzg.gameserver.module.totems.domain.Totems;
import com.ayjs.mxzg.gameserver.module.totems.event.TotemsAddEvent;
import com.ayjs.mxzg.gameserver.module.totems.service.TotemsService;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

@Component
public class TotemsProcessor implements ThingProcessor {

    @Autowired
    private TotemsService totemsService;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private TotemsSysCache totemsSysCache;
    @Autowired
    private TotemsLevelSysCache totemsLevelSysCache;

    @Override
    public ThingType thingType() {
        return ThingType.TOTEMS;
    }

    @Override
    public ErrorCode notEnoughCode() {
        throw new UnsupportedOperationException("不能扣除图腾");
    }

    @Override
    public long getCount(long rid, int thingType) {
        throw new UnsupportedOperationException("不能扣除图腾");
    }

    @Override
    public ThingSet prepareCost(long rid, ThingSet thingSet, GameEvent gameEvent) {
        throw new UnsupportedOperationException("不能扣除图腾");
    }

    @Override
    public void cost(long rid, ThingSet thingSet, GameEvent gameEvent) {
        throw new UnsupportedOperationException("不能扣除图腾");
    }


    @Override
    public Rewards add(long rid, ThingSet thingSet, GameEvent gameEvent) {
        List<Totems> totemsList = new ArrayList<>();
        //判断该类型图腾是否已经获取，如果获取，仅且只能有一个
        for (ImmutableThing immutableThing : thingSet.asList()) {
//            CTotems cTotems = petSysCache.getOrThrow(immutableThing.getItem_type());
            int totems_id = immutableThing.getItem_type();
            Totems oldTotems = totemsService.getTotems_byTotemsId(rid, totems_id);
            if (oldTotems != null) {//該圖騰已經存在
                continue;
            }
            //先检查是否存在该类型图腾
            Totems totems = new Totems();
            totems.setHeroId(0);
            totems.setLevel(1);//默认1级
            totems.setQuality(1);//默认1阶
            totems.setTotems_id(totems_id);
            totems.setRid(rid);
            totemsService.addTotems(totems);
            totemsList.add(totems);
        }
        if (!totemsList.isEmpty()) {
            eventBus.post(TotemsAddEvent.of(rid, totemsList, gameEvent));
        }
        return Rewards.of(thingSet);
    }
}
