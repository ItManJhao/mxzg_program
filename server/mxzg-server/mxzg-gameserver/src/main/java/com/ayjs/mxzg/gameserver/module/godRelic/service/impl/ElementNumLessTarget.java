package com.ayjs.mxzg.gameserver.module.godRelic.service.impl;

import com.ayjs.mxzg.battle.model.BattleResult;
import com.ayjs.mxzg.battle.model.Faction;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.config.struct.GodRelicTarget;
import com.ayjs.mxzg.config.struct.GodRelicTargetType;
import com.ayjs.mxzg.gameserver.module.godRelic.service.GodRelicTargetChecker;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2020/3/23
 **/
@Component
public class ElementNumLessTarget implements GodRelicTargetChecker {

    @Override
    public GodRelicTargetType getType() {
        return GodRelicTargetType.ELEMENT_NUM_LESS;
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
        int element = godRelicTarget.getCondition1();
        int num = godRelicTarget.getCondition2();
        int sum = 0;

        for (HeroDo heroDo : object.getHeroByFaction(Faction.ATTACKER)) {
            if (heroDo.getElementMul().getIdx() == element) {
                sum++;
            }
        }

        return sum <= num;
    }


}
