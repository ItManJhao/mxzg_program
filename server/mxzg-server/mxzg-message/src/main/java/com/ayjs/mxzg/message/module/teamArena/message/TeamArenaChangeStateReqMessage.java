package com.ayjs.mxzg.message.module.teamArena.message;

import com.ayjs.mxzg.message.cross.CrossMessage;
import com.ayjs.mxzg.message.module.teamArena.domain.TeamArenaTime;
import lombok.Value;

/**
 * 请求状态
 * @Author: CWJ
 * @Date: 2020/4/11
 **/
@Value(staticConstructor = "of")
public class TeamArenaChangeStateReqMessage implements CrossMessage {

    private TeamArenaTime time;


}
