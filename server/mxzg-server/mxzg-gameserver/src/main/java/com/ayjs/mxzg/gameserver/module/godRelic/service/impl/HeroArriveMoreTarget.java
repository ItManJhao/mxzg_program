package com.ayjs.mxzg.gameserver.module.godRelic.service.impl;

import com.ayjs.mxzg.battle.model.BattleResult;
import com.ayjs.mxzg.battle.model.HeroHpInfo;
import com.ayjs.mxzg.config.struct.GodRelicTarget;
import com.ayjs.mxzg.config.struct.GodRelicTargetType;
import com.ayjs.mxzg.gameserver.module.godRelic.service.GodRelicTargetChecker;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2020/3/23
 **/
@Component
public class HeroArriveMoreTarget implements GodRelicTargetChecker {

    @Override
    public GodRelicTargetType getType() {
        return GodRelicTargetType.HERO_ALIVE_MORE;
    }

    @Override
    public boolean verify(GodRelicTarget godRelicTarget, List<BattleResult> objects) {
        boolean res = true;
        for (BattleResult battleResult : objects) {
            res &= verify(godRelicTarget, battleResult);
        }

        return res;
    }

    public boolean verify(GodRelicTarget godRelicTarget, BattleResult object) {

        int num = godRelicTarget.getCondition1() == 0 ? object.attackerHpInfo().size() : godRelicTarget.getCondition1();
        int sum = 0;
        for (HeroHpInfo heroHpInfo : object.attackerHpInfo().values()) {
            if (heroHpInfo.getCurrentHp() > 0) {
                sum++;
            }
        }

        return num <= sum;
    }


}
