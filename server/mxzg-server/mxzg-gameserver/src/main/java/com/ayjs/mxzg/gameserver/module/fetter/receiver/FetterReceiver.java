package com.ayjs.mxzg.gameserver.module.fetter.receiver;

import com.ayjs.mxzg.battle.command.QueryBattleCommand;
import com.ayjs.mxzg.battle.model.AttributeInfo;
import com.ayjs.mxzg.battle.model.Goddess;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.model.SkillDo;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.common.command.Receivers;
import com.ayjs.mxzg.common.command.annotation.Invoker;
import com.ayjs.mxzg.config.excel.cache.GoddessBreakSysCache;
import com.ayjs.mxzg.config.excel.cache.GoddessFashionTypeSysCache;
import com.ayjs.mxzg.config.excel.cache.GoddessLevelSysCache;
import com.ayjs.mxzg.config.excel.cache.GoddessMakeSoulSysCache;
import com.ayjs.mxzg.config.excel.cache.GoddessPassiveSysCache;
import com.ayjs.mxzg.config.excel.cache.GoddessSkillLevelSysCache;
import com.ayjs.mxzg.config.excel.cache.GoddessSkillRefineLevelSysCache;
import com.ayjs.mxzg.config.excel.cache.GoddessSkillSysCache;
import com.ayjs.mxzg.config.excel.cache.GoddessWashAttrSysCache;
import com.ayjs.mxzg.config.excel.cache.HeroSkillSysCache;
import com.ayjs.mxzg.config.excel.entity.CGoddessBreak;
import com.ayjs.mxzg.config.excel.entity.CGoddessFashionType;
import com.ayjs.mxzg.config.excel.entity.CGoddessLevel;
import com.ayjs.mxzg.config.excel.entity.CGoddessMakeSoul;
import com.ayjs.mxzg.config.excel.entity.CGoddessPassive;
import com.ayjs.mxzg.config.excel.entity.CGoddessSkill;
import com.ayjs.mxzg.config.excel.entity.CGoddessSkillLevel;
import com.ayjs.mxzg.config.excel.entity.CGoddessSkillRefineLevel;
import com.ayjs.mxzg.config.excel.entity.CGoddessWashAttr;
import com.ayjs.mxzg.config.excel.entity.CHeroSkill;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.LineUpType;
import com.ayjs.mxzg.gameserver.module.fetter.constant.GoddessConstant;
import com.ayjs.mxzg.gameserver.module.fetter.domain.FetterGoddess2;
import com.ayjs.mxzg.gameserver.module.fetter.domain.GoddessFashion;
import com.ayjs.mxzg.gameserver.module.fetter.service.FetterService;
import com.ayjs.mxzg.gameserver.module.fetter.service.GoddessFashionService;
import com.ayjs.mxzg.gameserver.module.hero.command.CreateBattlerCommand;
import com.ayjs.mxzg.gameserver.module.hero.command.QueryHeroCommand;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroLineUp;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroLineUpService;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.util.CollectionUtils;

import java.util.List;
import java.util.Map;

/**
 * 羈絆女神
 *
 * @author meiyc
 */
@Component
public class FetterReceiver implements Receivers {


    @Autowired
    private FetterService fetterService;
    @Autowired
    private HeroSkillSysCache heroSkillSysCache;
    @Autowired
    private HeroLineUpService heroLineUpService;
    @Autowired
    private GoddessLevelSysCache goddessLevelSysCache;
    @Autowired
    private GoddessBreakSysCache goddessBreakSysCache;
    @Autowired
    private GoddessPassiveSysCache goddessPassiveSysCache;
    @Autowired
    private GoddessSkillSysCache goddessSkillSysCache;
    @Autowired
    private GoddessSkillLevelSysCache goddessSkillLevelSysCache;
    @Autowired
    private GoddessSkillRefineLevelSysCache refineLevelSysCache;
    @Autowired
    private GoddessMakeSoulSysCache goddessMakeSoulSysCache;
    @Autowired
    private GoddessWashAttrSysCache goddessWashAttrSysCache;
    @Autowired
    private GoddessFashionService goddessFashionService;
    @Autowired
    private GoddessFashionTypeSysCache goddessFashionTypeSysCache;

    @Invoker
    public void onQueryBattleCommand(QueryBattleCommand command) {
        Goddess goddess = getAndAddHero(command.getPlayerId(), command.getLineUpType(), command.getHeros());
        command.setGoddess(goddess);
    }

    @Invoker
    public void onCreateBattlerCommand(CreateBattlerCommand command) {
        Goddess goddess = getAndAddHero(command.getPlayerId(), command.getLineUpType(), command.getHeroDos());
        command.setGoddess(goddess);
    }

