package com.ayjs.mxzg.tools.client.stresstest.handler.resp;

import com.ayjs.mxzg.protocol.PvpGMsg;
import com.ayjs.mxzg.tools.client.client.ClientCMD;
import com.ayjs.mxzg.tools.client.client.base.ClientResponseHandler;
import com.ayjs.mxzg.tools.client.client.network.ClientSession;

/**
 * @Author: CWJ
 * @Date: 2019/12/6
 **/
public class CmdResPvpDataHandler implements ClientResponseHandler<PvpGMsg.GResPvpData> {
    @Override
    public int getMessageId() {
        return ClientCMD.PVP_DATA;
    }

    @Override
    public void handler(ClientSession client, PvpGMsg.GResPvpData res) {
        client.setPvpList(res.getListList());
    }
}
