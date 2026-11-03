package com.ayjs.mxzg.message.module.stagematch.preliminaries;

import com.ayjs.mxzg.message.cross.RemoteServerMessage;
import lombok.Value;


@Value(staticConstructor = "of")
public class PreliminariesGetLineUpReqMessage implements RemoteServerMessage {

    private long rid;

    private int serverId;

    @Override
    public int serverId() {
        return serverId;
    }
}
