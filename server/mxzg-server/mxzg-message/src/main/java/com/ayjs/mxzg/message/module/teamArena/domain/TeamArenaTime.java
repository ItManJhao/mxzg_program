package com.ayjs.mxzg.message.module.teamArena.domain;

import lombok.Getter;
import lombok.Setter;

/**
 * 组队竞技场时间信息
 * @Author: CWJ
 * @Date: 2020/4/11
 **/
@Setter
@Getter
public class TeamArenaTime {

    /***
     * 当前状态
     */
    private TeamArenaState currState;
    /***
     * 状态改变时间
     */
    private int stateChangeTime;

    /***
     * 下一个状态
     */
    private TeamArenaState nextState;
    /***
     *  下一个时间
     */
    private int nextStateTime;

    private int lastSettleTime;

    private int removeTeamTime;
}
