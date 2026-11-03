package com.ayjs.mxzg.tools.client.client.base;

import com.ayjs.mxzg.tools.client.client.network.ClientSession;
import com.google.protobuf.Message;

/**
 * 请求消息处理
 *
 * @author tangyangbo 2019/9/6 17:32
 */
public class DefaultClientRequestHandler<Req extends Message.Builder> implements ClientRequestHandler<Req> {
    @Override
    public int getMessageId() {
        return 0;
    }

    @Override
    public void customHandler(ClientSession client, Req req) {

    }
}
