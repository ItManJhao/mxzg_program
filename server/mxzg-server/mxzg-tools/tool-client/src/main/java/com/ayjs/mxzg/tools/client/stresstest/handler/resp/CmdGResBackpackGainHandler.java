package com.ayjs.mxzg.tools.client.stresstest.handler.resp;

import com.ayjs.mxzg.protocol.BackPackGMsg;
import com.ayjs.mxzg.protocol.ObjectGMsg;
import com.ayjs.mxzg.tools.client.client.ClientCMD;
import com.ayjs.mxzg.tools.client.client.base.BackPack;
import com.ayjs.mxzg.tools.client.client.base.ClientResponseHandler;
import com.ayjs.mxzg.tools.client.client.network.ClientSession;

import java.util.List;
import java.util.Map;

/**
 * 背包数据
 */
public class CmdGResBackpackGainHandler implements ClientResponseHandler<BackPackGMsg.GResBackpackGain> {
    @Override
    public int getMessageId() {
        return ClientCMD.BACKPACK_GAIN;
    }

    @Override
    public void handler(ClientSession client, BackPackGMsg.GResBackpackGain msg) {

        Map<Integer, BackPack> backpackDataMap = client.getBackpackDataMap();
        List<ObjectGMsg.PSBackpackData> list = msg.getListList();

        list.forEach(psBackpackData -> {
            BackPack backPack = backpackDataMap.get(psBackpackData.getType());
            if (backPack == null) {
                backPack = new BackPack();
                backPack.setType(psBackpackData.getType());
                backpackDataMap.put(backPack.getType(), backPack);
            }
            backPack.setNum(backPack.getNum() + psBackpackData.getNum());
            if (backPack.getNum() <= 0) {
                backpackDataMap.remove(backPack.getType());
            }
        });

    }
}
