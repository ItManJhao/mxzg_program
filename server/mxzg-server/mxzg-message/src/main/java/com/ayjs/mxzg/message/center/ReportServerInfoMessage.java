package com.ayjs.mxzg.message.center;

import lombok.Getter;
import lombok.Value;

import java.time.LocalDateTime;

/**
 * 报告服务器信息
 */
@Getter
@Value(staticConstructor = "of")
public class ReportServerInfoMessage implements CenterServerMessage {

    /**
     * 服务器id
     */
    private Integer[] serverId;
    /**
     * 世界等级
     */
    private int worldLevel;
    /**
     * 获取的玩家数
     */
    private int activePlayersNumber;
    /**
     * 开服时间
     */
    private LocalDateTime openServerTime;

}
