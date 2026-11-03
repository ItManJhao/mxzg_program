package com.ayjs.mxzg.message.module.magicTower;

import com.ayjs.mxzg.message.cross.CrossMessage;
import lombok.Value;

/**
 * 请求擂主
 *
 * @Author: CWJ
 * @Date: 2021/6/19
 **/
@Value(staticConstructor = "of")
public class MagicTowerLevelPassDetailReq implements CrossMessage {

    private int serverId;
    private int level;

}
