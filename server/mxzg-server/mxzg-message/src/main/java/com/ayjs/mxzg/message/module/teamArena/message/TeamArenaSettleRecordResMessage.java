package com.ayjs.mxzg.message.module.teamArena.message;

import com.ayjs.mxzg.message.module.teamArena.domain.TeamArenaRankData;
import com.ayjs.rpc.RemoteMessage;
import lombok.Value;

import java.util.List;

/**
 * 请求结算记录返回
 * @Author: CWJ
 * @Date: 2020/4/11
 **/
@Value(staticConstructor = "of")
public class TeamArenaSettleRecordResMessage implements RemoteMessage {

    private List<TeamArenaRankData> rank;

    private int settleTime;


}
