package com.ayjs.mxzg.message.cross;

import com.ayjs.mxzg.message.center.dto.CrossGroup;
import com.ayjs.rpc.RemoteMessage;
import lombok.Value;

/**
 * 更新跨服组信息
 */
@Value(staticConstructor = "of")
public class UpdateCrossGroupMessage implements RemoteMessage {

    /**
     * 更新跨服组信息
     */
    private CrossGroup crossGroup;

}
