package com.ayjs.mxzg.message.module.teamArena.message;

import com.ayjs.mxzg.message.cross.RemoteServerMessage;
import lombok.Getter;
import lombok.Setter;

/**
 * 请求队伍阵容数据
 * @Author: CWJ
 * @Date: 2020/4/10
 **/
@Getter
@Setter
public class TeamArenaLineUpReqMessage implements RemoteServerMessage {

    private long teamId;
    private int serverId;
    private long attackTeam;

    @Override
    public int serverId() {
        return serverId;
    }
}
