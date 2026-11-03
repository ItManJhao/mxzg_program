package com.ayjs.mxzg.gameserver.module.targetCounter.event;

import com.ayjs.mxzg.config.struct.TargetStruct;
import lombok.Value;

/**
 * 玩家触发目标事件
 *
 * @Author: CWJ
 * @Date: 2020/8/7
 **/
@Value(staticConstructor = "of")
public class RoleTriggerTargetEvent {
    /**
     * 触发者
     */
    private long rid;
    /**
     * 触发目标
     */
    private TargetStruct targetStruct;
    /**
     * 触发次数
     */
    private long triggerCount;

    /**
     * 触发次数
     */
    private MethodName addOrSet;

    public enum MethodName {
        ADD,
        SET,
    }
}


