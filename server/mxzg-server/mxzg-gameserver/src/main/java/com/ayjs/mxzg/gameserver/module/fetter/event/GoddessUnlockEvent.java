package com.ayjs.mxzg.gameserver.module.fetter.event;

import lombok.Value;

/**
 * 女神解锁事件
 *
 * @Author: CWJ
 * @Date: 2019/10/27
 **/
@Value(staticConstructor = "of")
public class GoddessUnlockEvent {
    private long rid;
    //女神的配置id
    private int configId;
}
