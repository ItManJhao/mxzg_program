package com.ayjs.mxzg.message.module.stagematch;

import com.ayjs.mxzg.message.cross.RemoteServerMessage;
import lombok.Value;

/**
 * @Author: CWJ
 * @Date: 2020/7/9
 **/
@Value(staticConstructor = "of")
public class SeasonDetailReqMessage implements RemoteServerMessage {

    private int serverId;

    private long rid;

    private int seasonId;

    @Override
    public int serverId() {
        return serverId;
    }
}
