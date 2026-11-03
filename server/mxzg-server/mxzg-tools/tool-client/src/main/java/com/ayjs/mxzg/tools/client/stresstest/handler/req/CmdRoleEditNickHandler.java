package com.ayjs.mxzg.tools.client.stresstest.handler.req;

import com.ayjs.mxzg.common.util.MessageUtils;
import com.ayjs.mxzg.protocol.RoleGMsg;
import com.ayjs.mxzg.tools.client.client.ClientCMD;
import com.ayjs.mxzg.tools.client.client.base.ClientRequestHandler;
import com.ayjs.mxzg.tools.client.client.network.ClientSession;

/**
 * 重命名
 */
public class CmdRoleEditNickHandler implements ClientRequestHandler<RoleGMsg.GReqRoleEditNick.Builder> {

    private static String NICK = "nick";

    @Override
    public int getMessageId() {
        return ClientCMD.CHANGE_NICKNAME;
    }

    @Override
    public void customHandler(ClientSession client, RoleGMsg.GReqRoleEditNick.Builder builder) {
        MessageUtils.setMessageBuilderFieldValue(builder, NICK, client.getOpenid());
    }
}
