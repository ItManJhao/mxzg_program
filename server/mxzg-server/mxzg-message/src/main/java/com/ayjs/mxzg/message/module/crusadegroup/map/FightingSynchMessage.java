package com.ayjs.mxzg.message.module.crusadegroup.map;

import com.ayjs.mxzg.message.largecross.CrusadeGroupMessage;
import lombok.Value;

/**
 * 战力同步
 */
@Value(staticConstructor = "valueOf")
public class FightingSynchMessage implements CrusadeGroupMessage {

    private long rid;

    private int fighting;  // 战力同步

}
