package com.ayjs.mxzg.message.module.crusadegroup.map;

import com.ayjs.mxzg.message.largecross.CrusadeGroupMessage;
import lombok.Value;

/**
 * 爵位同步
 */
@Value(staticConstructor = "valueOf")
public class KnighthoodSynchMessage implements CrusadeGroupMessage {

    private long rid;

    private int knighthood_id;  // 爵位

}
