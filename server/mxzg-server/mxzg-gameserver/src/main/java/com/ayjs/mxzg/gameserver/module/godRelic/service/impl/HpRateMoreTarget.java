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
public class HpRateMoreTarget implements GodRelicTargetChecker {
    @Override
    public GodRelicTargetType getType() {
        return GodRelicTargetType.HP_RATE_MORE;
    }


    @Override
    public boolean verify(GodRelicTarget godRelicTarget, List<BattleResult> objects) {
        boolean res = true;
        for (BattleResult battleResult : objects) {
            res &= verify(godRelicTarget, battleResult);
        }
        return res;
    }

    private boolean verify(GodRelicTarget godRelicTarget, BattleResult battleResult) {
        int rate = godRelicTarget.getCondition1();
        boolean res = true;
        float fRate = rate / 10000f;
        for (HeroHpInfo heroHpInfo : battleResult.attackerHpInfo().values()) {
            if (heroHpInfo.getMaxHp() > 0) {
                res &= heroHpInfo.getCurrentHp() * 1f / heroHpInfo.getMaxHp() >= fRate;
            }
        }
        return res;
    }
}
