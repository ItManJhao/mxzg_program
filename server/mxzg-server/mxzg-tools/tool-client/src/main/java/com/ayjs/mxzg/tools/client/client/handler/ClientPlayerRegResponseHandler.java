package com.ayjs.mxzg.tools.client.client.handler;

import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.protocol.LoginGMsg;
import com.ayjs.mxzg.tools.client.client.ClientCMD;
import com.ayjs.mxzg.tools.client.client.base.ClientResponseHandler;
import com.ayjs.mxzg.tools.client.client.network.ClientSession;
import com.ayjs.mxzg.tools.client.client.network.ConnectStatus;
import lombok.extern.slf4j.Slf4j;

/**
 * 注册协议处理
 */
@Slf4j
public class ClientPlayerRegResponseHandler implements ClientResponseHandler<LoginGMsg.GResInit> {

    @Override
    public int getMessageId() {
        return ClientCMD.PLAYER_REG_CMD;
    }

    @Override
    public void handler(ClientSession client, LoginGMsg.GResInit msg) {
        log.info("client openid:{} msg sessionId:{}", client.getOpenid(), msg.getRid());
        if (client.getRid() > 0) {
            return;
        }
        if (msg.getRid() > 0) {
            client.setRid(msg.getRid());
            client.setConnectStatus(ConnectStatus.LOGIN_ROLE);
            client.setLastStateTime(0);
            client.setLoginTime(DateTimeUtil.currentSecond());
        }
    }
}
