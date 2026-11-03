package com.ayjs.mxzg.cross.module.rank.event;

import com.ayjs.mxzg.message.module.floatingIslands.struct.RankData;
import com.ayjs.rpc.RemoteMessage;
import lombok.Value;

/**
 * @Author: CWJ
 * @Date: 2020/4/16
 **/
@Value(staticConstructor = "of")
public class TeamArenaRankPullToServerEvent implements RemoteMessage {
    private RankData crossRank;
    private int groupId;
    private int oldRank;
}
