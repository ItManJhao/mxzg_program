package com.ayjs.mxzg.message.module.stagematch;

import com.ayjs.mxzg.message.cross.RemoteServerMessage;
import lombok.Getter;
import lombok.Setter;

/**
 * 赛季结算
 */
@Getter
@Setter
public class RankSettlementMessage implements RemoteServerMessage {
    /**
     * 玩家id
     */
    private long rid;

    /** 分区id */
    private int serverId;

    /** 排行 */
    private int rank;


    public static RankSettlementMessage createOf(long rid, int serverId, int rank){
        RankSettlementMessage message = new RankSettlementMessage();
        message.setRank(rank);
        message.setRid(rid);
        message.setServerId(serverId);
        return message;
    }

    @Override
    public int serverId() {
        return serverId;
    }
}
