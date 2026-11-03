package com.ayjs.mxzg.battle.buff.remove;

import com.ayjs.mxzg.battle.buff.BuffHandler;
import com.ayjs.mxzg.battle.buff.BuffHelper;
import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.protocol.BattleGMsg.BuffInfo.Builder;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;

/**
 * Buff移除基类
 * @author meiyc
 *
 */
public abstract class AbstractRemoveBuffHandler implements BuffHandler {

	@Autowired
	private BuffHelper buffHelper;
	
	@Override
	public void handle(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context, Builder builder) {
		List<BuffDo> buffs = defender.getAllBuffs();
		int removeBuffNum = buff.getValue()[0];
		int i = 0;
		for (BuffDo buffDo : buffs) {
			if(buffDo.getBuff().isDispelled() && isRemove(buffDo)){
				buffHelper.removeBuff(buffDo, defender, context);
				i++;
			}
			if(removeBuffNum != 0 && i >= removeBuffNum){
				break;
			}
		}

		// 是否需要移除成功后才触发art
		int condition = buff.getValue()[1];
		if(condition == 1 && i == 0){
			attacker.interrupt(defender.getUnitId());
		}
	}
	
	/**
	 * 是否是移除目标
	 * @param buffDo
	 * @return
	 */
	protected abstract boolean isRemove(BuffDo buffDo);
	
}
