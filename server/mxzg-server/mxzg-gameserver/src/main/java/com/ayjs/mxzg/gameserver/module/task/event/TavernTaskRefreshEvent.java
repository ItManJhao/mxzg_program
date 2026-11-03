package com.ayjs.mxzg.gameserver.module.task.event;

import lombok.Value;

/**
 * @Author: CWJ
 * @Date: 2019/10/27
 **/
@Value(staticConstructor = "of")
public class TavernTaskRefreshEvent {
    private long rid;
    //刷新次数
    private int count;
    //1.钱,2道具
    private int costType;
}
