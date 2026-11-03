package com.ayjs.mxzg.message.module.stagematch;

import com.ayjs.mxzg.message.largecross.LargeCrossMessage;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

/**
 * 响应段位赛信息
 */
@Getter
@Setter
public class StageMatchResMessage implements LargeCrossMessage {

    /**
     * 序列号
     */
    private int serialNumber;
    /**
     * 赛季id
     */
    private int seasonId;

    /**
     * 阶段类型
     */
    private int stageType;

    /**
     * 赛季开始时间
     */
    private LocalDateTime startTime;

    /**
     * 赛季结束时间
     */
    private LocalDateTime endTime;

    public static StageMatchResMessage getInstance(){
        return new StageMatchResMessage();
    }

    public static StageMatchResMessage valueOf(int serialNumber, int seasonId, int stageType, LocalDateTime startTime, LocalDateTime endTime){
        StageMatchResMessage message = new StageMatchResMessage();
        message.setSerialNumber(serialNumber);
        message.setSeasonId(seasonId);
        message.setStageType(stageType);
        message.setStartTime(startTime);
        message.setEndTime(endTime);
        return message;
    }

}
