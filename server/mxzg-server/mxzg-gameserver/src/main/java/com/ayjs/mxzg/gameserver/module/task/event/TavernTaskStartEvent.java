package com.ayjs.mxzg.gameserver.module.task.event;

import lombok.Value;

/**
 * @Author: CWJ
 * @Date: 2019/10/19
 **/
@Value(staticConstructor = "of")
public class TavernTaskStartEvent {
    private long rid;

    //酒馆配置id
    private int taskId;
}
