package com.ayjs.mxzg.message.module.ladder.message;

import com.ayjs.mxzg.message.cross.CrossMessage;
import lombok.Getter;
import lombok.Setter;
import lombok.Value;

/**
 * 请求某个角色排名
 */
@Value(staticConstructor = "of")
public class LadderRankReqMessage implements CrossMessage {
    /**
     * 角色id
     */
    private long rid;
    /**
     * 服务器id
     */
    private int serverId;
}
