package com.ayjs.mxzg.message.module.crusadegroup.group;

import com.ayjs.mxzg.message.cross.RemoteServerMessage;
import com.ayjs.mxzg.message.module.crusadegroup.group.dto.Territory;
import lombok.Value;

import java.util.Map;
import java.util.Set;

/**
 * 开启战斗
 */
@Value(staticConstructor = "valueOf")
public class StartBattleMessage implements RemoteServerMessage {

    /** 分区id */
    private int serverId;

    /**
     * 出生点列表
     */
    private Map<Long, Territory> birthplace;

    @Override
    public int serverId() {
        return serverId;
    }
}
