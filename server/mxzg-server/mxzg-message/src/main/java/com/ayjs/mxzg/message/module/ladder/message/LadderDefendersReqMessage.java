package com.ayjs.mxzg.message.module.ladder.message;

import com.ayjs.mxzg.message.cross.CrossMessage;
import lombok.Getter;
import lombok.Setter;

/**
 * 请求，刷新跨服天梯自己的防守队伍
 */
@Getter
@Setter
public class LadderDefendersReqMessage implements CrossMessage {
    /**
     * 角色ID
     */
    private long rid;

    /***
     * 服务器id
     */
    private int serverId;

    /**
     * 战斗力
     */
    private long fighting; // 战斗力
}
