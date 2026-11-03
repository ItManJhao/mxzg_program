package com.ayjs.mxzg.message.module.crusadegroup.map;

import com.ayjs.mxzg.message.cross.PlayerCrossMessage;
import com.ayjs.mxzg.message.largecross.CrusadeGroupMessage;
import lombok.Value;

/**
 * 请求战报
 */
@Value(staticConstructor = "valueOf")
public class BattleReportReqMessage implements PlayerCrossMessage, CrusadeGroupMessage {

    private long rid;       //玩家id
    private String battleId;    //战场id

    @Override
    public long getRid(){
        return this.rid;
    }
}
