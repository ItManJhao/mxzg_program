package com.ayjs.mxzg.gameserver.module.targetCounter.event;

import com.ayjs.mxzg.config.struct.TargetType;
import lombok.Value;

/**
 * 玩家计数改变
 *
 * @Author: CWJ
 * @Date: 2019/11/13
 **/
@Value(staticConstructor = "of")
public class TaskCountChangeEvent {

    private long rid;
    private TargetType targetType;
    private int condition;
    private int subCondition;
    private long changeValue;
    private long newValue;
}
