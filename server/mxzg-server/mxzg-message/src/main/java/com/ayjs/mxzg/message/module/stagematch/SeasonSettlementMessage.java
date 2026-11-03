package com.ayjs.mxzg.message.module.stagematch;

import com.ayjs.rpc.RemoteMessage;
import lombok.Getter;
import lombok.Setter;

/**
 * 赛季结算
 */
@Getter
@Setter
public class SeasonSettlementMessage implements RemoteMessage {
    /**
     * 赛季
     */
    private int season;

    public static SeasonSettlementMessage createOf(int season){
        SeasonSettlementMessage message = new SeasonSettlementMessage();
        message.setSeason(season);
        return message;
    }

}
