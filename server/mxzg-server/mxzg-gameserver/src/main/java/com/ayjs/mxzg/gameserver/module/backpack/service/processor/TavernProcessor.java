package com.ayjs.mxzg.gameserver.module.backpack.service.processor;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.config.excel.cache.ChapterrewardSysCache;
import com.ayjs.mxzg.config.excel.entity.CChapterreward;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ItemType;
import com.ayjs.mxzg.gameserver.module.backpack.service.Rewards;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingProcessor;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingSet;
import com.ayjs.mxzg.gameserver.module.battle.domain.RoleMission;
import com.ayjs.mxzg.gameserver.module.battle.service.RoleMissionService;
import com.ayjs.mxzg.gameserver.module.task.domain.TavernInfo;
import com.ayjs.mxzg.gameserver.module.task.event.TavernAdventureEvent;
import com.ayjs.mxzg.gameserver.module.task.service.TavernInfoService;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.google.common.collect.Lists;

/**
 * 酒馆冒险点数
 *
 * @author hyx
 */
@Component
public class TavernProcessor implements ThingProcessor {

    @Autowired
    private TavernInfoService tavernInfoService;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private ChapterrewardSysCache chapterrewardSysCache;
    @Autowired
    private RoleMissionService roleMissionService;

    @Override
    public long getCount(long rid, int thingType) {
        return getCount(rid);
    }

    private long getCount(long rid) {
        TavernInfo tavernInfo = tavernInfoService.getTavernInfo(rid);
        return tavernInfo.getAdventureCount();
    }

    @Override
    public ThingType thingType() {
        return ThingType.TAVERN;
    }

    @Override
    public Rewards add(long rid, ThingSet thingSet, GameEvent gameEvent) {
        long totalReward = combine(thingSet);

        TavernInfo tavernInfo = tavernInfoService.getTavernInfo(rid);
        RoleMission roleMission = roleMissionService.getRoleMission(rid);
        CChapterreward config = null;
        if (roleMission.getChapterId() == 0) {
            config = chapterrewardSysCache.getOrThrow(1);
        } else {
            config = chapterrewardSysCache.getOrThrow(roleMission.getChapterId());
        }

        if (tavernInfo.getAdventureCount() + totalReward > config.getTavern_point_max()) {
            totalReward = config.getTavern_point_max() - tavernInfo.getAdventureCount();
        }

        if (totalReward > 0) {
            tavernInfo.setAdventureCount(tavernInfo.getAdventureCount() + totalReward);
            tavernInfoService.updateTavernInfo(tavernInfo);
            eventBus.post(TavernAdventureEvent.of(rid, totalReward, 0, tavernInfo.getAdventureCount(), gameEvent));
        }

        return Rewards.of(thingSet);
    }

    @Override
    public ThingSet prepareCost(long rid, ThingSet thingSet, GameEvent gameEvent) {
        long total = combine(thingSet);
        ThingProcessor.requireRemainCountGeZero(getCount(rid) - total, ItemType.IT_TAVERN_ADVENTURE, notEnoughCode());
        return total > 0L ? ThingSet.of(Lists.newArrayList(
                ImmutableThing.of(ItemType.IT_TAVERN_ADVENTURE, total))) : ThingSet.of();
    }

    @Override
    public void cost(long rid, ThingSet thingSet, GameEvent gameEvent) {
        long totalReward = combine(thingSet);
        TavernInfo tavernInfo = tavernInfoService.getTavernInfo(rid);
        tavernInfo.setAdventureCount(tavernInfo.getAdventureCount() - totalReward);
        tavernInfoService.updateTavernInfo(tavernInfo);

        eventBus.post(TavernAdventureEvent.of(rid, 0, totalReward, tavernInfo.getAdventureCount(), gameEvent));
    }

    @Override
    public ErrorCode notEnoughCode() {
        return ErrorCode.BAG_ADVENTURE_COUNT_LACK;
    }
}
