package com.ayjs.mxzg.message.module.spacetimeAdventure;

import com.ayjs.mxzg.message.cross.CrossMessage;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

/**
 * 匹配对手
 *
 * @author hyx
 */
@Builder
@Getter
@Setter
public class SpaceTimeChooseInfoReqMessage implements CrossMessage {

    private long rid;

    /**
     * 已方战力
     */
    private long fighting;

    /**
     * 已方等级
     */
    private int level;

    /**
     * 已方服务器id
     */
    private int serverId;

    /**
     * 上一个敌人
     */
    private String lastEnemy;

}
