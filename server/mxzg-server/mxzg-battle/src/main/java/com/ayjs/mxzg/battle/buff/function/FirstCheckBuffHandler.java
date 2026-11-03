package com.ayjs.mxzg.battle.buff.function;

import com.ayjs.mxzg.battle.buff.AbstractBuffHandler;
import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.service.BattleService;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.protocol.BattleGMsg.BuffInfo.Builder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * 先手检测
 * 如果自己是己方最先出手，则执行art1，否则执行art2
 */
@Component
public class FirstCheckBuffHandler extends AbstractBuffHandler {

    @Autowired
    private BattleService battleService;

    @Override
    public BuffType getType() {
        return BuffType.BT_CHECK_FIRST;
    }

    @Override
    public void handle(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context, Builder builder) {
        int camp = buff.getValue()[2];
        BattlerDo battlerDo = camp == 0 ? context.getSelf(attacker.getFaction()) : context.getEnemy(attacker.getFaction());
        HeroDo first = battlerDo.getFirst();
        if(attacker == first || attacker.getSpeed() >= first.getSpeed()){
            int artId = buff.getValue()[0];
            battleService.executeBuffArt(artId, attacker, defender, context);
        } else {
            int artId = buff.getValue()[1];
            battleService.executeBuffArt(artId, attacker, defender, context);
        }
    }
}
