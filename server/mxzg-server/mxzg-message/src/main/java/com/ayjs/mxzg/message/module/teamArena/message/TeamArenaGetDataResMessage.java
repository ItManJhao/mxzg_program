package com.ayjs.mxzg.message.module.teamArena.message;

import com.ayjs.mxzg.message.cross.CrossMessage;
import com.ayjs.mxzg.message.module.teamArena.domain.TeamArenaRankData;
import lombok.Getter;
import lombok.Value;

import java.util.List;

/**
 * 组队竞技场排行榜更新
 *
 * @Author: CWJ
 * @Date: 2020/4/10
 **/
@Getter
@Value(staticConstructor = "createOf")
public class TeamArenaGetDataResMessage implements CrossMessage {

    private List<TeamArenaRankData> ranks;

    private boolean replaceAll;

}
