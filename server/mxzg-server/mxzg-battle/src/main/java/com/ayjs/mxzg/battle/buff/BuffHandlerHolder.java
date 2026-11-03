package com.ayjs.mxzg.battle.buff;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.ayjs.mxzg.battle.buff.function.ClientBuffHandler;
import com.ayjs.mxzg.common.holder.AbstractHolder;
import com.ayjs.mxzg.config.struct.BuffType;

/**
 * Buff处理器持有者
 * @author meiyc
 *
 */
@Component
public class BuffHandlerHolder extends AbstractHolder<BuffType, BuffHandler> {

	@Autowired
	private ClientBuffHandler clientBuffHandler;
	
	@Override
	protected BuffType convert(BuffHandler bean) {
		return bean.getType();
	}
	
	/**
	 * 获取buff处理器
	 * @param key
	 * @return
	 */
	public BuffHandler getBuffHandler(BuffType key) {
		if(!key.isLogic()){
			return clientBuffHandler;
		}
		return super.getOrThrow(key);
	}
}
