package com.ayjs.mxzg.message.module.teamArena.message;

import com.ayjs.mxzg.message.cross.RemoteServerMessage;
import lombok.Getter;
import lombok.Setter;

/**
 * 请求成员阵容
 * @Author: CWJ
 * @Date: 2020/4/10
 **/
@Getter
@Setter
public class TeamArenaGetMemberLineUpReqMessage implements RemoteServerMessage {

    private long roleId;
    private int serverId;

    @Override
    public int serverId() {
        return serverId;
    }
}
