package com.ayjs.mxzg.message.module.teamArena.message;

import com.ayjs.mxzg.message.cross.CrossMessage;
import com.ayjs.mxzg.message.module.teamArena.domain.TeamArenaState;
import lombok.Value;

/**
 * GM设置状态
 * @Author: CWJ
 * @Date: 2020/4/10
 **/
@Value(staticConstructor = "createOf")
public class TeamArenaGMReqMessage implements CrossMessage {

    private TeamArenaState state;
}
