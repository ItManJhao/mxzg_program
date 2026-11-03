package com.ayjs.mxzg.tools.client.stresstest.handler.req;

import com.ayjs.mxzg.common.util.MessageUtils;
import com.ayjs.mxzg.protocol.PvpGMsg;
import com.ayjs.mxzg.tools.client.client.ClientCMD;
import com.ayjs.mxzg.tools.client.client.base.ClientRequestHandler;
import com.ayjs.mxzg.tools.client.client.network.ClientSession;

/**
 * @Author: CWJ
 * @Date: 2019/12/6
 **/
public class CmdGReqPvpChallengeHandler implements ClientRequestHandler<PvpGMsg.GReqPvpBattle.Builder> {
    @Override
    public int getMessageId() {
        return ClientCMD.PVP_CHALLENGE;
    }

    @Override
    public void customHandler(ClientSession client, PvpGMsg.GReqPvpBattle.Builder builder) {
        if (client.getPvpList().size() > 0)
            MessageUtils.setMessageBuilderFieldValue(builder, "player_id", client.getPvpList().get(0).getPlayerId());
    }
}
