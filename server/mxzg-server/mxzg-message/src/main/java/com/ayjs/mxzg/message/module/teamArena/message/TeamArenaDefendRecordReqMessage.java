package com.ayjs.mxzg.message.module.teamArena.message;

import com.ayjs.mxzg.message.cross.RemoteServerMessage;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

/**
 * 防守方增加战斗记录
 * @Author: CWJ
 * @Date: 2020/4/10
 **/
@Getter
@Setter
public class TeamArenaDefendRecordReqMessage implements RemoteServerMessage {
    private int serverId;

    private byte[] record;

    private List<byte[]> recordDetail;

    private List<byte[]> reports;

    @Override
    public int serverId() {
        return serverId;
    }
}
