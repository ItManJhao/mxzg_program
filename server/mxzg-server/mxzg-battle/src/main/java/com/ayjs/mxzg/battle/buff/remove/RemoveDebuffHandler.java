package com.ayjs.mxzg.battle.buff.remove;

import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 移除debuff
 * @author meiyc
 *
 */
@Component
public class RemoveDebuffHandler  extends AbstractRemoveBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_REMOVE_DEBUFF;
	}

	@Override
	protected boolean isRemove(BuffDo buffDo) {
        return buffDo.getBuff().isDeBuff();
	}

}
