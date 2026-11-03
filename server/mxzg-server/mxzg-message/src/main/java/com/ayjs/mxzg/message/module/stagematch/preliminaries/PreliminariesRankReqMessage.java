package com.ayjs.mxzg.message.module.stagematch.preliminaries;

import com.ayjs.mxzg.message.largecross.LargeCrossMessage;
import lombok.Value;

/**
 * 请求某个角色排名
 */
@Value(staticConstructor = "of")
public class PreliminariesRankReqMessage implements LargeCrossMessage {
    /**
     * 角色id
     */
    private long rid;
    /**
     * 服务器id
     */
    private int serverId;
}
