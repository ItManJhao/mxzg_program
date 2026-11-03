package com.ayjs.mxzg.message.module.hero.message;

import com.ayjs.mxzg.message.cross.RemoteServerMessage;
import lombok.Getter;
import lombok.Setter;

/**
 * 跨服去目标服务器获取跨服英雄数据，第一步，1/2
 */
@Getter
@Setter
public class ReqRemoteHeroMessage implements RemoteServerMessage {

    /**
     * 服务器id
     */
    private int serverId;
    /**
     * 请求的rid
     */
    private long reqRid;
    /**
     * 目标角色id
     */
    private long respRid;
    /**
     * 目标玩家英雄id
     */
    private long respHeroId;

    @Override
    public int serverId() {
        return serverId;
    }
}
