package com.ayjs.mxzg.message.module.promotion092.message;

import com.ayjs.mxzg.message.largecross.LargeCrossMessage;
import lombok.Value;

import java.time.LocalDateTime;

/**
 * @Author: CWJ
 * @Date: 2021/1/6
 **/
@Value(staticConstructor = "of")
public class Promotion092DeliverReqMessage implements LargeCrossMessage {
    private long rid;
    private int addScore;
    private int heroType;
    private int count;
    private LocalDateTime rankTime;
}
