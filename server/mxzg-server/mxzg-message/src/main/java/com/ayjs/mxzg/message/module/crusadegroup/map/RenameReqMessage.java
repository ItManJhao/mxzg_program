package com.ayjs.mxzg.message.module.crusadegroup.map;

import com.ayjs.mxzg.message.cross.PlayerCrossMessage;
import com.ayjs.mxzg.message.largecross.CrusadeGroupMessage;
import lombok.Value;

/**
 * 请求改名
 */
@Value(staticConstructor = "valueOf")
public class RenameReqMessage implements PlayerCrossMessage, CrusadeGroupMessage {

    private long rid;       //玩家id
    private String name;    //重命名

    @Override
    public long getRid(){
        return this.rid;
    }
}
