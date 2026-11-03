/**
 *
 */
package com.ayjs.mxzg.gameserver.module.hero.receiver;

import com.ayjs.mxzg.battle.command.QueryBattleCommand;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.model.SkillDo;
import com.ayjs.mxzg.common.command.Receivers;
import com.ayjs.mxzg.common.command.annotation.Invoker;
import com.ayjs.mxzg.config.excel.cache.HeroFashionSysCache;
import com.ayjs.mxzg.config.excel.cache.HeroFashionUpSysCache;
import com.ayjs.mxzg.config.excel.cache.HeroSkillSysCache;
import com.ayjs.mxzg.config.excel.entity.CHeroFashion;
import com.ayjs.mxzg.config.excel.entity.CHeroFashionUp;
import com.ayjs.mxzg.config.excel.entity.CHeroSkill;
import com.ayjs.mxzg.gameserver.module.hero.command.CreateBattlerCommand;
import com.ayjs.mxzg.gameserver.module.hero.command.QueryHeroCommand;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroFashionService;
import com.ayjs.mxzg.gameserver.module.hero.struct.FashionData;
import com.google.common.collect.Lists;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 *
 */
@Component
public class HeroFashionReceivers implements Receivers {

    @Autowired
    private HeroFashionService heroFashionService;
    @Autowired
    private HeroFashionUpSysCache heroFashionUpSysCache;
    @Autowired
    private HeroFashionSysCache heroFashionSysCache;
    @Autowired
    private HeroSkillSysCache heroSkillSysCache;

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

    /**
     * 设置宝石属性
     * @param rid
     * @param heros
     */
    private void setAttribute(long rid, List<HeroDo> heros) {
        for (HeroDo hero : heros) {
            List<FashionData> fashionDataList = heroFashionService.selectHeroType(rid, hero.getHeroId());
            for (FashionData fashionData : fashionDataList) {
                if (fashionData.getFashionId() != 0) {
                    CHeroFashionUp fashionUp = heroFashionUpSysCache.getHeroFashionUp(fashionData.getFashionId(), fashionData.getLevel());
                    hero.getAttributeInfo().addAllAttribute(fashionUp.getAbility());
                    //增加技能
                    CHeroFashion cHeroFashion = heroFashionSysCache.getOrThrow(fashionData.getFashionId());
                    if (cHeroFashion.getSkill() > 0) {
                        CHeroSkill cHeroSkill = heroSkillSysCache.getHeroSkillByOrThrow(cHeroFashion.getSkill(), cHeroFashion.getSkill_level());
                        SkillDo skillDo = SkillDo.createOf(cHeroSkill);
                        hero.getSkillInfo().addSkill(skillDo);
                    }
                }
            }
        }
    }
}
