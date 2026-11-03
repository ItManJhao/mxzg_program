package com.ayjs.mxzg.message.module.crusadegroup.map;

import com.ayjs.mxzg.message.largecross.CrusadeGroupMessage;
import lombok.Value;

@Value(staticConstructor = "valueOf")
public class GiveUpTerritoryReqMessage implements CrusadeGroupMessage {

    private int territoryId;    //领地id
}
