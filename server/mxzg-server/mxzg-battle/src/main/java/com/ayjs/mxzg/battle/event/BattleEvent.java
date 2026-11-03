package com.ayjs.mxzg.battle.event;

import com.ayjs.mxzg.battle.model.BattleType;
import com.ayjs.mxzg.config.struct.GameEvent;
import lombok.Value;

/**
 * 战斗事件
 */
@Value(staticConstructor = "of")
public class BattleEvent {

    /** 玩家id */
    private long rid;

    /** 对手 */
    private long opponent;

    /** 战场id */
    private String battleId;

    /** 战斗类型 */
    private BattleType battleType;

    /** 是否胜利 */
    private boolean win;

    /** 战斗事件*/
    private GameEvent gameEvent;

}
