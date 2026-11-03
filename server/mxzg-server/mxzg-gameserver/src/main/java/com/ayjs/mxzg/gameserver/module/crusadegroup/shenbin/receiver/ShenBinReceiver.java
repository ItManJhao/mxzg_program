package com.ayjs.mxzg.gameserver.module.crusadegroup.shenbin.receiver;

import com.ayjs.mxzg.battle.command.QueryBattleCommand;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.model.SkillDo;
import com.ayjs.mxzg.common.command.Receivers;
import com.ayjs.mxzg.common.command.annotation.Invoker;
import com.ayjs.mxzg.config.excel.cache.HeroSkillSysCache;
import com.ayjs.mxzg.config.excel.cache.shenbin.ShenBinCoreSysCache;
import com.ayjs.mxzg.config.excel.cache.shenbin.ShenBinHoleSysCache;
import com.ayjs.mxzg.config.excel.cache.shenbin.ShenBinSysCache;
import com.ayjs.mxzg.config.excel.entity.CHeroSkill;
import com.ayjs.mxzg.config.excel.entity.shenbin.CShenBin;
import com.ayjs.mxzg.config.excel.entity.shenbin.CShenBinCore;
import com.ayjs.mxzg.config.excel.entity.shenbin.CShenBinHole;
import com.ayjs.mxzg.config.struct.LineUpType;
import com.ayjs.mxzg.config.struct.SkillScript;
import com.ayjs.mxzg.gameserver.module.crusadegroup.shenbin.domain.ShenBinCore;
import com.ayjs.mxzg.gameserver.module.crusadegroup.shenbin.domain.ShenBinEquip;
import com.ayjs.mxzg.gameserver.module.crusadegroup.shenbin.service.ShenBinService;
import com.ayjs.mxzg.gameserver.module.hero.command.CreateBattlerCommand;
import com.ayjs.mxzg.gameserver.module.hero.command.ModuleType;
import com.ayjs.mxzg.gameserver.module.hero.command.QueryHeroCommand;
import com.google.common.collect.Lists;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import com.ayjs.mxzg.common.command.annotation.Invoker.Priority;

import java.util.List;


@Component
public class ShenBinReceiver implements Receivers {

    @Autowired
    private ShenBinService shenBinService;
    @Autowired
    private HeroSkillSysCache heroSkillSysCache;
    @Autowired
    private ShenBinCoreSysCache shenBinCoreSysCache;
    @Autowired
    private ShenBinHoleSysCache shenBinHoleSysCache;
    @Autowired
    private ShenBinSysCache shenBinSysCache;

    @Invoker(Priority.LOWEST)
    public void onQueryBattleCommand(QueryBattleCommand command) {
        //讨伐团计算战斗属性
        if (command.getLineUpType() == LineUpType.CRUSADE_GROUP || command.getLineUpType() == LineUpType.CRUSADE_GROUP_BOSS) {
            setAttributeAddition(command.getPlayerId(), command.getHeros());
        }
    }

    @Invoker(Priority.LOWEST)
    public void onCreateBattlerCommand(CreateBattlerCommand command) {
        //讨伐团计算战斗属性
        if (command.getLineUpType() == LineUpType.CRUSADE_GROUP || command.getLineUpType() == LineUpType.CRUSADE_GROUP_BOSS) {
            setAttributeAddition(command.getPlayerId(), command.getHeroDos());
        }
    }

    @Invoker(Priority.LOWEST)
    public void onQueryHeroCommand(QueryHeroCommand command) {
        if (!command.isFilter(ModuleType.CRUSADE_GROUP)) {
            return;
        }
        setAttributeAddition(command.getHero().getRid(), Lists.newArrayList(command.getHeroDo()));
    }


    public void setAttributeAddition(long playerId, List<HeroDo> heroDos) {
        //此处还要判断是否讨伐团上阵英雄
        for (HeroDo heroDo : heroDos) {
            int job = heroDo.getJob().getValue();//英雄职业
            //计算核心的属性***********************
            ShenBinCore shenBinCore = shenBinService.getRoleShenBinCore(playerId, job);
            int coreLv = shenBinCore.getCoreLv();
            //属性累加从核心1级开始。。。
            for (int i = 1; i <= coreLv; i++) {
                //核心属性--------------
                CShenBinCore cShenBinCore = shenBinCoreSysCache.getCShenBinCoreTemplate_jobCore(job, i);
                //属性
                heroDo.getAttributeInfo().addAllAttribute(cShenBinCore.getAttr());
                //技能
                List<SkillScript> skills = cShenBinCore.getSkills();
                for (SkillScript sk : skills) {
                    CHeroSkill cHeroSkill = heroSkillSysCache.getHeroSkillByOrThrow(sk.getId(), sk.getLv());
                    SkillDo skillDo = SkillDo.createOf(cHeroSkill);
                    heroDo.getSkillInfo().addSkill(skillDo);
                }
                //神兵属性--------------
                if (i == coreLv) {//只加当前孔位装备的神兵
                    List<ShenBinEquip> sbList = shenBinService.getShenBinEquips(playerId, job);
                    for (ShenBinEquip sb : sbList) {
                        int sb_id = sb.getSysId();//孔位神兵id
                        if (sb_id <= 0) {
                            continue;
                        }
                        CShenBin cShenBin = shenBinSysCache.getCShenBinTemplate(sb_id);
                        heroDo.getAttributeInfo().addAllAttribute(cShenBin.getAttr());
                    }
                } else {//累加之前核心等级的神兵属性
                    List<CShenBinHole> holeList = shenBinHoleSysCache.getCShenBinHoleTemplates_jobCore(job, i);
                    for (CShenBinHole hole : holeList) {
                        int sb_id = hole.getSb_id();
                        CShenBin cShenBin = shenBinSysCache.getCShenBinTemplate(sb_id);
                        heroDo.getAttributeInfo().addAllAttribute(cShenBin.getAttr());
                    }
                }
            }
        }
    }
}
