package com.ayjs.mxzg.message.module.teamArena.message;

import com.ayjs.mxzg.message.cross.RemoteServerMessage;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

/**
 * 请求成员阵容返回
 * @Author: CWJ
 * @Date: 2020/4/10
 **/
@Getter
@Setter
public class TeamArenaGetMemberLineUpResMessage implements RemoteServerMessage {

    private long roleId;
    private int serverId;
    private List<byte[]> lineUp = new ArrayList<>();

    @Override
    public int serverId() {
        return serverId;
    }
}
