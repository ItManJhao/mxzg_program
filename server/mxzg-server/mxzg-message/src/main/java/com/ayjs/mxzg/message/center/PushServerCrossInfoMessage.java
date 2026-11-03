package com.ayjs.mxzg.message.center;

import lombok.Getter;
import lombok.Setter;

/**
 * 推送服务器的跨服信息到游戏服
 */
@Getter
@Setter
public class PushServerCrossInfoMessage implements CenterServerMessage {

    /**
     * 分组id
     */
    private int groupId;

    /**
     * 跨服地址
     */
    private String crossServerHost;

    /**
     * 跨服端口
     */
    private int port;

    public static PushServerCrossInfoMessage of(int groupId, String crossServerHost, int port) {
        PushServerCrossInfoMessage message = new PushServerCrossInfoMessage();
        message.setGroupId(groupId);
        message.setCrossServerHost(crossServerHost);
        message.setPort(port);
        return message;
    }

}
