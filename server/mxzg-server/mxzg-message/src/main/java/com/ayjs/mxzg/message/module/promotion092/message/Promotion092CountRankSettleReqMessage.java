package com.ayjs.mxzg.message.module.promotion092.message;

import com.ayjs.mxzg.message.largecross.LargeCrossMessage;
import lombok.Value;

/**
 * @Author: CWJ
 * @Date: 2021/1/6
 **/
@Value(staticConstructor = "of")
public class Promotion092CountRankSettleReqMessage implements LargeCrossMessage {
    private int serverId;
    private int startTime;
}
