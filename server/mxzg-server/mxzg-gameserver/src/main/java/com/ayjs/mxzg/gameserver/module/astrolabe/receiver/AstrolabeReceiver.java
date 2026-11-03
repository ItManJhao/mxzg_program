package com.ayjs.mxzg.gameserver.module.astrolabe.receiver;

import com.ayjs.mxzg.battle.command.QueryBattleCommand;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.common.command.Receivers;
import com.ayjs.mxzg.common.command.annotation.Invoker;
import com.ayjs.mxzg.config.excel.cache.astrolabe.AstrolabeElementSysCache;
import com.ayjs.mxzg.config.excel.cache.astrolabe.AstrolabeSkillSysCache;
import com.ayjs.mxzg.config.excel.cache.astrolabe.AstrolabeSysCache;
import com.ayjs.mxzg.config.excel.entity.astrolabe.CAstrolabe;
import com.ayjs.mxzg.config.excel.entity.astrolabe.CAstrolabeElement;
import com.ayjs.mxzg.config.excel.entity.astrolabe.CAstrolabeSkill;
import com.ayjs.mxzg.config.struct.AttributeElement;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.gameserver.module.astrolabe.domain.Astrolabe;
import com.ayjs.mxzg.gameserver.module.astrolabe.service.AstrolabeService;
import com.ayjs.mxzg.gameserver.module.hero.command.CreateBattlerCommand;
import com.ayjs.mxzg.gameserver.module.hero.command.QueryHeroCommand;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.google.common.collect.Lists;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 星盘属性计算
 *
 * @Author: CWJ
 * @Date: 2020/4/28
 **/
@Service
public class AstrolabeReceiver implements Receivers {
    @Autowired
    private AstrolabeSkillSysCache astrolabeSkillSysCache;
    @Autowired
    private AstrolabeElementSysCache astrolabeElementSysCache;
    @Autowired
    private AstrolabeSysCache astrolabeSysCache;
    @Autowired
    private AstrolabeService astrolabeService;
    @Autowired
    private RoleService roleService;

    private static final int ALL_ELEM = 0;

    @Invoker
    public void onQueryBattleHeroCommand(QueryBattleCommand command) {
        setAttribute(command.getPlayerId(), command.getHeros());
    }

    @Invoker
    public void onCreateBattlerCommand(CreateBattlerCommand command) {
        setAttribute(command.getPlayerId(), command.getHeroDos());
    }

    @Invoker
    public void onQueryHeroCommand(QueryHeroCommand command) {
        setAttribute(command.getHero().getRid(), Lists.newArrayList(command.getHeroDo()));
    }

    private void setAttribute(long rid, List<HeroDo> heroDos) {
        if (!roleService.isRole(rid)) {
            return;
        }

        Astrolabe astrolabe = astrolabeService.load(rid);
        List<AttributeElement> list = new ArrayList<>();
        astrolabe.getActiveElem().forEach(elementId -> {
            CAstrolabeElement config = astrolabeElementSysCache.getById(elementId);
            config.getAttrs().forEach(attribute -> {
                list.add(attribute);
            });
        });
        astrolabe.getLightStar().forEach((key, value) -> {
            CAstrolabe config = astrolabeSysCache.getById(key);
            config.getAttrs().forEach(attribute -> {
                list.add(attribute);
            });
            if (value > 0) {
                CAstrolabeSkill skillConfig = astrolabeSkillSysCache.getById(value);
                skillConfig.getAttrs().forEach(attribute -> {
                    list.add(attribute);
                });
            }
        });

        Map<Integer, List<AttributeElement>> jobAttrs = list.stream().collect(Collectors.groupingBy(AttributeElement::getElement));

        Map<Integer, Map<AttributeType, Long>> elemAttrMap = new HashMap<>();
        jobAttrs.forEach((key, value) -> {
            Map<AttributeType, Long> attrMap = elemAttrMap.get(key);
            if (attrMap == null) {
                attrMap = new HashMap<>();
                elemAttrMap.put(key, attrMap);
            }

            for (AttributeElement attributeElement : value) {
                fillAttr(attrMap, AttributeType.valueOf(attributeElement.getAttr()), attributeElement.getValue());
            }
        });

        heroDos.forEach(heroDo -> {
            Map<AttributeType, Long> attrMap = elemAttrMap.get(heroDo.getElementMul().getIdx());
            if (attrMap != null) {
                heroDo.getAttributeInfo().addAllAttribute(attrMap);
            }
            Map<AttributeType, Long> allElemAttr = elemAttrMap.get(ALL_ELEM);
            if (allElemAttr != null) {
                heroDo.getAttributeInfo().addAllAttribute(allElemAttr);
            }
        });
    }


    private void fillAttr(Map<AttributeType, Long> attrMap, AttributeType attributeType, long value) {
        attrMap.put(attributeType, attrMap.getOrDefault(attributeType, 0l) + value);
    }


}
