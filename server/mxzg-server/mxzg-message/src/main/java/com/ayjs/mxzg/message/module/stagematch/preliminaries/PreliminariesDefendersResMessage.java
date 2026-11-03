package com.ayjs.mxzg.message.module.stagematch.preliminaries;

import com.ayjs.mxzg.message.module.stagematch.dto.RankDto;
import com.ayjs.rpc.RemoteMessage;
import lombok.Getter;
import lombok.Setter;
import lombok.Value;

import java.util.List;

/**
 * 跨服天梯自己的防守队伍响应消息
 *
 */
@Getter
@Setter
@Value(staticConstructor = "of")
public class PreliminariesDefendersResMessage implements RemoteMessage {

    /**
     * 可以挑战的列表
     */
    private List<RankDto> defenders;
}
