package com.ayjs.mxzg.gameserver.module.teamArena.event;

import com.ayjs.mxzg.message.module.teamArena.domain.TeamArenaRankData;
import com.ayjs.mxzg.protocol.BattleGMsg;
import lombok.Value;

import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2020/4/15
 **/
@Value(staticConstructor = "of")
public class TeamArenaRecordEvent {

    /***
     * 战报
     */
    private List<BattleGMsg.BattleReport> reports;

    /***
     * 胜利者队伍
     */
    private long winTeamId;

    /***
     * 进攻方增加排名
     */
    private int attackAddRank;

    /***
     * 进攻方增加分数
     */
    private int attackAddScore;

    /***
     * 战斗时间
     */
    private int battleTime;

    /***
     * 防守方增加排名
     */
    private int defendAddRank;

    /***
     * 进攻方数据
     */
    private TeamArenaRankData attack;

    /***
     * 防守方数据
     */
    private TeamArenaRankData defend;

    /***
     * 防守方减少分数
     */
    private int defendReduceScore;

}
