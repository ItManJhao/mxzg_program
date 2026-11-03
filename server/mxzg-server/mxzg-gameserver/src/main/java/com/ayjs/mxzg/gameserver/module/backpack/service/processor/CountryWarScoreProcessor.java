package com.ayjs.mxzg.gameserver.module.backpack.service.processor;

import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.Rewards;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingProcessor;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingSet;
import com.ayjs.mxzg.gameserver.module.countryWar.domain.CountryWar;
import com.ayjs.mxzg.gameserver.module.countryWar.service.CountryWarService;
import com.ayjs.mxzg.protocol.CountryWarGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * @Author: CWJ
 * @Date: 2021/5/20
 **/
@Component
public class CountryWarScoreProcessor implements ThingProcessor {
    @Autowired
    private CountryWarService countryWarService;
    @Autowired
    private ContextManager contextManager;

    @Override
    public ThingType thingType() {
        return ThingType.COUNTRY_WAR_SCORE;
    }

    @Override
    public ErrorCode notEnoughCode() {
        throw new UnsupportedOperationException("不能扣除国战积分");
    }

    @Override
    public long getCount(long rid, int thingType) {
        throw new UnsupportedOperationException("不能扣除国战积分");
    }

    @Override
    public Rewards add(long rid, ThingSet thingSet, GameEvent gameEvent) {
        CountryWar countryWar = countryWarService.get(rid);
        for (ImmutableThing immutableThing : thingSet.asList()) {
            countryWar.setScore((int) (immutableThing.getItem_num() + countryWar.getScore()));
        }

        CountryWarGMsg.GResCountryWarScoreUpdate.Builder builder = CountryWarGMsg.GResCountryWarScoreUpdate.newBuilder();
        builder.setScore(countryWar.getScore());
        contextManager.write(rid, CmdCode._76361, builder.build());
        return Rewards.of(thingSet);
    }

    @Override
    public ThingSet prepareCost(long rid, ThingSet thingSet, GameEvent gameEvent) {
        throw new UnsupportedOperationException("不能扣除国战积分");
    }

    @Override
    public void cost(long rid, ThingSet thingSet, GameEvent gameEvent) {
        throw new UnsupportedOperationException("不能扣除国战积分");
    }
}
