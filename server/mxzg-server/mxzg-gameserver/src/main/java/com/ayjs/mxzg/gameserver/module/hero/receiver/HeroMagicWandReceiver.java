package com.ayjs.mxzg.gameserver.module.hero.receiver;

import com.ayjs.mxzg.battle.command.QueryBattleCommand;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.common.command.Receivers;
import com.ayjs.mxzg.common.command.annotation.Invoker;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.LineUpType;
import com.ayjs.mxzg.gameserver.module.countryWar.service.CountryWarService;
import com.ayjs.mxzg.gameserver.module.hero.command.CreateBattlerCommand;
import com.ayjs.mxzg.gameserver.module.hero.command.QueryHeroCommand;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroMagicWand;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroMagicWandService;
import com.ayjs.mxzg.gameserver.module.hero.struct.MagicAttrData;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

/**
 * @author Rondo
 * 2021-05-22 11:45:14
 */
@Component
public class HeroMagicWandReceiver implements Receivers {

    @Autowired
    private HeroMagicWandService heroMagicWandService;

    @Autowired
    private CountryWarService countryWarService;

    // 红色品质的魔杖
    private static final int RED_RARE = 5;

    @Invoker
    public void onQueryBattleCommand(QueryBattleCommand command) {
        List<HeroDo> heroes = command.getHeros();
        boolean war = command.getLineUpType() == LineUpType.COUNTRY_WAR;
        heroes.forEach(heroDo -> setAttribute(command.getPlayerId(), heroDo, war));
    }

    @Invoker
    public void onCreateBattlerCommand(CreateBattlerCommand command) {
        boolean war = command.getLineUpType() == LineUpType.COUNTRY_WAR;
        command.getHeroDos().forEach(heroDo -> setAttribute(command.getPlayerId(), heroDo, war));
    }

    @Invoker
    public void onQueryHeroCommand(QueryHeroCommand command) {
        setAttribute(command.getHero().getRid(), command.getHeroDo(), false);
    }


    /**
     * 设置英雄的魔杖属性 ==> 基础属性和随机属性
     * @param rid
     * @param heroDo
     */
    private void setAttribute(long rid, HeroDo heroDo, boolean war) {
        long heroId = heroDo.getId();
        HeroMagicWand heroMagicWand = heroMagicWandService.getMagicWandByHeroId(rid, heroId);
        if (Objects.isNull(heroMagicWand)) {
            return;
        }
        Map<Integer, MagicAttrData> base_attrs = heroMagicWand.getBase_attrs();
        Map<Integer, MagicAttrData> random_attrs = heroMagicWand.getRandom_attrs();
        Map<AttributeType, Long> addAttribute = new HashMap<>();
        for (MagicAttrData attrData : base_attrs.values()) {
            Long oldValue = addAttribute.getOrDefault(attrData.getAttributeType(), 0L);
            addAttribute.put(attrData.getAttributeType(), attrData.getValue() + oldValue );
        }
        for (MagicAttrData attrData : random_attrs.values()) {
            Long oldValue = addAttribute.getOrDefault(attrData.getAttributeType(), 0L);
            addAttribute.put(attrData.getAttributeType(), attrData.getValue() + oldValue);
        }
        // 是国战战斗并且红色且类型对应
        if (war && heroMagicWand.getRare() == RED_RARE  && countryWarService.getOpenType() == heroMagicWand.getType()) {
            addAttribute.forEach((key, val) -> {
                addAttribute.put(key, val * 2);
            });
        }
        heroDo.getAttributeInfo().addAllAttribute(addAttribute);
    }

}
