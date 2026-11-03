package com.ayjs.mxzg.message.module.ladder.message;

import com.ayjs.mxzg.message.cross.CrossMessage;
import lombok.Value;

/**
 * 请求天梯榜
 *
 * @Author: CWJ
 * @Date: 2020/1/4
 **/
@Value(staticConstructor = "of")
public class CrossLadderRankReqMessage implements CrossMessage {
    /**
     * 服务器id
     */
    private int serverId;
}
