package com.ayjs.mxzg.message.module.rank;

import com.ayjs.mxzg.message.cross.CrossMessage;
import com.ayjs.mxzg.message.module.rank.dto.CrossCruGroupHurt;
import lombok.Value;

import java.util.List;

/**
 * 跨服讨伐团boss伤害榜 推送给游戏服
 *
 **/
@Value(staticConstructor = "createOf")
public class ResCrossCGHurtRankMessage implements CrossMessage {
    private List<CrossCruGroupHurt> ranks;
}
