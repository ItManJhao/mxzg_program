package com.ayjs.mxzg.message.module.crusadegroup.map;

import com.ayjs.mxzg.message.largecross.CrusadeGroupMessage;
import lombok.Value;

/**
 * 神兵精华同步
 */
@Value(staticConstructor = "valueOf")
public class EssenceSynchMessage implements CrusadeGroupMessage {

    private long rid;

    private int essence;  // 神兵精华

}
