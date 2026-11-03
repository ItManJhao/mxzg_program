package com.ayjs.mxzg.tools.client.stresstest.handler.resp;

import com.ayjs.mxzg.protocol.PvpGMsg;
import com.ayjs.mxzg.tools.client.client.ClientCMD;
import com.ayjs.mxzg.tools.client.client.base.ClientResponseHandler;
import com.ayjs.mxzg.tools.client.client.network.ClientSession;
import lombok.extern.slf4j.Slf4j;

/**
 * @Author: CWJ
 * @Date: 2019/12/6
 **/
@Slf4j
public class CmdResPvpPlayerRefreshHandler implements ClientResponseHandler<PvpGMsg.GResPvpPlayerRefresh> {

    @Override
    public int getMessageId() {
        return ClientCMD.PVP_REFRESH;
    }

    @Override
    public void handler(ClientSession client, PvpGMsg.GResPvpPlayerRefresh res) {
        client.setPvpList(res.getListList());
    }
}
