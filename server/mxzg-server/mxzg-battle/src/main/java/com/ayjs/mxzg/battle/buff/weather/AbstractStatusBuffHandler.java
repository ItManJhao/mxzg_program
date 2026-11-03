package com.ayjs.mxzg.battle.buff.weather;

import com.ayjs.mxzg.battle.buff.AbstractBuffHandler;
import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.protocol.BattleGMsg.BuffInfo.Builder;

/**
 * 抽象的状态类buff处理器，只添加buff不做任何处理
 */
public abstract class AbstractStatusBuffHandler extends AbstractBuffHandler {

    @Override
    public void handle(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context, Builder builder) {
        super.addBuff(buff, attacker, defender, builder, context);
    }
}
