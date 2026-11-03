package com.ayjs.mxzg.battle.buff.trigger.mark;

import com.ayjs.mxzg.battle.buff.BuffHelper;
import com.ayjs.mxzg.battle.buff.trigger.AbstractArtTriggerBuffHandler;
import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.DamageResult;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.protocol.BattleGMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * 火灵印记,如果被攻击目标携带火灵印记则恢复一定生命值
 */
@Component
public class FireMakBuffHandler extends AbstractArtTriggerBuffHandler {

    @Override
    public BuffType getType() {
        return BuffType.BT_FIRE_MARK;
    }

    @Override
    public void trigger(BuffDo buff, HeroDo beTrigger, HeroDo target, BattleContext context) {
        DamageResult result = target.getResult();
        long damage = result.getDamage();
        long restoreRate = buff.getBuff().getValue()[0];

        long restoreHp = AttributeUtil.addPercent(restoreRate, damage);
        HeroDo source = context.getHero(buff.getSourceId());
        restoreHp = context.replenish(target, source, Math.abs(restoreHp));

        BattleGMsg.BuffInfo.Builder builder = BattleGMsg.BuffInfo.newBuilder();
        buildBuff(buff.getBuff().getIdx(), target, builder, context);
        BattleGMsg.AttributeUpdate update = BattleGMsg.AttributeUpdate.newBuilder().setType(AttributeType.HP.getValue()).setValue(restoreHp).build();
        builder.addUpdate(update).setStatus(target.getStatus().ordinal());
        context.addEffectInfoBy(builder.build());

        buffHelper.removeBuff(buff, beTrigger, context);
    }
}
