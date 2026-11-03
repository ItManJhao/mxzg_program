package com.ayjs.mxzg.message.module.crusadegroup.group;

import com.ayjs.mxzg.message.cross.PlayerCrossMessage;
import com.ayjs.mxzg.message.largecross.CrusadeGroupMessage;
import lombok.Value;

/**
 * 报名
 */
@Value(staticConstructor = "valueOf")
public class RegistrationReqMessage implements CrusadeGroupMessage, PlayerCrossMessage {

    /**
     * 报名的玩家id
     */
    private long rid;

    /**
     * 团徽
     */
    private int emblem;
}
