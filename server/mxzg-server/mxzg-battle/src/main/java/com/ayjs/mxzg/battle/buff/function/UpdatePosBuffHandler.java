package com.ayjs.mxzg.battle.buff.function;

import com.ayjs.mxzg.battle.BattleConstant;
import com.ayjs.mxzg.battle.buff.AbstractBuffHandler;
import com.ayjs.mxzg.battle.buff.BuffHandler;
import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.protocol.BattleGMsg.AttributeUpdate;
import com.ayjs.mxzg.protocol.BattleGMsg.BuffInfo;
import com.ayjs.mxzg.protocol.BattleGMsg.BuffInfo.Builder;
import com.google.common.collect.Sets;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * 修改位置
 *
 * @author meiyc
 */
@Component
public class UpdatePosBuffHandler extends AbstractBuffHandler {
    @Override
    public BuffType getType() {
        return BuffType.BT_UPDATE_POS;
    }

    @Override
    public void handle(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context, Builder builder) {
        BattlerDo battlerDo = context.getEnemy(attacker.getFaction());
        Set<Integer> frontPosition = Sets.newHashSet(BattleConstant.FRONT_POSITION);
        List<HeroDo> rearHeroes = new ArrayList<>();
        for (HeroDo hero : battlerDo.getHeros()) {
            if(!frontPosition.remove(hero.getPosition())){
                rearHeroes.add(hero);
            }
        }

        for (Integer position : frontPosition) {
            if(!rearHeroes.isEmpty()){
                HeroDo rearHero = rearHeroes.remove(0);
                rearHero.getAttributeInfo().updateAttribute(AttributeType.POS, rearHero.getPosition());
                BuffInfo.Builder buffBuilder = BuffInfo.newBuilder();
                BuffDo buffDo = addBuff(buff, attacker, rearHero, buffBuilder, context);
                buffDo.setValue(rearHero.getPosition());
                buffDo.setExpiredRound(context.getRound().get() + 1);
                rearHero.setPosition(position);
                AttributeUpdate.Builder update =  AttributeUpdate.newBuilder();
                update.setType(AttributeType.POS.getValue()).setValue(position);
                buffBuilder.addUpdate(update);
                context.addUpdateBuff(buffBuilder.build());
            }
        }
    }

    @Override
    public void removeBuff(BuffDo buff, HeroDo target, BattleContext context) {
        int pos = (int)buff.getValue();
        target.setPosition(pos);
    }
}
