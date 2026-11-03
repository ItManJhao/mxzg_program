package com.ayjs.mxzg.message.module.magicTower;

import com.ayjs.mxzg.message.cross.RemoteServerMessage;
import lombok.Value;

/**
 * 请求擂主
 *
 * @Author: CWJ
 * @Date: 2021/6/19
 **/
@Value(staticConstructor = "of")
public class MagicTowerRemoteBattleReq implements RemoteServerMessage {

    private int serverId;
    private String battleId;

    @Override
    public int serverId() {
        return serverId;
    }
}
