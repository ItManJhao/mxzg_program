package com.ayjs.mxzg.message.module.rank;

import com.ayjs.mxzg.message.cross.CrossMessage;
import com.ayjs.mxzg.message.module.rank.dto.CrossCruGroupHurtP;

import lombok.Value;

import java.util.List;
import java.util.Map;

/**
 * 跨服讨伐团玩家boss伤害榜 推送给游戏服
 *
 **/
@Value(staticConstructor = "createOf")
public class ResCrossCGHurtPRankMessage implements CrossMessage {
    private Map<Integer, List<CrossCruGroupHurtP>> cg_ranks;//key:讨伐团id  value：讨伐团内部玩家排行
}
