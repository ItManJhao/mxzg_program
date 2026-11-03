package com.ayjs.mxzg.gameserver.module.crusadegroup.occupation.event;

import com.ayjs.mxzg.config.struct.GameEvent;
import lombok.Value;

/**
 * 神兵精华增加事件
 */
@Value(staticConstructor = "of")
public class ShenBinItemAddEvent {

    private long rid;//玩家id

    private long addNum;//添加数量

    private GameEvent gameEvent;//添加事件
}
