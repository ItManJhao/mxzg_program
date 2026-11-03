package com.ayjs.mxzg.message.module.stagematch;

import com.ayjs.mxzg.message.module.stagematch.dto.OpponentDto;
import com.ayjs.rpc.RemoteMessage;
import lombok.Getter;
import lombok.Setter;

/**
 * 大神风采消息
 */
@Setter
@Getter
public class GreatStyleMessage implements RemoteMessage {
    private byte[] report;    //日志
    private OpponentDto attacker;  //攻方
    private OpponentDto defender;  //守方

    public static GreatStyleMessage createOf(byte[] report, OpponentDto attacker, OpponentDto defender){
        GreatStyleMessage message = new GreatStyleMessage();
        message.setReport(report);
        message.setAttacker(attacker);
        message.setDefender(defender);
        return message;
    }
}
