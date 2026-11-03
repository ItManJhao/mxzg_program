package com.ayjs.mxzg.message.center;

import lombok.Value;

/**
 * 请求跨服服务器信息
 */
@Value(staticConstructor = "of")
public class RequestCrossServerInfoMessage implements CenterServerMessage {

    /**
     * 分区id
     */
    private int serverId;

    /**
     * 带上更新一次服务器信息
     */
    private ReportServerInfoMessage message;

}
