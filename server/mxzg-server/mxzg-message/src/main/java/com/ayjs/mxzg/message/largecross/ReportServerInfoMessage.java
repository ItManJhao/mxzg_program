package com.ayjs.mxzg.message.largecross;

import lombok.Value;

/**
 * 推送服务器id
 *
 * @Author: CWJ
 * @Date: 2020/6/19
 **/
@Value(staticConstructor = "of")
public class ReportServerInfoMessage implements LargeCrossMessage {

    /**
     * 服务器id
     */
    private int serverId;
    /**
     * 所有的子服务器id列表，包含了主服
     */
    private Integer[] serverIds;
}
