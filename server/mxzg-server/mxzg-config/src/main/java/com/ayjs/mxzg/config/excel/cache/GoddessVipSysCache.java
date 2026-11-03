package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CGoddessVip;
import com.ayjs.mxzg.config.struct.ItemType;
import com.ayjs.mxzg.config.struct.ThingBonus;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

@Component
public class GoddessVipSysCache extends BaseExcelCache<CGoddessVip> {


	@Override
	public String getFileName() {
		return "goddessvip";
	}

	@Override
	protected void loadAfterReady() {
		for(CGoddessVip cGoddessVip : this.getAll()) {
			List<ThingBonus> hangBonusList = new ArrayList<>();
			//配置表里面的是百分比，转化为万分比
			ThingBonus roleExpBonus = new ThingBonus();
			roleExpBonus.setItem_type(ItemType.IT_ROLE_EXP);
			roleExpBonus.setBonus(cGoddessVip.getCharater_exp_bonus() * 100);
//			ThingBonus roleExpBonus = ThingBonus.of(ItemType.IT_ROLE_EXP, cGoddessVip.getCharater_exp_bonus() * 100);

			ThingBonus goldBonus = new ThingBonus();
			goldBonus.setItem_type(ItemType.IT_GOLD);
			goldBonus.setBonus(cGoddessVip.getGold_bonus() * 100);
//			ThingBonus goldBonus = ThingBonus.of(ItemType.IT_GOLD, cGoddessVip.getGold_bonus() * 100);

			ThingBonus heroExpBonus = new ThingBonus();
			heroExpBonus.setItem_type(ItemType.IT_HERO_EXP);
			heroExpBonus.setBonus(cGoddessVip.getHeroes_exp_bonus() * 100);
//			ThingBonus heroExpBonus = ThingBonus.of(ItemType.IT_HERO_EXP, cGoddessVip.getHeroes_exp_bonus() * 100);
			
			hangBonusList.add(roleExpBonus);
			hangBonusList.add(goldBonus);
			hangBonusList.add(heroExpBonus);
			
			cGoddessVip.setHangBonusList(hangBonusList);
			
			
			List<ThingBonus> buyGoldBonusList = new ArrayList<>();
			//配置表里面的是百分比，转化为万分比
			ThingBonus buyGoldBonus = new ThingBonus();
			buyGoldBonus.setItem_type(ItemType.IT_GOLD);
			buyGoldBonus.setBonus(cGoddessVip.getBuy_gold_bonus() * 100);
//			ThingBonus buyGoldBonus = ThingBonus.of(ItemType.IT_GOLD, );
			buyGoldBonusList.add(buyGoldBonus);
			
			cGoddessVip.setBuyGoldBonusList(buyGoldBonusList);
		}
	}
}