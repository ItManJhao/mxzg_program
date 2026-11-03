package com.ayjs.mxzg.battle.buff.remove;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.config.struct.BuffType;

/**
 * 移除所有buff类型
 * @author meiyc
 *
 */
@Component
public class RemoveAllBuffHandler extends AbstractRemoveBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_REMOVE_ALL;
	}

	@Override
	protected boolean isRemove(BuffDo buffDo) {
		return true;
	}

}
