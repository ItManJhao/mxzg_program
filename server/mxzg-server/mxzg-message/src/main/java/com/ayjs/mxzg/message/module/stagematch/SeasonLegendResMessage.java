package com.ayjs.mxzg.message.module.stagematch;

import com.ayjs.mxzg.message.largecross.LargeCrossMessage;
import com.ayjs.mxzg.message.module.stagematch.dto.LegendInfo;
import lombok.AllArgsConstructor;
import lombok.Getter;

import java.util.Collections;
import java.util.List;

/**
 * 赛季传奇响应
 */
@Getter
@AllArgsConstructor
public class SeasonLegendResMessage implements LargeCrossMessage {
    /**
     * 赛季
     */
    private int season;

    /**
     * 传奇信息列表
     */
    private List<LegendInfo> legendInfos;


    public static SeasonLegendResMessage createOf(int season, List<LegendInfo> legendInfos){
        return new SeasonLegendResMessage(season, legendInfos);
    }

    public List<LegendInfo> getLegendInfos(){
        return this.legendInfos == null ? Collections.emptyList() : legendInfos;
    }

}
