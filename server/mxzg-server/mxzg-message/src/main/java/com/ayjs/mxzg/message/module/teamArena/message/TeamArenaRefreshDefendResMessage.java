package com.ayjs.mxzg.message.module.teamArena.message;

import com.ayjs.mxzg.message.module.teamArena.domain.TeamArenaRankData;
import com.ayjs.rpc.RemoteMessage;
import lombok.Value;

import java.util.List;

/**
 * 刷新防守列表返回
 * @Author: CWJ
 * @Date: 2020/4/10
 **/
@Value(staticConstructor = "createOf")
public class TeamArenaRefreshDefendResMessage implements RemoteMessage {

    private List<TeamArenaRankData> defend;

}
