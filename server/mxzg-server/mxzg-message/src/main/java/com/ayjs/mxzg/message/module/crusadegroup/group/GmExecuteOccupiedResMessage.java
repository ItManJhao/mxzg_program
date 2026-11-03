package com.ayjs.mxzg.message.module.crusadegroup.group;

import com.ayjs.mxzg.message.largecross.CrusadeGroupMessage;
import lombok.Value;

/**
 * 占领
 */
@Value(staticConstructor = "valueOf")
public class GmExecuteOccupiedResMessage implements CrusadeGroupMessage {

    private int territoryId;

    private int element;

}
