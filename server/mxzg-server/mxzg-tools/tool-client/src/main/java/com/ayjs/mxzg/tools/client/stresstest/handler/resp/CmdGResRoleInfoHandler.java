package com.ayjs.mxzg.tools.client.stresstest.handler.resp;

import com.ayjs.mxzg.protocol.RoleGMsg;
import com.ayjs.mxzg.tools.client.client.ClientCMD;
import com.ayjs.mxzg.tools.client.client.base.ClientResponseHandler;
import com.ayjs.mxzg.tools.client.client.network.ClientSession;

public class CmdGResRoleInfoHandler implements ClientResponseHandler<RoleGMsg.GResRoleInfo> {
    @Override
    public int getMessageId() {
        return ClientCMD.ROLE_INFO;
    }

    @Override
    public void handler(ClientSession client, RoleGMsg.GResRoleInfo msg) {
        client.setNickname(msg.getNick());
        client.setLevel(msg.getLevel());
    }
}
