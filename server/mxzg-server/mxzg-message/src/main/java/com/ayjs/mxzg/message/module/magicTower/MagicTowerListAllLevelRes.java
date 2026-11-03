package com.ayjs.mxzg.message.module.magicTower;

import com.ayjs.mxzg.message.cross.CrossMessage;
import lombok.Value;

import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2021/6/19
 **/
@Value(staticConstructor = "of")
public class MagicTowerListAllLevelRes implements CrossMessage {

    /**
     * 擂主列表
     */
    private List<byte[]> arenaList;

    private List<byte[]> passData;

}
