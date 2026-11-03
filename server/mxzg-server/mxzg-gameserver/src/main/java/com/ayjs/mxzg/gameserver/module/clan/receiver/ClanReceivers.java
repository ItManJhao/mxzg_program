package com.ayjs.mxzg.gameserver.module.clan.receiver;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.ayjs.mxzg.battle.command.QueryBattleCommand;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.common.command.Receivers;
import com.ayjs.mxzg.common.command.annotation.Invoker;
import com.ayjs.mxzg.common.command.annotation.Invoker.Priority;
import com.ayjs.mxzg.common.convert.ConvertUtils;
import com.ayjs.mxzg.config.excel.cache.ClanSkillAbilitySysCache;
import com.ayjs.mxzg.config.excel.entity.CClanSkillAbility;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.gameserver.module.clan.domain.ClanSkill;
import com.ayjs.mxzg.gameserver.module.clan.service.ClanSkillService;
import com.ayjs.mxzg.gameserver.module.hero.command.QueryHeroCommand;

import lombok.extern.slf4j.Slf4j;


/**
 * 工会指令接受者
 *
 * @author meiyc
 */
@Component
@Slf4j
public class ClanReceivers implements Receivers {

    @Autowired
    private ClanSkillService clanSkillService;
    @Autowired
    private ClanSkillAbilitySysCache clanSkillAbilitySysCache;
	
	/*@Invoker
	public void onQueryBattleHeroCommand(QueryBattleCommand command){
		List<HeroDo> heroDos = command.getHeros();
        List<ClanSkill> clanSkillList = clanSkillService.getClanSkills(command.getPlayerId());
        Map<Integer, Map<Integer, ClanSkill>> clanSkillMap = ListMapUtil.fillTwoLayerMap(clanSkillList, ClanSkill::getProfession, ClanSkill::getSkillType);
        heroDos.forEach(heroDo-> setClanSkill(heroDo, clanSkillMap));
	}
	
	@Invoker(value = Priority.LOWEST)
	public void onQueryHeroCommand(QueryHeroCommand command){
		HeroDo heroDo = command.getHeroDo();
        List<ClanSkill> clanSkillList = clanSkillService.getClanSkills(command.getHero().getRid());
        Map<Integer, Map<Integer, ClanSkill>> clanSkillMap = ListMapUtil.fillTwoLayerMap(clanSkillList, ClanSkill::getProfession, ClanSkill::getSkillType);
        setClanSkill(heroDo, clanSkillMap);
	}
	*/


	/*private void setClanSkill(HeroDo heroDo, Map<Integer, Map<Integer, ClanSkill>> clanSkillMap){
		Map<Integer, ClanSkill> heroSkillMap = clanSkillMap.getOrDefault(heroDo.getJob().getValue(), Collections.emptyMap());
		Map<AttributeType, Long> attributeMap = new HashMap<>();
		for (ClanSkill clanSkill : heroSkillMap.values()) {
			CClanSkillAbility cClanSkillAbility = clanSkillAbilitySysCache.getOrThrow(clanSkill.getSkillType());
			AttributeType attributeType = ConvertUtils.toEnum(cClanSkillAbility.getAbility(), AttributeType.class);
			attributeMap.put(attributeType, (long)cClanSkillAbility.getNum() * clanSkill.getLevel());
		}
		heroDo.getAttributeInfo().addAllAttribute(attributeMap);
	}*/

    @Invoker
    public void onQueryBattleHeroCommand(QueryBattleCommand command) {
        List<HeroDo> heroDos = command.getHeros();
        ClanSkill clanSkill = clanSkillService.selectClanSkill(command.getPlayerId());
        Map<Integer, Map<Integer, Integer>> clanSkillMap = clanSkillService.getClanSkillLevel(clanSkill);
        heroDos.forEach(heroDo -> setClanSkill(heroDo, clanSkillMap));
    }

    @Invoker(value = Priority.LOWEST)
    public void onQueryHeroCommand(QueryHeroCommand command) {
        HeroDo heroDo = command.getHeroDo();
        ClanSkill clanSkill = clanSkillService.selectClanSkill(command.getHero().getRid());
        Map<Integer, Map<Integer, Integer>> clanSkillMap = clanSkillService.getClanSkillLevel(clanSkill);
        setClanSkill(heroDo, clanSkillMap);
    }

    /**
     * 设置工会技能
     *
     * @param heroDo
     * @param clanSkillMap
     */
    private void setClanSkill(HeroDo heroDo, Map<Integer, Map<Integer, Integer>> clanSkillMap) {
        Map<Integer, Integer> heroSkillMap = clanSkillMap.getOrDefault(heroDo.getJob().getValue(), Collections.emptyMap());

        Map<AttributeType, Long> attributeMap = new HashMap<>();
        heroSkillMap.forEach((key, value) -> {
        	CClanSkillAbility cClanSkillAbility = clanSkillAbilitySysCache.getByJobAttr(heroDo.getJob().getValue(), key);
        	if(cClanSkillAbility != null) {
        		AttributeType attributeType = ConvertUtils.toEnum(cClanSkillAbility.getAbility(), AttributeType.class);
    			attributeMap.put(attributeType, (long)cClanSkillAbility.getNum() * value);
        	}
		});

        heroDo.getAttributeInfo().addAllAttribute(attributeMap);
    }

}
