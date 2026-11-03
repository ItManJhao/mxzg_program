package com.ayjs.mxzg.message.module.magicTower;

import com.ayjs.mxzg.message.cross.CrossMessage;
import lombok.Value;

/**
 * 请求擂主阵容
 *
 * @Author: CWJ
 * @Date: 2021/6/19
 **/
@Value(staticConstructor = "of")
public class MagicTowerLevelArenaRoleRes implements CrossMessage {

    /***
     * 擂主信息
     */
    private byte[] arenaRole;

}
