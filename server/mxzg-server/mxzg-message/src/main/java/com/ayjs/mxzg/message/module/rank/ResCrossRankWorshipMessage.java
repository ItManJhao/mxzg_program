package com.ayjs.mxzg.message.module.rank;

import com.ayjs.mxzg.message.cross.RemoteServerMessage;
import lombok.Value;

/**
 * 排行榜膜拜通知
 *
 * @Author: CWJ
 * @Date: 2019/12/18
 **/
@Value(staticConstructor = "createOf")
public class ResCrossRankWorshipMessage implements RemoteServerMessage {

    /***
     * 被膜拜者
     */
    private long worshiperRid;

    /***
     * 膜拜者服务器id
     */
    private int worshiperServerId;

    /***
     * 膜拜者名字
     */
    private String worshiperName;

    /***
     * 被膜拜者
     */
    private long beWorshipId;

    /**
     * 被膜拜的玩家分区id
     */
    private int beWorshipServerId;

    /***
     * 排行榜类型
     */
    private int type;


    @Override
    public int serverId() {
        return beWorshipServerId;
    }
}
