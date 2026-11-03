package com.ayjs.mxzg.message.module.crusadegroup.map;

import com.ayjs.mxzg.message.largecross.CrusadeGroupMessage;
import lombok.Value;

/**
 * 请求Boss挑战记录
 */
@Value(staticConstructor = "valueOf")
public class ChallengeRecordReqMessage implements CrusadeGroupMessage {

    private int territoryId; // 领地id
}
