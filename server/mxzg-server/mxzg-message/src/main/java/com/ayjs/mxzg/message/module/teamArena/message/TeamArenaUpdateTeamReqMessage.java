package com.ayjs.mxzg.message.module.teamArena.message;

import com.ayjs.mxzg.message.cross.CrossMessage;
import com.ayjs.mxzg.message.module.teamArena.domain.ArenaTeamData;
import lombok.Value;

import java.util.List;

/**
 * 更新队伍信息
 *
 * @Author: CWJ
 * @Date: 2020/4/10
 **/
@Value(staticConstructor = "createOf")
public class TeamArenaUpdateTeamReqMessage implements CrossMessage {

    private List<ArenaTeamData> updates;

}
