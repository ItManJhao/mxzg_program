package com.ayjs.mxzg.message.module.stagematch;

import com.ayjs.mxzg.message.module.stagematch.dto.OpponentDto;
import com.ayjs.rpc.RemoteMessage;
import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 响应匹配对手信息
 */
@Getter
@AllArgsConstructor
public class MatchingResMessage implements RemoteMessage {

    private long rid;
    private OpponentDto opponentDto;   //对手
    private int autoBattleTime;   //自动进入战斗时间

    public static MatchingResMessage createOf(long rid, OpponentDto opponentDto, int autoBattleTime){
        return new MatchingResMessage(rid, opponentDto, autoBattleTime);
    }

    /**
     * 创建一个空的匹配结果
     * @return
     */
    public static MatchingResMessage createEmpty(){
        return createOf(0, null, 0);
    }

}
