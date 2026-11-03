package com.ayjs.mxzg.message.module.teamArena.message;

import com.ayjs.mxzg.message.cross.CrossMessage;
import lombok.Getter;
import lombok.Setter;

/**
 * 请求战斗
 * @Author: CWJ
 * @Date: 2020/4/10
 **/
@Getter
@Setter
public class TeamArenaBattleReqMessage implements CrossMessage {

    private long teamId;
    private long defendTeamId;
    private boolean win;

}
