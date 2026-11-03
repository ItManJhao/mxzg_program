package com.ayjs.mxzg.message.module.crusadegroup.map;

import com.ayjs.mxzg.message.largecross.CrusadeGroupMessage;
import lombok.Value;

@Value(staticConstructor = "valueOf")
public class TerritoryUpdateMessage implements CrusadeGroupMessage {

    /**
     * 领地
     */
    private int territoryId;

    /**
     * 元素
     */
    private int element;

    /**
     * 占领id
     */
    private long occupiedId;

    /**
     * 开垦的英雄id，为0则为开垦，
     */
    private long heroId;


}
