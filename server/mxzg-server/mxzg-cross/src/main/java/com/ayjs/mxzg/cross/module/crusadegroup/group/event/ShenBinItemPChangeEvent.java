package com.ayjs.mxzg.cross.module.crusadegroup.group.event;

import lombok.Value;

/**
 * 神兵精华数量增加事件（玩家）
 *
 */
@Value(staticConstructor = "of")
public class ShenBinItemPChangeEvent {

    private long rid;//新增玩家

    private long nowNum;//当前数量

    private int serverId;//服務器id
}
