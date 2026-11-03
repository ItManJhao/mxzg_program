package com.ayjs.mxzg.message.module.magicTower;

import com.ayjs.mxzg.message.cross.PlayerCrossMessage;
import lombok.Value;

/**
 * 擂主变更
 * @Author: CWJ
 * @Date: 2021/6/19
 **/
@Value(staticConstructor = "of")
public class MagicTowerLevelArenaChangeReq implements PlayerCrossMessage {

    private long rid;
    private int level;
    private long defendId;

}
