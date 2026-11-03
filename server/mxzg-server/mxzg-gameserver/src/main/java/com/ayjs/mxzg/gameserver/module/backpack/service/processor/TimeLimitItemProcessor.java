package com.ayjs.mxzg.gameserver.module.backpack.service.processor;

import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.TimeConstants;
import com.ayjs.mxzg.config.excel.cache.TimeLimitItemSysCache;
import com.ayjs.mxzg.config.excel.entity.CTimeLimitItem;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.module.backpack.service.Rewards;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingProcessor;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingSet;
import com.ayjs.mxzg.gameserver.module.timeLimitItem.domain.LimitItemInfo;
import com.ayjs.mxzg.gameserver.module.timeLimitItem.service.LimitItemInfoService;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

/**
 * 期限道具
 *
 * @author hyx
 */
@Component
public class TimeLimitItemProcessor implements ThingProcessor {

    @Autowired
    private TimeLimitItemSysCache timeLimitItemSysCache;
    @Autowired
    private LimitItemInfoService limitItemInfoService;

    @Override
    public ThingType thingType() {
        return ThingType.TIME_LIMIT_ITEM;
    }

    @Override
    public ErrorCode notEnoughCode() {
        throw new UnsupportedOperationException("不能扣除期限道具");
    }

    @Override
    public long getCount(long rid, int thingType) {
        throw new UnsupportedOperationException("不能扣除期限道具");
    }

    @Override
    public Rewards add(long rid, ThingSet thingSet, GameEvent gameEvent) {
        List<LimitItemInfo> list = new ArrayList<>();

        for (ImmutableThing reward : thingSet.asList()) {
            CTimeLimitItem cTimeLimitItem = timeLimitItemSysCache.getOrThrow(reward.getItem_type());
            for (int i = 0; i < reward.getItem_num(); i++) {
                LimitItemInfo limitItemInfo = new LimitItemInfo();
                limitItemInfo.setRid(rid);
                limitItemInfo.setType(cTimeLimitItem.getType());
                limitItemInfo.setItemType(cTimeLimitItem.getItem_id());
                limitItemInfo.setActiveTime(DateTimeUtil.currentSecond());
                int endTime = DateTimeUtil.theDayBreak(limitItemInfo.getActiveTime()) + cTimeLimitItem.getValid_time() * TimeConstants.ONE_DAY_SECOND - 1;
                limitItemInfo.setEndTime(endTime);
                list.add(limitItemInfo);
            }
        }

        limitItemInfoService.addList(list);
        return Rewards.of(thingSet);
    }

    @Override
    public ThingSet prepareCost(long rid, ThingSet thingSet, GameEvent gameEvent) {
        throw new UnsupportedOperationException("不能扣除期限道具");
    }

    @Override
    public void cost(long rid, ThingSet thingSet, GameEvent gameEvent) {
        throw new UnsupportedOperationException("不能扣除期限道具");
    }
}
