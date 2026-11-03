package com.ayjs.mxzg.message.module.stagematch;

import com.ayjs.rpc.RemoteMessage;
import lombok.Getter;
import lombok.Setter;

/**
 * 段位赛完成
 */
@Getter
@Setter
public
class StageMathFinishMessage implements RemoteMessage {

    /**
     * 流水号
     */
    private int serialNumber;

    /**
     * 赛季
     */
    private int season;


    public static StageMathFinishMessage valueOf(int serialNumber){
        StageMathFinishMessage message = new StageMathFinishMessage();
        message.setSerialNumber(serialNumber);
        return message;
    }

}
