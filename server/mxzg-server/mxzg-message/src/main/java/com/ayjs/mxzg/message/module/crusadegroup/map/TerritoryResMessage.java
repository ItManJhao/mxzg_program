package com.ayjs.mxzg.message.module.crusadegroup.map;

import com.ayjs.mxzg.message.largecross.CrusadeGroupMessage;
import lombok.Value;

/**
 * 请求领地信息
 */
@Value(staticConstructor = "valueOf")
public class TerritoryResMessage implements CrusadeGroupMessage {

    private long occupiedId;    //占领的玩家

    private int element;    //领地元素

    private String nick;    //昵称

    private int borderId;   //头像框

    private int headId; //头像id

    private int serverId;   // 服务器id

}
