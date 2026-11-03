package com.ayjs.mxzg.gameserver.module.reikiEquip.receiver;


import com.ayjs.mxzg.battle.command.QueryBattleCommand;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.model.SkillDo;
import com.ayjs.mxzg.common.command.Receivers;
import com.ayjs.mxzg.common.command.annotation.Invoker;
import com.ayjs.mxzg.config.excel.cache.HeroSkillSysCache;
import com.ayjs.mxzg.config.excel.cache.reiki.ReikiEquipSuitSysCache;
import com.ayjs.mxzg.config.excel.cache.reiki.ReikiEquipSysCache;
import com.ayjs.mxzg.config.excel.entity.CHeroSkill;
import com.ayjs.mxzg.config.excel.entity.reiki.CReikiEquip;
import com.ayjs.mxzg.config.excel.entity.reiki.CReikiEquipSuit;
import com.ayjs.mxzg.gameserver.module.hero.command.CreateBattlerCommand;
import com.ayjs.mxzg.gameserver.module.hero.command.ModuleType;
import com.ayjs.mxzg.gameserver.module.hero.command.QueryHeroCommand;
import com.ayjs.mxzg.gameserver.module.reikiEquip.domain.ReikiEquip;
import com.ayjs.mxzg.gameserver.module.reikiEquip.service.ReikiEquipService;
import com.ayjs.mxzg.gameserver.module.reikiEquip.struct.ReikiEquipSuit;
import com.google.common.collect.Lists;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 灵器套装
 *
 * @author hyx
 */
@Component
public class ReikiEquipReceiver implements Receivers {

    @Autowired
    private ReikiEquipService reikiEquipService;
    @Autowired
    private ReikiEquipSysCache reikiEquipSysCache;
    @Autowired
    private HeroSkillSysCache heroSkillSysCache;
    @Autowired
    private ReikiEquipSuitSysCache reikiEquipSuitSysCache;

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
        setAttributeAddition(command.getHero().getRid(), Lists.newArrayList(command.getHeroDo()));
    }

    /**
     * 添加灵器属性
     *
     * @param playerId
     * @param heroDos
     */
    private void setAttributeAddition(long playerId, List<HeroDo> heroDos) {

        for (HeroDo heroDo : heroDos) {
            //获取穿戴的灵器配置
            List<CReikiEquip> equipList = new ArrayList<>();
            for (ReikiEquip reikiEquip : reikiEquipService.heroReikiEquip(playerId, heroDo.getId())) {
                //灵器配置
                CReikiEquip cReikiEquip = reikiEquipSysCache.getOrThrow(reikiEquip.getSysId());
                equipList.add(cReikiEquip);
            }
            //按品质进行排序
            equipList = equipList.stream().sorted(Comparator.comparingInt(CReikiEquip::getRare)).collect(Collectors.toList());

            //套装
            List<ReikiEquipSuit> suitList = new ArrayList<>();
            for (CReikiEquip cReikiEquip : equipList) {
                //灵器基础属性
                heroDo.getAttributeInfo().addAllAttribute(cReikiEquip.getAbility());
                //灵器特殊属性
                if (!cReikiEquip.getSpecial_ability().isEmpty()) {
                    heroDo.getAttributeInfo().addAllAttribute(cReikiEquip.getSpecial_ability());
                }
                /*//添加技能等级
                if (cReikiEquip.getSkill() != 0) {
                    CHeroSkill heroSkill = heroSkillSysCache.getHeroSkillByOrThrow(cReikiEquip.getSkill(), cReikiEquip.getSkill_level());
                    SkillDo skillDo = SkillDo.createOf(heroSkill);
                    heroDo.getSkillInfo().addSkill(skillDo);
                }*/
                //计算套装数量
                ReikiEquipSuit reikiEquipSuit = null;
                for (ReikiEquipSuit suit : suitList) {
                    if (suit.getSuitId() == cReikiEquip.getSuit_id() || suit.getRare() < cReikiEquip.getRare()) {
                        suit.setSuitNum(suit.getSuitNum() + 1);
                        reikiEquipSuit = suit;
                    }
                }
                if (reikiEquipSuit == null) {
                    reikiEquipSuit = new ReikiEquipSuit();
                    reikiEquipSuit.setRare(cReikiEquip.getRare());
                    reikiEquipSuit.setSuitId(cReikiEquip.getSuit_id());
                    reikiEquipSuit.setSuitNum(1);
                    suitList.add(reikiEquipSuit);
                }
            }
            //获取激活的套装属性
            for (ReikiEquipSuit reikiEquipSuit : suitList) {
                reikiEquipSuitSysCache.getAll().stream().filter(cReikiEquipSuit ->
                        cReikiEquipSuit.getSuit_id() == reikiEquipSuit.getSuitId()
                                && cReikiEquipSuit.getActive_need_num() <= reikiEquipSuit.getSuitNum()).forEach(cReikiEquipSuit -> {
                    heroDo.getAttributeInfo().addAllAttribute(cReikiEquipSuit.getSuit_ability());

                    //添加技能
                    if (cReikiEquipSuit.getSkill() > 0 && cReikiEquipSuit.getSkill_level() > 0) {
                        CHeroSkill heroSkill = heroSkillSysCache.getHeroSkillByOrThrow(cReikiEquipSuit.getSkill(), cReikiEquipSuit.getSkill_level());
                        SkillDo skillDo = SkillDo.createOf(heroSkill);
                        heroDo.getSkillInfo().addSkill(skillDo);
                    }
                });
            }
        }
    }

}
