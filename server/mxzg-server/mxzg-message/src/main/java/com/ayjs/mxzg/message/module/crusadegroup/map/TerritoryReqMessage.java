package com.ayjs.mxzg.message.module.crusadegroup.map;

import com.ayjs.mxzg.message.largecross.CrusadeGroupMessage;
import lombok.Value;

/**
 * 请求领地信息
 */
@Value(staticConstructor = "valueOf")
public class TerritoryReqMessage implements CrusadeGroupMessage {

    private int territoryId;    //领地id

}