    @Invoker
    public void onQueryHeroCommand(QueryHeroCommand command) {
        getAndAddHero(command.getHero().getRid(), null, Lists.newArrayList(command.getHeroDo()));
    }

    /**
     * 获取精灵并给指定的英雄列表加成
     *
     * @param playerId
     * @param lineUpType
     * @param heroDos
     * @return
     */
    private Goddess getAndAddHero(long playerId, LineUpType lineUpType, List<HeroDo> heroDos) {
        int goddessType = GoddessConstant.DEFAULT_GODDESS_ID;
        boolean emptyGoddess = true;
        if (lineUpType != null) {
            HeroLineUp heroLineUp = heroLineUpService.getLineUpByType(playerId, lineUpType);
            if (heroLineUp.getGoddessType() != 0) {
                goddessType = heroLineUp.getGoddessType();
                emptyGoddess = false;
            }
        }

        FetterGoddess2 fetterGoddess = fetterService.load(playerId);
        if (fetterGoddess.getActiveType().isEmpty()) {
            return null;
        }

        CGoddessBreak goddessBreak = goddessBreakSysCache.getOrThrow(fetterGoddess.getUplimitLevel());
        CGoddessLevel goddessLevel = goddessLevelSysCache.getOrThrow(fetterGoddess.getLevel());
        CGoddessPassive goddessPassive = goddessPassiveSysCache.getByLevelOrThrow(goddessType, fetterGoddess.getSkillLevel());
        CGoddessMakeSoul goddessMakeSoul = goddessMakeSoulSysCache.getOrThrow(fetterGoddess.getLevel());
        //Map<AttributeType,Long> goddessWashAbility = goddessWashAttrSysCache.getAbilityMap(fetterGoddess.getWashLevel());
        CGoddessWashAttr cGoddessWashAttr = goddessWashAttrSysCache.getWashLevel(fetterGoddess.getWashLevel());
        heroDos.forEach(heroDo -> {
            AttributeInfo attributeInfo = heroDo.getAttributeInfo();
            Map<AttributeType, Long> attributes = AttributeUtil.calAllAttribute(goddessLevel.getAttribute(fetterGoddess.getExp() / 10), goddessBreak.getAbility());
            attributeInfo.addAllAttribute(attributes);
            attributeInfo.addAllAttribute(goddessPassive.getAbility());
            attributeInfo.addAllAttribute(goddessMakeSoul.getAttribute(fetterGoddess.getSoulLevel()));
            attributeInfo.addAllAttribute(cGoddessWashAttr.getAbility());
        });

        GoddessFashion goddessFashion = goddessFashionService.get(playerId);
        if (!CollectionUtils.isEmpty(goddessFashion.getActiveType())) {
            Map<AttributeType, Long> attributeMap = Maps.newHashMap();
            goddessFashion.getActiveType().forEach(fashionType -> {
                CGoddessFashionType config = goddessFashionTypeSysCache.getOrThrow(fashionType);
                config.getAttr().forEach((attr, value) -> attributeMap.put(attr, attributeMap.getOrDefault(attr, 0l) + value));
            });
            heroDos.forEach(heroDo -> {
                heroDo.getAttributeInfo().addAllAttribute(attributeMap);
            });
        }

        if (emptyGoddess || lineUpType == null || lineUpType == LineUpType.LANG_UP) {
            return null;
        }

        CGoddessSkillRefineLevel skillRefineLevel = refineLevelSysCache.getByLevelOrThrow(goddessType, fetterGoddess.getRefineLevel());
        CGoddessSkillLevel goddessSkillLevel = goddessSkillLevelSysCache.getByLevelOrThrow(goddessType, fetterGoddess.getSkillLevel());
        CGoddessSkill goddessSkill = goddessSkillSysCache.getOrThrow(goddessType);
        CHeroSkill heroSkill = heroSkillSysCache.getHeroSkillByOrThrow(goddessSkill.getSkill(), fetterGoddess.getSkillLevel());
        SkillDo skill = SkillDo.createOf(heroSkill);
        long attack = goddessSkillLevel.getSkill_atk() + skillRefineLevel.getSkill_atk();

        int currUse = goddessFashion.getCurrUse();
        if (currUse > 0) {
            CGoddessFashionType useFashionConfig = goddessFashionTypeSysCache.getById(currUse);
            currUse = useFashionConfig.getGoddess_type();
        }

        return Goddess.createOf(goddessType, attack, skill, fetterGoddess.getUplimitLevel(), 0, currUse);
    }

}
