package com.ayjs.mxzg.message.module.spacetimeAdventure;

import com.ayjs.mxzg.message.cross.CrossMessage;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import java.util.List;
import java.util.Map;

/**
 * 返回对手镜像数据
 */
@Builder
@Getter
@Setter
public class SpaceTimeChooseInfoResMessage implements CrossMessage {

    private boolean isTurn = false;

    /**
     * 已方rid
     */
    private long rid;

    private int serverId;

    private String nick;

    private Map<Integer, byte[]> battlerMap;

}


