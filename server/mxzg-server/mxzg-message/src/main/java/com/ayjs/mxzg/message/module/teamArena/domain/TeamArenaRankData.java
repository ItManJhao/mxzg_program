package com.ayjs.mxzg.message.module.teamArena.domain;

import lombok.Getter;
import lombok.Setter;

/**
 * @Author: CWJ
 * @Date: 2020/4/10
 **/
@Setter
@Getter
public class TeamArenaRankData {

    /***
     * 排名
     */
    private int rank;

//    private long teamId;

    /***
     * 队伍信息
     */
    private ArenaTeamData teamData;

    /***
     * 积分
     */
    private int score;

    /***
     * 排行榜时间
     */
    private int rankTime;


}
