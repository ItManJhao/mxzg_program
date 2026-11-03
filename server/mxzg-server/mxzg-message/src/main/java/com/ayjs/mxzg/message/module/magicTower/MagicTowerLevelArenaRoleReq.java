package com.ayjs.mxzg.message.module.magicTower;

import com.ayjs.mxzg.message.cross.PlayerCrossMessage;
import lombok.Value;

/**
 * 请求擂主
 *
 * @Author: CWJ
 * @Date: 2021/6/19
 **/
@Value(staticConstructor = "of")
public class MagicTowerLevelArenaRoleReq implements PlayerCrossMessage {

    private long rid;
    private int level;

    @Override
    public long getRid() {
        return rid;
    }
}
