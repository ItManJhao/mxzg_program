package com.ayjs.mxzg.message.module.magicTower;

import com.ayjs.mxzg.message.cross.CrossMessage;
import lombok.Value;

/**
 * @Author: CWJ
 * @Date: 2021/6/19
 **/
@Value(staticConstructor = "of")
public class MagicTowerPassLevelReq implements CrossMessage {

    private long rid;
    private int level;
    private int passTime;
    private long fighting;
    private String battleId;
}
