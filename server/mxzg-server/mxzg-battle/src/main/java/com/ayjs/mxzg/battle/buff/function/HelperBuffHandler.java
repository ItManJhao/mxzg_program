package com.ayjs.mxzg.battle.buff.function;

import com.ayjs.mxzg.battle.buff.AbstractBuffHandler;
import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.service.BattleService;
import com.ayjs.mxzg.config.excel.cache.HelperBuffSysCache;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.excel.entity.CHelperBuff;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.protocol.BattleGMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;

/**
 * 援助英雄上场
 */
@Component
public class HelperBuffHandler extends AbstractBuffHandler {

    @Autowired
    private BattleService battleService;
    @Autowired
    private HelperBuffSysCache helperBuffSysCache;

    // 位置比较器小的优先
    private Comparator<HeroDo> comparator = (h1, h2) -> Integer.compare(h1.getPosition(), h2.getPosition());

    @Override
    public BuffType getType() {
        return BuffType.BT_HELPER;
    }

    @Override
    public void handle(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context, BattleGMsg.BuffInfo.Builder builder) {
        BattlerDo battlerDo = context.getSelf(attacker.getFaction());
        if(battlerDo.getDeads().isEmpty()){
            return;
        }

        buildBuff(buff.getIdx(), attacker, builder, context);
        Optional<HeroDo> heroDo = battlerDo.getDeads().stream().sorted(comparator).findFirst();

        attacker.setPosition(heroDo.get().getPosition());
        context.getAllHeros().put(attacker.getUnitId(), attacker);
        battlerDo.getDeads().remove(heroDo.get());

        battlerDo.helperInBattle(heroDo.get());
        battleService.initPassiveSkills(attacker, context);

        CHelperBuff helperBuff = helperBuffSysCache.getById(attacker.getStar());
        if(helperBuff != null && helperBuff.getArt_id() != 0){
            battleService.executeBuffArt(helperBuff.getArt_id(), attacker, attacker, context);
        }

        BattleGMsg.AttributeUpdate.Builder attributeUpdate = BattleGMsg.AttributeUpdate.newBuilder();
        attributeUpdate.setType(AttributeType.POSITION.getValue()).setValue(attacker.getPosition());
        builder.addUpdate(attributeUpdate);
    }
}
