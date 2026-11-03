/**
 *
 */
package com.ayjs.mxzg.gameserver.module.backpack.service.processor;

import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.module.backpack.service.Rewards;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingProcessor;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingSet;
import com.ayjs.mxzg.gameserver.module.countryWar.domain.CountryWar;
import com.ayjs.mxzg.gameserver.module.countryWar.service.CountryWarService;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;


/**
 * @author YY
 *
 */
@Component
public class CountryWarMoveProcessor implements ThingProcessor {

    @Autowired
    private CountryWarService countryWarService;

    @Override
    public ThingType thingType() {
        return ThingType.COUNTRY_WAR_MOVE;
    }

    @Override
    public ErrorCode notEnoughCode() {
        throw new UnsupportedOperationException("不能扣除迁移令");
    }

    @Override
    public long getCount(long rid, int thingType) {
        throw new UnsupportedOperationException("不能扣除迁移令");
    }

    @Override
    public Rewards add(long rid, ThingSet thingSet, GameEvent gameEvent) {

        CountryWar countryWar = countryWarService.get(rid);
        for (ImmutableThing immutableThing : thingSet.asList()) {
            countryWar.setMoveItemNum((int) (immutableThing.getItem_num() + countryWar.getMoveItemNum()));
        }

        return Rewards.of(thingSet);
    }

    @Override
    public ThingSet prepareCost(long rid, ThingSet thingSet, GameEvent gameEvent) {
        throw new UnsupportedOperationException("不能扣除迁移令");
    }

    @Override
    public void cost(long rid, ThingSet thingSet, GameEvent gameEvent) {
        throw new UnsupportedOperationException("不能扣除迁移令");
    }

}
