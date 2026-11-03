package com.ayjs.mxzg.tools.client.client.base;

import com.ayjs.mxzg.tools.client.client.network.ClientSession;
import com.google.protobuf.MessageLite;

/**
 * handler管理
 *
 * @author tangyangbo 2019/8/6 17:06
 */
public interface ClientResponseHandler<Rsp extends MessageLite> {

    int getMessageId();

    void handler(ClientSession client, Rsp rsp);
}
