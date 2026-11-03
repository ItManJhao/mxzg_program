package com.ayjs.mxzg.message.module.teamArena.message;

import com.ayjs.mxzg.message.cross.CrossMessage;
import lombok.Builder;
import lombok.Getter;

/**
 * 刷新防守列表
 * @Author: CWJ
 * @Date: 2020/4/10
 **/
@Getter
@Builder
public class TeamArenaRefreshDefendReqMessage implements CrossMessage {

    private long teamId;

}
