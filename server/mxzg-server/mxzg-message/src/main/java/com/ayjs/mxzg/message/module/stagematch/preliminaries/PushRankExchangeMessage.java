package com.ayjs.mxzg.message.module.stagematch.preliminaries;

import com.ayjs.mxzg.message.module.stagematch.dto.RankDto;
import com.ayjs.rpc.RemoteMessage;
import lombok.Value;

/**
 * 推送排行变化
 */
@Value(staticConstructor = "of")
public class PushRankExchangeMessage implements RemoteMessage {

    /** 挑战者 */
    private RankDto challenger;

    /** 对手 */
    private RankDto opponent;

}
