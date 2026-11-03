package com.ayjs.mxzg.message.module.stagematch;

import com.ayjs.mxzg.message.largecross.LargeCrossMessage;
import lombok.Getter;
import lombok.Setter;

/**
 * 响应战斗结果
 */
@Getter
@Setter
public class NextStageMessage implements LargeCrossMessage {


    public static NextStageMessage getInstance(){
        return new NextStageMessage();
    }
}
