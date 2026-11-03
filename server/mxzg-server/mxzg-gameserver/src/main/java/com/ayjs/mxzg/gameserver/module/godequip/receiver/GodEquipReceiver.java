package com.ayjs.mxzg.gameserver.module.godequip.receiver;

import com.ayjs.mxzg.battle.command.QueryBattleCommand;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.model.SkillDo;
import com.ayjs.mxzg.common.command.Receivers;
import com.ayjs.mxzg.common.command.annotation.Invoker;
import com.ayjs.mxzg.config.excel.cache.HeroSkillSysCache;
import com.ayjs.mxzg.config.excel.cache.god.GodEquipmentRandomAbilitySysCache;
import com.ayjs.mxzg.config.excel.cache.god.GodEquipmentSettypeSysCache;
import com.ayjs.mxzg.config.excel.cache.god.GodEquipmentSysCache;
import com.ayjs.mxzg.config.excel.entity.CHeroSkill;
import com.ayjs.mxzg.config.excel.entity.god.CGodEquipment;
import com.ayjs.mxzg.config.excel.entity.god.CGodEquipmentRandomAbility;
import com.ayjs.mxzg.config.excel.entity.god.CGodEquipmentSettype;
import com.ayjs.mxzg.config.struct.GodAttr;
import com.ayjs.mxzg.gameserver.module.godequip.domain.GodEquip;
import com.ayjs.mxzg.gameserver.module.godequip.service.GodEquipService;
import com.ayjs.mxzg.gameserver.module.godequip.struct.GodEquipSet;
import com.ayjs.mxzg.gameserver.module.hero.command.CreateBattlerCommand;
import com.ayjs.mxzg.gameserver.module.hero.command.ModuleType;
import com.ayjs.mxzg.gameserver.module.hero.command.QueryHeroCommand;
import com.google.common.collect.Lists;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Component
public class GodEquipReceiver implements Receivers {

    @Autowired
    private GodEquipService godEquipService;
    @Autowired
    private GodEquipmentSysCache godEquipmentSysCache;
    @Autowired
    private GodEquipmentRandomAbilitySysCache godEquipmentRandomAbilitySysCache;
    @Autowired
    private GodEquipmentSettypeSysCache godEquipmentSettypeSysCache;
    @Autowired
    private HeroSkillSysCache heroSkillSysCache;

    @Invoker
    public void onQueryBattleCommand(QueryBattleCommand command) {
        setAttributeAddition(command.getPlayerId(), command.getHeros());
    }

    @Invoker
    public void onCreateBattlerCommand(CreateBattlerCommand command) {
        setAttributeAddition(command.getPlayerId(), command.getHeroDos());
    }

    @Invoker
    public void onQueryHeroCommand(QueryHeroCommand command) {
        if(!command.isFilter(ModuleType.GOD_EQUIP)){
            setAttributeAddition(command.getHero().getRid(), Lists.newArrayList(command.getHeroDo()));
        }
    }
    /**
     * 获取神器并给指定的英雄列表加成
     *
     * @param playerId
     * @param heroDos
     * @return
     */
    private void setAttributeAddition(long playerId, List<HeroDo> heroDos) {
        for (HeroDo heroDo : heroDos) {
            List<GodEquip> godEquips = godEquipService.getHeroEquips(playerId, heroDo.getId());
            Map<Integer, GodEquipSet> equipSetMap = new HashMap<>();

            for(GodEquip godEquip : godEquips) {
                //基础属性
                CGodEquipment cGodEquipment = godEquipmentSysCache.getOrThrow(godEquip.getSysId());
                heroDo.getAttributeInfo().addAllAttribute(cGodEquipment.getAbility());//TODO 添加属性
                //随机属性
                for(GodAttr godAttr : godEquip.getAttrs()) {
                    CGodEquipmentRandomAbility cGodEquipmentRandomAbility = godEquipmentRandomAbilitySysCache.getAbility(godEquip.getPlace(), cGodEquipment.getStar(),
                            godAttr.getSysId(), godAttr.getLevel());
                    if(cGodEquipmentRandomAbility == null) {
                        continue;
                    }
                    heroDo.getAttributeInfo().addAllAttribute(cGodEquipmentRandomAbility.getAbility());//TODO 添加属性
                }
                //统计套装属性
                GodEquipSet godEquipSet = equipSetMap.get(cGodEquipment.getSettype());
                if(godEquipSet == null) {
                    godEquipSet = new GodEquipSet();
                    godEquipSet.setType(cGodEquipment.getSettype());
                    godEquipSet.setStar(cGodEquipment.getStar());
                    equipSetMap.put(cGodEquipment.getSettype(), godEquipSet);
                }
                if(cGodEquipment.getStar() < godEquipSet.getStar()) {
                    godEquipSet.setStar(cGodEquipment.getStar());
                }
                godEquipSet.setNum(godEquipSet.getNum() + 1);
            }
            for(GodEquipSet equipSet : equipSetMap.values()) {
                List<CGodEquipmentSettype> cGodEquipmentSettypes = godEquipmentSettypeSysCache.getAbility(equipSet.getType(), equipSet.getStar(), equipSet.getNum());
                for (CGodEquipmentSettype cGodEquipmentSettype : cGodEquipmentSettypes) {
                    heroDo.getAttributeInfo().addAllAttribute(cGodEquipmentSettype.getAbility());//TODO 添加属性
                    if(cGodEquipmentSettype.getSkill() != 0) {
                        CHeroSkill heroSkill = heroSkillSysCache.getHeroSkillByOrThrow(cGodEquipmentSettype.getSkill(), equipSet.getStar());
                        SkillDo skillDo = SkillDo.createOf(heroSkill);
                        heroDo.getSkillInfo().addSkill(skillDo);;//TODO 添加技能
                    }
                }
            }
        }
    }

}
