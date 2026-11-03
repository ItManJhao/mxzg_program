package com.ayjs.mxzg.tools.client.stresstest.handler.resp;

import com.ayjs.mxzg.protocol.HeroGMsg;
import com.ayjs.mxzg.tools.client.client.ClientCMD;
import com.ayjs.mxzg.tools.client.client.base.ClientResponseHandler;
import com.ayjs.mxzg.tools.client.client.network.ClientSession;

public class CmdGResHeroSummonHandler implements ClientResponseHandler<HeroGMsg.GResHeroSummon> {
    @Override
    public int getMessageId() {
        return ClientCMD.HERO_SUMMON;
    }

    @Override
    public void handler(ClientSession client, HeroGMsg.GResHeroSummon msg) {
        msg.getListList().forEach(client::putHeroToMap);
    }
}
