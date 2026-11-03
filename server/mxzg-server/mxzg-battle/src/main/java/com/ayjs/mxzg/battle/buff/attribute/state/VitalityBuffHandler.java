package com.ayjs.mxzg.battle.buff.attribute.state;

import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 生机，提升治疗与被治疗效果buff处理器
 * @author meiyc
 *
 */
@Component
public class VitalityBuffHandler extends AbstractStateAttributeBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_VITALITY;
	}

}
