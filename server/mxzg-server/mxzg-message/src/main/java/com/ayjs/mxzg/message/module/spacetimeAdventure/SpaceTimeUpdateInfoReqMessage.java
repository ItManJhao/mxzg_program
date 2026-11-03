package com.ayjs.mxzg.message.module.spacetimeAdventure;

import com.ayjs.mxzg.message.cross.CrossMessage;
import lombok.Getter;
import lombok.Setter;

import java.util.List;
import java.util.Map;

/**
 * 上传或更新跨服数据
 *
 * @author hyx
 */
@Getter
@Setter
public class SpaceTimeUpdateInfoReqMessage implements CrossMessage {

    /**
     * 角色id
     */
    private long rid;

    /**
     * 服务器id
     */
    private int serverId;

    /**
     * 昵称
     */
    private String nick;

    /**
     * 历史最高战力
     */
    private int maxFighting;

    private Map<Integer, byte[]> battlerMap;

}

