package com.ayjs.mxzg.message.module.magicTower;

import com.ayjs.rpc.RemoteMessage;
import lombok.Value;

/**
 * 请求擂主
 *
 * @Author: CWJ
 * @Date: 2021/6/19
 **/
@Value(staticConstructor = "of")
public class MagicTowerRemoteBattleRes implements RemoteMessage {

    private byte[] battleReport;

}
