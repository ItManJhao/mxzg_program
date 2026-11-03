package com.ayjs.mxzg.gameserver.module.dailydungeon.event;

import com.ayjs.mxzg.gameserver.module.dailydungeon.constant.DailyDungeonType;
import lombok.Value;

/**
 * 挑战日常副本
 * @Author: CWJ
 * @Date: 2019/10/19
 **/
@Value(staticConstructor = "of")
public class JoinDailyDungeonEvent {
    private long rid;

    private DailyDungeonType dailyDungeonType;

}
