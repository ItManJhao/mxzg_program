package com.ayjs.mxzg.message.module.rank;

import com.ayjs.mxzg.message.cross.CrossMessage;
import com.ayjs.mxzg.message.module.rank.dto.CrossCruGroupItem;
import lombok.Value;

import java.util.List;
/**
 * 跨服讨伐团神兵精华榜 推送给游戏服
 *
 **/
@Value(staticConstructor = "createOf")
public class ResCrossCGItemRankMessage implements CrossMessage {
    private List<CrossCruGroupItem> ranks;
}
