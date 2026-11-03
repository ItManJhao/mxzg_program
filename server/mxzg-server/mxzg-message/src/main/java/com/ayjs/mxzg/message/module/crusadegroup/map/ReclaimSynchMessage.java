package com.ayjs.mxzg.message.module.crusadegroup.map;

import com.ayjs.mxzg.message.largecross.CrusadeGroupMessage;
import lombok.Value;

/**
 * 领地开垦同步
 */
@Value(staticConstructor = "valueOf")
public class ReclaimSynchMessage implements CrusadeGroupMessage {

    private long rid;       //领地所有者

    private int territoryId;   // 领地

    private long heroId;  // 英雄id,英雄id为0则是放弃开垦

}
