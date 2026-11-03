package com.ayjs.mxzg.message.module.crusadegroup.map;

import com.ayjs.mxzg.message.cross.PlayerCrossMessage;
import com.ayjs.mxzg.message.largecross.CrusadeGroupMessage;
import lombok.Getter;
import lombok.Setter;
import lombok.Value;

/**
 * 攻击领地返回
 */
@Getter
@Setter
@Value(staticConstructor = "valueOf")
public class StartBattleReqMessage implements PlayerCrossMessage, CrusadeGroupMessage {

    private long rId;           // 玩家id
    private String nick;    //玩家名称
    private int territoryId;    //领地id
    private int formationId;     //攻击的npc阵容id
    private String battleVo;      // 自身battleVo

    @Override
    public long getRid() {
        return rId;
    }
}
