package com.ayjs.mxzg.gameserver.remote.large.event;

import lombok.Value;

/**
 * 跨服连接成功事件
 *
 * @Author: CWJ
 * @Date: 2020/6/20
 **/
@Value(staticConstructor = "of")
public class StageCrossConnectEvent {

    private int groupId;
}
