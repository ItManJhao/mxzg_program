package com.ayjs.mxzg.battle.buff.function;

import com.ayjs.mxzg.battle.buff.AbstractBuffHandler;
import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.protocol.BattleGMsg.BuffInfo.Builder;
import org.springframework.stereotype.Component;

/**
 * 增加下次出手的目标个数
 */
@Component
public class IncreaseTargetsBuffHandler extends AbstractBuffHandler{
    @Override
    public BuffType getType() {
        return BuffType.BT_INCREASE_TARGETS;
    }

    @Override
    public void handle(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context, Builder builder) {
        int targetNum = buff.getValue()[0];
        attacker.getSkillInfo().addTemporarilyTargetNum(targetNum);
    }
}
