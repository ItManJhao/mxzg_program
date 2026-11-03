package com.ayjs.mxzg.gameserver.module.task.event;

import lombok.Value;

import java.util.ArrayList;
import java.util.List;

/**
 * 酒馆任务领奖事件
 * @Author: CWJ
 * @Date: 2019/10/19
 **/
@Value(staticConstructor = "of")
public class TavernTaskRewardEvent {

    private long rid;
    //配置id
    private List<Integer> taskIds;
}
