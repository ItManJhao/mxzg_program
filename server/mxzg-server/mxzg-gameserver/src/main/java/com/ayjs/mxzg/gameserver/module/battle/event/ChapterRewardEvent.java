package com.ayjs.mxzg.gameserver.module.battle.event;

import lombok.Value;

/**
 * 主线关卡领奖事件
 *
 * @Author: CWJ
 * @Date: 2019/11/12
 **/
@Value(staticConstructor = "of")
public class ChapterRewardEvent {

    private long rid;
    /***
     * 配置id
     */
    private int chapterId;

}
