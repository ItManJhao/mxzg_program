package com.ayjs.mxzg.message.module.teamArena.message;

import com.ayjs.mxzg.message.cross.CrossMessage;
import lombok.Getter;
import lombok.Setter;

/**
 * 战斗返回
 *
 * @Author: CWJ
 * @Date: 2020/4/10
 **/
@Getter
@Setter
public class TeamArenaBattleResMessage implements CrossMessage {
    /**
     * 当前排名
     */
    private int rank;
    /**
     * 当前分数
     */
    private int score;
    /**
     * 增加排名
     */
    private int addRank;
    /**
     * 防守方新排名
     */
    private int defendNewRank;
    /**
     * 防守方增加排名
     */
    private int defendAddRank;
    /**
     * 增加分数
     */
    private int addScore;
    /**
     * 防守方减少分数负数
     */
    private int defReduceScore;

    /**
     * 防守方分数
     */
    private int defScore;

}
