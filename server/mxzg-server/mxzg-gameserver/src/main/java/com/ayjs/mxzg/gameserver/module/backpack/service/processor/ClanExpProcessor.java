/**
 *
 */
package com.ayjs.mxzg.gameserver.module.backpack.service.processor;

import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.module.backpack.service.Rewards;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingProcessor;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingSet;
import com.ayjs.mxzg.gameserver.module.clan.domain.Clan;
import com.ayjs.mxzg.gameserver.module.clan.service.ClanService;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * @author YY
 *
 */
@Component
public class ClanExpProcessor implements ThingProcessor {

    @Autowired
    private ClanService clanService;

    @Override
    public ThingType thingType() {
        return ThingType.CLAN_EXP;
    }

	@Override
    public Rewards add(long rid, ThingSet thingSet, GameEvent gameEvent) {
        Clan clan = clanService.getRole2Clan(rid);
        if (clan == null) {
            return Rewards.of();
        }
        clanService.addClanExp(rid, clan, thingSet.asList(), gameEvent);
        return Rewards.of(thingSet);
    }

    @Override
    public ThingSet prepareCost(long rid, ThingSet thingSet, GameEvent gameEvent) {
        throw new UnsupportedOperationException("不能扣除公会经验");
    }

    @Override
    public void cost(long rid, ThingSet thingSet, GameEvent gameEvent) {
        throw new UnsupportedOperationException("不能扣除公会经验");
    }

	@Override
    public long getCount(long rid, int thingType) {
        Clan clan = clanService.getRole2Clan(rid);
        if (clan == null) {
            return 0;
        }
        return clan.getClanExp();
    }

    @Override
    public ErrorCode notEnoughCode() {
        return ErrorCode.CLAN_EXP_NOT_ENOUGH;
    }
}
