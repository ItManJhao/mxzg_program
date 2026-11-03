package com.ayjs.mxzg.gameserver.module.godRelic.service.impl;

import com.ayjs.mxzg.battle.model.BattleResult;
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
public class RoundLessTarget implements GodRelicTargetChecker {

    @Override
    public GodRelicTargetType getType() {
        return GodRelicTargetType.ROUND_LESS;
    }


    @Override
    public boolean verify(GodRelicTarget godRelicTarget, List<BattleResult> objects) {
        int round = godRelicTarget.getCondition1();
        int sumRound = 0;
        for (BattleResult battleResult : objects) {
            sumRound += battleResult.getContext().currentRound() - 1;
        }

        return sumRound <= round;
    }


}
