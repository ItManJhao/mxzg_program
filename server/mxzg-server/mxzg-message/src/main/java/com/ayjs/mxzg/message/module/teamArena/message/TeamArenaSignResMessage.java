package com.ayjs.mxzg.message.module.teamArena.message;

import com.ayjs.mxzg.message.module.teamArena.domain.TeamArenaRankData;
import com.ayjs.rpc.RemoteMessage;
import lombok.Value;

import java.util.List;

/**
 * 报名
 *
 * @Author: CWJ
 * @Date: 2020/4/10
 **/
@Value(staticConstructor = "createOf")
public class TeamArenaSignResMessage implements RemoteMessage {

    private List<TeamArenaRankData> defend;

}
