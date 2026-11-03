package com.ayjs.mxzg.battle.buff.function;

import com.ayjs.mxzg.battle.BattleConstant;
import com.ayjs.mxzg.battle.buff.BuffHandler;
import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.service.BattleService;
import com.ayjs.mxzg.common.util.RandomUtil;
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
public class RandomArtBuffHandler implements BuffHandler {
	
	@Autowired
	private BattleService battleService;

	@Override
	public BuffType getType() {
		return BuffType.BT_RANDOM_ART;
	}

	@Override
	public void handle(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context, Builder builder) {
		int randomValue = buff.getValue()[0];
		int hitArtId = buff.getValue()[1];
		int missedArtId = buff.getValue()[2];

		int artId = RandomUtil.randomUpperLimit(randomValue, (int)BattleConstant.LONG_PERCENTAGE_RATIO) ? hitArtId : missedArtId;
		battleService.executeBuffArt(artId, defender, attacker, context);
	}

}
