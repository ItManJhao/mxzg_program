/**
 *
 */
package com.ayjs.mxzg.gameserver.module.backpack.service.processor;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.util.IThing;
import com.ayjs.mxzg.config.excel.cache.RunesTypeSysCache;
import com.ayjs.mxzg.config.excel.cache.RunesTypeSysCache.RuneDataTemplate;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.module.backpack.service.Rewards;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingProcessor;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingSet;
import com.ayjs.mxzg.gameserver.module.rune.domain.RuneInfo;
import com.ayjs.mxzg.gameserver.module.rune.event.RuneAddEvent;
import com.ayjs.mxzg.gameserver.module.rune.service.RuneInfoService;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Objects;

/**
 * @author YY
 *
 */
@Component
public class RuneProcessor implements ThingProcessor {

    @Autowired
    private RunesTypeSysCache runesTypeSysCache;
    @Autowired
    private RuneInfoService runeInfoService;
    @Autowired
    private EventBus eventBus;

    @Override
    public ThingType thingType() {
        return ThingType.RUNE;
    }

    @Override
    public long getCount(long rid, int thingType) {
        RuneInfo rune = runeInfoService.getRune(rid, thingType);
        if (Objects.isNull(rune)) {
            return 0;
        } else {
            return 1;
        }
    }

    @Override
    public Rewards add(long rid, ThingSet thingSet, GameEvent gameEvent) {
        List<RuneInfo> runeList = new ArrayList<>();
        for (IThing reward : thingSet.asList()) {
            for (int i = 0; i < reward.getNum(); i++) {
                RuneDataTemplate template = runesTypeSysCache.randomRune(reward.getThingId());
                if (template == null) {
                    continue;
                }
                RuneInfo runeInfo = new RuneInfo();
                runeInfo.setRid(rid);
                runeInfo.setTypeId(template.getType_id());
                runeInfo.setAbilityId(template.getAbility_id());
                runeInfo.setSkillMap(new HashMap<>());
                runeInfo.getSkillMap().putAll(template.getSkillMap());
                runeInfo.setWashSkillMap(new HashMap<>());
                runeList.add(runeInfo);
            }
        }
        if (!runeList.isEmpty()) {
            runeInfoService.addRunes(runeList);
            eventBus.post(RuneAddEvent.of(rid, runeList, gameEvent));
        }
        return Rewards.of(thingSet);
    }

    @Override
    public ThingSet prepareCost(long rid, ThingSet thingSet, GameEvent gameEvent) {
        throw new UnsupportedOperationException("不能扣除符文精灵");
    }

    @Override
    public void cost(long rid, ThingSet thingSet, GameEvent gameEvent) {
        throw new UnsupportedOperationException("不能扣除符文精灵");
    }

    @Override
    public ErrorCode notEnoughCode() {
        throw new UnsupportedOperationException("不能扣除符文精灵");
    }

}
