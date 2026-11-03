package com.ayjs.mxzg.gameserver.module.godRelic.service.impl;

import com.ayjs.mxzg.battle.model.BattleResult;
import com.ayjs.mxzg.battle.model.Faction;
import com.ayjs.mxzg.battle.model.HeroDo;
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
public class JobNumMoreTarget implements GodRelicTargetChecker {

    @Override
    public GodRelicTargetType getType() {
        return GodRelicTargetType.JOB_NUM_MORE;
    }


    @Override
    public boolean verify(GodRelicTarget godRelicTarget, List<BattleResult> objects) {
        boolean res = true;
        int job = godRelicTarget.getCondition1();
        int num = godRelicTarget.getCondition2();
        for (BattleResult battleResult : objects) {
            int sum = 0;
            for (HeroDo heroDo : battleResult.getHeroByFaction(Faction.ATTACKER)) {
                if (heroDo.getJob().getValue() == job) {
                    sum++;
                }
            }
            res &= sum >= num;
        }


        return res;
    }


}
