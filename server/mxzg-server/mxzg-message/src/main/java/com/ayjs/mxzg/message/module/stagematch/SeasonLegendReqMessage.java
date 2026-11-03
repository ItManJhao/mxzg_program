package com.ayjs.mxzg.message.module.stagematch;

import com.ayjs.mxzg.message.largecross.LargeCrossMessage;
import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 赛季传奇请求
 */
@Getter
@AllArgsConstructor
public class SeasonLegendReqMessage implements LargeCrossMessage {
    /**
     * 赛季
     */
    private int season;


    public static SeasonLegendReqMessage createOf(int season){
        return new SeasonLegendReqMessage(season);
    }

}
