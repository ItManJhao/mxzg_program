package com.ayjs.rpc.forward;

import com.ayjs.rpc.RemoteMessage;
import com.ayjs.rpc.client.Request;
import com.ayjs.rpc.server.Connection;

import java.util.Collection;

/**
 * 消息转发器接口
 */
public interface MessageForwarder<T extends RemoteMessage> {

    /**
     * 转发消息
     *
     * @param request
     * @param connection
     * @return 返回转发的目的地ClientId列表
     */
    Collection<Integer> forward(Request request, Connection connection);
}
