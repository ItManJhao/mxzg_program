package com.ayjs.mxzg.battle.buff.function;

import com.ayjs.mxzg.battle.buff.BuffHandler;
import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.service.BattleService;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.protocol.BattleGMsg.BuffInfo.Builder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * 根据血量选择使用的buff
 * @author meiyc
 *
 */
@Component
public class SelectHpCompBuffHandler implements BuffHandler {
	
	@Autowired
	private BattleService battleService;

	@Override
	public BuffType getType() {
		return BuffType.BT_SELECT_HP_COMP;
	}

	@Override
	public void handle(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context, Builder builder) {
		int lessThanArtId = buff.getValue()[0];
		int moreThanArtId = buff.getValue()[1];
		if(attacker.getHp() < defender.getHp() && lessThanArtId != 0){
			battleService.executeBuffArt(lessThanArtId, defender, attacker, context);
		} else if(attacker.getHp() > defender.getHp() && moreThanArtId != 0){
			battleService.executeBuffArt(moreThanArtId, defender, attacker, context);
		}
	}

}
