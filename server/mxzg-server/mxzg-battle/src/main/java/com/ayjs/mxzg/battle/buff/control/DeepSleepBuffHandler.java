/**
 * 
 */
package com.ayjs.mxzg.battle.buff.control;

import com.ayjs.mxzg.battle.BattleConstant;
import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.common.util.RandomUtils;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * @author YY
 *
 */
@Component
public class DeepSleepBuffHandler extends AbstractControlBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.DEEP_SLEEP;
	}

	@Override
	public void trigger(BuffDo buff, HeroDo betrigger, HeroDo target, BattleContext context) {
		//解除沉睡的概率
		int awakeRate = buff.getBuff().getValue()[(int)buff.getValue()];
		int randomRate = RandomUtils.nextInt((int)BattleConstant.LONG_PERCENTAGE_RATIO);
		if(randomRate <= awakeRate) {
			buffHelper.removeBuff(buff, betrigger, context);
		}
		buff.addValue(1);
	}
}
