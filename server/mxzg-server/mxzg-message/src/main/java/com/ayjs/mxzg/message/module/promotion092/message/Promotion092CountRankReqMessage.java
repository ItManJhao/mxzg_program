package com.ayjs.mxzg.message.module.promotion092.message;

import com.ayjs.mxzg.message.largecross.LargeCrossMessage;
import com.ayjs.rpc.RemoteMessage;
import lombok.Value;

/**
 * @Author: CWJ
 * @Date: 2021/1/6
 **/
@Value(staticConstructor = "of")
public class Promotion092CountRankReqMessage implements LargeCrossMessage {
    private int serverId;
    private int startTime;
}
