package com.ayjs.mxzg.gameserver.module.rank.event;

import com.ayjs.mxzg.common.top.TopResult;
import lombok.Value;

/**
 * 竞技场排名改变事件
 *
 * @Author: CWJ
 * @Date: 2019/11/14
 **/
@Value(staticConstructor = "of")
public class ArenaRankChangeEvent {

    private long rid;

    private TopResult rank;

}
