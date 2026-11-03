package com.ayjs.mxzg.message.module.stagematch;

import com.ayjs.rpc.RemoteMessage;

/**
 * 赛季信息响应
 */
public class SeasonResMessage implements RemoteMessage {

    /**
     * 赛季
     */
    private int season;

    /**
     * 阶段类型
     */
    private int stageType;

    /**
     * 开始时间
     */
    private int startTime;

    /**
     * 结束时间
     */
    private int endTime;

    public static SeasonResMessage getInstance(){
        return new SeasonResMessage();
    }

}
