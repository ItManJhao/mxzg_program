package com.ayjs.mxzg.gameserver.module.stagematch.rim.event;

import com.ayjs.mxzg.battle.model.mirror.HeroVo;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

/**
 * 只有挑战方才发出这个事件，策划要求挑战放才会记录数据
 *
 * @Author: CWJ
 * @Date: 2020/6/16
 **/
@Getter
@Setter
public class StageMatchSeasonBattleEvent {

    private long rid;

    /**
     * 是否胜利
     */
    private Boolean win;

    /***
     * 当前分数
     */
    private int currScore;

    /***
     * 当前段位
     */
    private int stageId;

    /***
     * 本次战斗伤害最大值值
     */
    private long dmg;

    /***
     * 防守方id
     */
    private long defendId;

    /***
     * 防守方队伍1战力
     */
    private long defendTeamFighting1;

    /***
     * 防守方队伍2战力
     */
    private long defendTeamFighting2;

    /***
     * mvp英雄次数
     */
    private List<HeroVo> mvpHeroVos = new ArrayList<>();

    /***
     * 是否是常规赛
     */
    private boolean normal;


}
