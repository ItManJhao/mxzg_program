package com.ayjs.mxzg.message.module.stagematch;

import com.ayjs.mxzg.message.largecross.LargeCrossMessage;
import lombok.Getter;
import lombok.Setter;

/**
 * 响应战斗结果
 */
@Getter
@Setter
public class SetStageMessage implements LargeCrossMessage {

    private long rid;

    private int stageId;

    public static SetStageMessage valueOf(long rid, int stageId){
        SetStageMessage message = new SetStageMessage();
        message.setStageId(stageId);
        message.setRid(rid);
        return message;
    }
}
