package com.ayjs.mxzg.message.module.study;

import com.ayjs.mxzg.message.cross.RemoteServerMessage;
import lombok.Value;

/**
 * 请求远程玩家信息
 */
@Value(staticConstructor = "of")
public class ReqBattlerVOMessage implements RemoteServerMessage {

    /** 对手id */
    private long opponentId;

    /** 分区id */
    private int serverId;

    private int type;

    @Override
    public int serverId() {
        return serverId;
    }
}
