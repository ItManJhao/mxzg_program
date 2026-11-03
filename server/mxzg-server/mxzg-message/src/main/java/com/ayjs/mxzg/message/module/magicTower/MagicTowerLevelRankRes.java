package com.ayjs.mxzg.message.module.magicTower;

import com.ayjs.rpc.RemoteMessage;
import lombok.Value;

/**
 * @Author: CWJ
 * @Date: 2021/6/19
 **/
@Value(staticConstructor = "of")
public class MagicTowerLevelRankRes implements RemoteMessage {

    private byte[] arena;

}
