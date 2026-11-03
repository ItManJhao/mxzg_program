package com.ayjs.mxzg.message.module.rank;

import com.ayjs.mxzg.message.cross.CrossMessage;
import com.ayjs.mxzg.message.module.rank.dto.CrossClanRank;
import lombok.Value;

import java.util.List;

/**
 * 跨服公会榜推送给游戏服
 *
 * @Author: CWJ
 * @Date: 2019/12/19
 **/
@Value(staticConstructor = "createOf")
public class ResCrossClanRankMessage implements CrossMessage {

    private List<CrossClanRank> ranks;
}
