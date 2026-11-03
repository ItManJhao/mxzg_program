package com.ayjs.mxzg.battle.buff.function;

import com.ayjs.mxzg.battle.buff.AbstractBuffHandler;
import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.service.BattleService;
import com.ayjs.mxzg.common.util.RandomUtil;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.protocol.BattleGMsg.BuffInfo.Builder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

/**
 * 根据art来随机选择
 */
@Component
public class ArtSelectorBuffHandler extends AbstractBuffHandler {

    @Autowired
    private BattleService battleService;

    @Override
    public BuffType getType() {
        return BuffType.BT_ART_SELECTOR;
    }

    @Override
    public void handle(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context, Builder builder) {
        int randomNum = buff.getValue()[0];
        List<Integer> artIds = buff.getValues().subList(1, buff.getValues().size());
        artIds = artIds.stream().filter(artId-> artId != 0).collect(Collectors.toList());
        artIds = RandomUtil.randomList(artIds, randomNum);
        for(int artId : artIds){
            battleService.executeBuffArt(artId, defender, attacker, context);
        }
    }
}
