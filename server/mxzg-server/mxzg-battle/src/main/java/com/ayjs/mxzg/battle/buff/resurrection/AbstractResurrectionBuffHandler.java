package com.ayjs.mxzg.battle.buff.resurrection;

import com.ayjs.mxzg.battle.buff.AbstractBuffHandler;
import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.protocol.BattleGMsg.AttributeUpdate;
import com.ayjs.mxzg.protocol.BattleGMsg.BuffInfo.Builder;

/**
 * 复活抽象类
 */
public abstract class AbstractResurrectionBuffHandler extends AbstractBuffHandler {

    @Override
    public void handle(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context, Builder builder) {
        addBuff(buff, attacker, defender, builder, context);
    }

    /**
     * 复活英雄
     * @param buffId
     * @param rebornHpRate
     * @param attacker
     * @param defender
     * @param context
     * @param builder
     */
    protected void resurrection(int buffId, int rebornHpRate, HeroDo attacker, HeroDo defender, BattleContext context, Builder builder){
        if(defender.haveBuff(BuffType.BT_SEAL_SOUL)){
            return;
        }
        buildBuff(buffId, defender, builder, context);
        context.heroResurrection(defender);
        long rebornHp = replenishHP(rebornHpRate, attacker, defender);
        long replenish = context.replenish(defender, attacker, rebornHp);
        AttributeUpdate update = AttributeUpdate.newBuilder().setType(AttributeType.HP.getValue()).setValue(replenish).build();
        builder.addUpdate(update).setStatus(defender.getStatus().ordinal());
        battleTrigger.trigger(BuffType.BT_REBIRTH, defender, attacker, context);
    }

    /**
     * 恢复的血量，默认恢复生命上限的百分比
     * @param rebornHpRate
     * @param attacker
     * @param defender
     * @return
     */
    protected long replenishHP(int rebornHpRate, HeroDo attacker, HeroDo defender){
        long maxHp = defender.getAttributeInfo().getMaxHp();
        return AttributeUtil.addPercent(maxHp, rebornHpRate);
    }

}
