package com.ayjs.mxzg.tools.client.stresstest.handler.resp;

import com.ayjs.mxzg.protocol.HeroGMsg;
import com.ayjs.mxzg.tools.client.client.ClientCMD;
import com.ayjs.mxzg.tools.client.client.base.ClientResponseHandler;
import com.ayjs.mxzg.tools.client.client.network.ClientSession;
import lombok.extern.slf4j.Slf4j;

import java.util.Map;

/**
 * 英雄数据
 */
@Slf4j
public class CmdGResHeroAddHandler implements ClientResponseHandler<HeroGMsg.GResHeroAdd> {
    @Override
    public int getMessageId() {
        return ClientCMD.HERO_ADD;
    }

    @Override
    public void handler(ClientSession client, HeroGMsg.GResHeroAdd msg) {

        Map<Long, HeroGMsg.ResHeroData> heroDataMap = client.getHeroDataMap();
        msg.getHerosList().forEach(client::putHeroToMap);
    }
}
