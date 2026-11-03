package com.ayjs.mxzg.gameserver.module.stagematch.battle.event;

import com.ayjs.mxzg.gameserver.module.stagematch.battle.domain.MatchLog;
import com.ayjs.mxzg.protocol.BattleGMsg.BattleReport;
import lombok.Getter;
import lombok.Setter;

/**
 * 段位赛战斗事件
 */
@Getter
@Setter
public class StageMatchBattleEvent {

    /**
     * 玩家id
     */
    private long rid;
    /**
     * 匹配信息
     */
    private MatchLog matchlog;
    /**
     * 战报
     */
    private BattleReport battleReport;

    public static StageMatchBattleEvent createOf(long rid, MatchLog matchlog, BattleReport battleReport){
        StageMatchBattleEvent event = new StageMatchBattleEvent();
        event.setRid(rid);
        event.setMatchlog(matchlog);
        event.setBattleReport(battleReport);
        return event;
    }

}
