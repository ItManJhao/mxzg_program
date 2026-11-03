package com.ayjs.mxzg.gameserver.module.blessingPool.event;

import com.ayjs.mxzg.gameserver.module.blessingPool.domain.RareLogData;
import lombok.Value;

import java.util.List;

/**
 * 许愿池获得稀有物品事件
 *
 * @Author: CWJ
 * @Date: 2020/3/2
 **/
@Value(staticConstructor = "of")
public class BlessingPoolGetRareEvent {

    private int type;

    private List<RareLogData> rateItem;

}
