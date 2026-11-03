package com.ayjs.mxzg.battle.buff.damage;

import com.ayjs.mxzg.battle.buff.BuffHelper;
import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.DamageResult;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.common.convert.ConvertUtils;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

/**
 * 引爆buff处理器
 *
 * @author meiyc
 */
@Component
public class DetonateDamageBuffHandler extends AbstractDamageBuffHandler {

    @Autowired
    private BuffHelper buffHelper;

    @Override
    public BuffType getType() {
        return BuffType.BT_DETONATE;
    }

    @Override
    protected DamageResult calDamage(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context) {
        int damageAddition = buff.getValue()[0];
        int attackUpLimit = buff.getValue()[1];
        long damageUpLimit = AttributeUtil.addPercent(attacker.getAttribute(AttributeType.ATTACK), attackUpLimit);
        List<Integer> buffTypes = buff.getValues().subList(2, buff.getValue().length).stream().filter(type -> type != 0).collect(Collectors.toList());
        List<DamageResult> results = buffTypes.stream().flatMap(type -> detonateBuff(type, defender, context).stream()).collect(Collectors.toList());
        long totalDamage = results.stream().mapToLong(DamageResult::getDamage).sum();
        totalDamage = AttributeUtil.addPercent(totalDamage, damageAddition);
        totalDamage = totalDamage > damageUpLimit ? damageUpLimit : totalDamage;
        return DamageResult.createRealDamage(totalDamage);
    }

    /**
     * 引爆指定类型的buff
     *
     * @param buffType
     * @param defender
     * @param context
     * @return
     */
    private List<DamageResult> detonateBuff(int buffType, HeroDo defender, BattleContext context) {
        BuffType type = ConvertUtils.toEnum(buffType, BuffType.class);
        List<BuffDo> buffDos = defender.getBuffsBy(type);
        return buffDos.stream().map(buffDo -> executeBuffDamage(buffDo, defender, context)).collect(Collectors.toList());
    }

    /**
     * 执行buff伤害
     *
     * @param buffDo
     * @param defender
     * @param context
     * @return
     */
    private DamageResult executeBuffDamage(BuffDo buffDo, HeroDo defender, BattleContext context) {
        HeroDo attacker = context.getHero(buffDo.getSourceId());
        int damageRound = buffDo.getExpiredRound() - context.currentRound();
        damageRound = buffDo.getBuff().getType().isFixedRound() ? 1 : damageRound;
        DamageResult result = calDamage(buffDo.getBuff(), attacker, defender);
        result.increaseMultiple(damageRound);
        buffHelper.removeBuff(buffDo, defender, context);
        return result;
    }

}
