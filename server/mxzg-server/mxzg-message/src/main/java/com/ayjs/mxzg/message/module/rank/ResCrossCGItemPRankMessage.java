package com.ayjs.mxzg.message.module.rank;

import com.ayjs.mxzg.message.cross.CrossMessage;
import com.ayjs.mxzg.message.module.rank.dto.CrossCruGroupItemP;
import lombok.Value;

import java.util.List;
import java.util.Map;

/**
 * 跨服讨伐团 玩家神兵精华榜 推送给游戏服
 **/
@Value(staticConstructor = "createOf")
public class ResCrossCGItemPRankMessage implements CrossMessage {
    private Map<Integer, List<CrossCruGroupItemP>> cg_ranks;//key:讨伐团id  value：讨伐团内部玩家排行
}
