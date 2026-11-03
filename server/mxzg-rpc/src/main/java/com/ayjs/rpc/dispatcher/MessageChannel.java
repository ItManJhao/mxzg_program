package com.ayjs.rpc.dispatcher;

import com.ayjs.rpc.RemoteMessage;
import com.ayjs.rpc.server.Connection;

import java.util.List;

/**
 * 消息通道接口
 * @author meiyc
 *
 */
public interface MessageChannel<T extends RemoteMessage> {

	
	/**
	 * 获取消息目的地连接
	 * @return
	 */
	List<Connection> getConnections(); 
}
