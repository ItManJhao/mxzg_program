package com.ayjs.mxzg.message.module.hades.message;

import com.ayjs.mxzg.message.largecross.LargeCrossMessage;
import lombok.Value;

/**
 * @Author: CWJ
 * @Date: 2021/1/6
 **/
@Value(staticConstructor = "of")
public class HadesChallengeReqMessage implements LargeCrossMessage {
    private long rid;
    private int floor;
    private int type;
    private int fighting;
}
