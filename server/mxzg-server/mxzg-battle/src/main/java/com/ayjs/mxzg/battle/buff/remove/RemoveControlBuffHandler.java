package com.ayjs.mxzg.battle.buff.remove;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.config.struct.BuffType;

/**
 * 移除控制类buff类型
 * @author meiyc
 *
 */
@Component
public class RemoveControlBuffHandler extends AbstractRemoveBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_REMOVE_CONTROL;
	}

	@Override
	protected boolean isRemove(BuffDo buffDo) {
        return buffDo.getBuff().isControlBuff();
	}

}
