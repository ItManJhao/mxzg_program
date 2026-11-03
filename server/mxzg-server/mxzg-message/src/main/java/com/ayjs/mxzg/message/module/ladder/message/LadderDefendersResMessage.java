package com.ayjs.mxzg.message.module.ladder.message;

import com.ayjs.rpc.RemoteMessage;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

/**
 * 跨服天梯自己的防守队伍响应消息
 *
 */
@Getter
@Setter
public class LadderDefendersResMessage implements RemoteMessage {
    /**
     * 防守信息
     */
    private List<LadderDefenderData> defenders;
}
