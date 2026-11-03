package com.ayjs.mxzg.message.module.stagematch.preliminaries;

import com.ayjs.mxzg.message.largecross.LargeCrossMessage;
import lombok.Getter;
import lombok.Setter;
import lombok.Value;

/**
 * 请求，刷新跨服天梯自己的防守队伍
 */
@Getter
@Setter
@Value(staticConstructor = "of")
public class PreliminariesDefendersReqMessage implements LargeCrossMessage {
    /**
     * 角色ID
     */
    private long rid;

    /***
     * 服务器id
     */
    private int serverId;

}
