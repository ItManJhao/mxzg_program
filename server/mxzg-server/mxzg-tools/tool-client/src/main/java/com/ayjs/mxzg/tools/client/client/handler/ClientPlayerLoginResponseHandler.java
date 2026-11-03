package com.ayjs.mxzg.tools.client.client.handler;

import com.ayjs.mxzg.protocol.LoginGMsg;
import com.ayjs.mxzg.tools.client.client.ClientCMD;
import com.ayjs.mxzg.tools.client.client.base.ClientResponseHandler;
import com.ayjs.mxzg.tools.client.client.network.ClientSession;
import com.ayjs.mxzg.tools.client.client.network.ConnectStatus;
import lombok.extern.slf4j.Slf4j;

/**
 * 登陆协议处理
 */
@Slf4j
public class ClientPlayerLoginResponseHandler implements ClientResponseHandler<LoginGMsg.GResLogin> {

    @Override
    public int getMessageId() {
        return ClientCMD.PLAYER_LOGIN_CMD;
    }

    @Override
    public void handler(ClientSession client, LoginGMsg.GResLogin msg) {
        if (msg.getRid() > 0) {
            client.setRid(msg.getRid());
            client.setNickname(String.valueOf(msg.getRid()));
            client.setConnectStatus(ConnectStatus.LOGGED_IN);
            client.setLastStateTime(0);
            log.info("openid:{} rid:{} login success.", client.getOpenid(), msg.getRid());
        } else {
            client.setConnectStatus(ConnectStatus.REGISTER_ROLE);
            client.setLastStateTime(0);
            log.info("openid:{} playerId:{} login failed. not player.", client.getOpenid(), msg.getRid());
        }

    }
}
