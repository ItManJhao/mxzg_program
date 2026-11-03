/**
 * 
 */
package com.ayjs.mxzg.gameserver.infrastructure.netty;

import com.ayjs.mxzg.common.netty.GameMessage;

/**
 * @author YY
 *
 */
public interface IPlayerActor {
	/**
	 * 处理消息
	 * @param message
	 */
	public void process(PlayerContext playerContext, GameMessage message);
}
