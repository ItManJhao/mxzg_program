package com.ayjs.mxzg.cross.module.magicTower.event;

import lombok.Value;

/**
 * @Author: CWJ
 * @Date: 2021/6/21
 **/
@Value(staticConstructor = "of")
public class MagicTowerPassLevelEvent {
    private long rid;
}
