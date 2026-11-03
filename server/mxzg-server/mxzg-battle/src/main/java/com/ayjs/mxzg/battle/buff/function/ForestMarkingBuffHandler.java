package com.ayjs.mxzg.battle.buff.function;

import com.ayjs.mxzg.battle.buff.AbstractBuffHandler;
import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.service.BattleService;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.protocol.BattleGMsg.BuffInfo.Builder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * 森林印记，添加buff时给buff施加者执行artId1叠加到指定层数的后在个buff携带者触发art2
 */
@Component
public class ForestMarkingBuffHandler extends AbstractBuffHandler {

    @Autowired
    private BattleService battleService;

    @Override
    public BuffType getType() {
        return BuffType.BT_FOREST_MARKING;
    }

    @Override
    public void handle(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context, Builder builder) {
        addBuff(buff, attacker, defender, builder, context);

        int artId = buff.getValue()[0];
        battleService.executeBuffArt(artId, attacker, attacker, context);

        int layers = buff.getValue()[1];
        List<BuffDo> buffDos = defender.getBuffsBy(getType(), attacker.getUnitId());
        if(buffDos.size() >= layers){
            int artId2 = buff.getValue()[2];
            battleService.executeBuffArt(artId2, attacker, defender, context);
        }
    }
}
