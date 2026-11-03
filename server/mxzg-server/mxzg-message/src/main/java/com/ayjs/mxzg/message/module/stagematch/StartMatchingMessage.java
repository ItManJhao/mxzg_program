package com.ayjs.mxzg.message.module.stagematch;

import com.ayjs.mxzg.message.largecross.LargeCrossMessage;
import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 开启匹配
 */
@Getter
@AllArgsConstructor
public class StartMatchingMessage implements LargeCrossMessage {
    /**
     * 流水号
     */
    private int serialNumber;


    public static StartMatchingMessage createOf(int serialNumber){
        return new StartMatchingMessage(serialNumber);
    }

}
