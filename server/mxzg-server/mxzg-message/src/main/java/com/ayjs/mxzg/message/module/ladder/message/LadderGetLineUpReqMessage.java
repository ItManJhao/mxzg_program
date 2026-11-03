package com.ayjs.mxzg.message.module.ladder.message;

import com.ayjs.mxzg.message.cross.RemoteServerMessage;
import lombok.Value;

/**
 * @Author: CWJ
 * @Date: 2020/1/3
 **/
@Value(staticConstructor = "of")
public class LadderGetLineUpReqMessage implements RemoteServerMessage {

    private long rid;

    private int serverId;

    private long defendRid;

    private int defendServerId;

    @Override
    public int serverId() {
        return defendServerId;
    }
}
