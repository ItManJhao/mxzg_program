package com.ayjs.mxzg.message.center;

import lombok.Value;

/**
 * 请求跨服分组信息
 */
@Value(staticConstructor = "of")
public class RequestCrossGroupMessage implements CenterServerMessage {

    /**
     * 跨服id
     */
    private int crossServerId;

}
