package com.ayjs.mxzg.battle.targetselector;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.holder.AbstractHolder;
import com.ayjs.mxzg.config.struct.SelectorType;

/**
 * 目标选择器持有者
 * @author meiyc
 *
 */
@Component
public class TargetSelectorHolder extends AbstractHolder<SelectorType, AbstractTargetSelector> {

	@Override
	protected SelectorType convert(AbstractTargetSelector bean) {
		return bean.getType();
	}

}
