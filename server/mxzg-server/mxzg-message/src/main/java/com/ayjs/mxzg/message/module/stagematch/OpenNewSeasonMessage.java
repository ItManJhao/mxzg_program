package com.ayjs.mxzg.message.module.stagematch;

import com.ayjs.mxzg.message.largecross.LargeCrossMessage;
import lombok.AllArgsConstructor;
import lombok.Getter;

import java.time.LocalDateTime;

/**
 * 开启新赛季消息
 */
@Getter
@AllArgsConstructor
public class OpenNewSeasonMessage implements LargeCrossMessage {
    /**
     * 流水号
     */
    private int serialNumber;

    /**
     * 赛季
     */
    private int season;

    /**
     * 开启时间
     */
    private LocalDateTime startTime;

    /**
     * 结束时间
     */
    private LocalDateTime endTime;

    public static OpenNewSeasonMessage createOf(int serialNumber, int season, LocalDateTime startTime, LocalDateTime endTime){
        return new OpenNewSeasonMessage(serialNumber, season, startTime, endTime);
    }

}
