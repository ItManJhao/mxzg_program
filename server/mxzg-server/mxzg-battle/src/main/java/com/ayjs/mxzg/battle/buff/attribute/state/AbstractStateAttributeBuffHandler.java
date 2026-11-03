package com.ayjs.mxzg.battle.buff.attribute.state;

import com.ayjs.mxzg.battle.buff.AbstractBuffHandler;
import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.protocol.BattleGMsg.BuffInfo.Builder;

/**
 * 抽象的状态属性buff处理器
 */
public abstract class AbstractStateAttributeBuffHandler extends AbstractBuffHandler {

    @Override
    public void handle(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context, Builder builder) {
        super.addBuff(buff, attacker, defender, builder, context);
    }
}
