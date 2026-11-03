/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.hero.receiver;

import com.ayjs.mxzg.battle.command.QueryBattleCommand;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.common.command.Receivers;
import com.ayjs.mxzg.common.command.annotation.Invoker;
import com.ayjs.mxzg.config.excel.cache.JewelTypeSysCache;
import com.ayjs.mxzg.config.excel.entity.CJewelSetType;
import com.ayjs.mxzg.config.excel.entity.CJewelType;
import com.ayjs.mxzg.gameserver.module.hero.command.CreateBattlerCommand;
import com.ayjs.mxzg.gameserver.module.hero.command.QueryHeroCommand;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroJewel;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroJewelService;
import com.google.common.collect.Lists;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 *
 */
@Component
public class HeroJewelReceivers implements Receivers {
	
	@Autowired
	private HeroJewelService heroJewelService;
	@Autowired
	private JewelTypeSysCache jewelTypeSysCache;
	
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
    private void setAttribute(long rid, List<HeroDo> heros){
    	for(HeroDo hero : heros) {
    		//各个宝石槽位的属性
    		List<HeroJewel> jewels = heroJewelService.getHeroParts(rid, hero.getId());
    		for(HeroJewel jewel : jewels) {
    			if(jewel.getSysId() <= 0) {
    				continue;
    			}
    			CJewelType cJewelType = jewelTypeSysCache.getOrThrow(jewel.getSysId());
    			hero.getAttributeInfo().addAllAttribute(cJewelType.getAbility());
    			hero.getAttributeInfo().addAllAttribute(cJewelType.getGet_fighting());
    		}
    		//宝石套装属性
    		CJewelSetType cJewelSetType = heroJewelService.getHeroJewelSet(rid, jewels);
    		if(cJewelSetType != null) {
    			hero.getAttributeInfo().addAllAttribute(cJewelSetType.getAttr());
    		}
    	}
    }
}
