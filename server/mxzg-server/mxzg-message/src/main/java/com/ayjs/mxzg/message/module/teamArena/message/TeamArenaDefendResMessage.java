package com.ayjs.mxzg.message.module.teamArena.message;

import com.ayjs.mxzg.message.cross.CrossMessage;
import lombok.Value;

/**
 * 战斗返回
 *
 * @Author: CWJ
 * @Date: 2020/4/10
 **/
@Value(staticConstructor = "of")
public class TeamArenaDefendResMessage implements CrossMessage {

    /***
     * 防守队伍
     */
    private long defendTeamId;
    /**
     * 防守方新排名
     */
    private int defendNewRank;

    /***
     * 新分数
     */
    private int defendNewScore;


}
