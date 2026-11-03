package com.ayjs.mxzg.tools.client.stresstest.handler.resp;

import com.ayjs.mxzg.protocol.HeroGMsg;
import com.ayjs.mxzg.tools.client.client.ClientCMD;
import com.ayjs.mxzg.tools.client.client.base.ClientResponseHandler;
import com.ayjs.mxzg.tools.client.client.network.ClientSession;

public class CmdGResHeroListHandler implements ClientResponseHandler<HeroGMsg.GResHeroList> {
    @Override
    public int getMessageId() {
        return ClientCMD.HERO_LIST;
    }

    @Override
    public void handler(ClientSession client, HeroGMsg.GResHeroList msg) {
        msg.getListList().forEach(client::putHeroToMap);
    }
}
