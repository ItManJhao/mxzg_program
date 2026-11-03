package com.ayjs.mxzg.message.module.promotion092.message;

import com.ayjs.mxzg.message.largecross.LargeCrossMessage;
import lombok.Value;

import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2021/1/6
 **/
@Value(staticConstructor = "of")
public class Promotion092StatusReqMessage implements LargeCrossMessage {
    private List<Integer> serverIds;
    private int status;
    private int startTime;
}
