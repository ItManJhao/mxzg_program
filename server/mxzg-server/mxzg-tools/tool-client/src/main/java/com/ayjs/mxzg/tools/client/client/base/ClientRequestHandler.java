package com.ayjs.mxzg.tools.client.client.base;

import com.ayjs.mxzg.common.util.MessageUtils;
import com.ayjs.mxzg.tools.client.client.network.ClientSession;
import com.google.protobuf.Message;

/**
 * 客户端消息前对消息进行加工处理
 *
 * @author tangyangbo 2019/9/6 17:38
 */
public interface ClientRequestHandler<Req extends Message.Builder> {

    String PLAYER_PARAMETER = "rid";
    String USER_ID_PARAMETER = "user_id";
    String HERO_ID = "hero_id";

    int getMessageId();

    default void handler(ClientSession client, Req req) {
        MessageUtils.setMessageBuilderFieldValue(req, USER_ID_PARAMETER, client.getUserId());
        Object heroId = MessageUtils.getMessageBuilderFieldValue(req, HERO_ID);
        if (heroId != null)
            MessageUtils.setMessageBuilderFieldValue(req, HERO_ID, client.getReplaceHeroId((Long) heroId));
        customHandler(client, req);
    }

    void customHandler(ClientSession client, Req req);
}
