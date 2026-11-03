package com.ayjs.mxzg.gameserver.module.stagematch.battle.domain;


import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.config.excel.constant.StageMatchConst;
import com.ayjs.mxzg.message.module.stagematch.dto.OpponentDto;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * 角色段位赛信息
 */
@Entity
@Table(name = "role_stage_match", comment = "角色段位赛信息表")
@Getter
@Setter
public class RoleStageMatch extends AbstractEntity {

    /**
     * rid
     */
    @Id
    @Column(name = "rid", readOnly = true, comment = "角色id")
    private long rid;
    /**
     * 玩家赛季
     */
    @Column(name = "season", comment = "玩家赛季")
    private int season;
    /**
     * 段位
     */
    @Column(name = "stage_id", comment = "段位")
    private int stageId;
    /**
     * 上个赛季的段位
     */
    @Column(name = "last_season_stage_id", comment = "上个赛季的段位")
    private int lastSeasonStageId;
    /**
     * 当前赛季的最大段位
     */
    @Column(name = "max_season_stage_id", comment = "当前赛季的最大段位")
    private int maxSeasonStageId;
    /**
     * 精英积分
     */
    @Column(name = "elite_integral", comment = "精英积分")
    private int eliteIntegral;
    /**
     * 段位积分
     */
    @Column(name = "integral", comment = "段位积分")
    private int integral;
    /**
     * 是否是晋级赛
     */
    @Column(name = "qualifying_match", comment = "是否是晋级赛")
    private boolean qualifyingMatch;
    /**
     * 晋级赛结果记录0,失败 1，胜利
     */
    @Column(name = "advance_record", comment = "晋级赛结果记录")
    private List<Integer> advanceRecord = new ArrayList<>();
    /**
     * 匹配后的对手id
     */
    @Column(name = "opponent_id", comment = "匹配的对手id")
    private long opponent_id;
    /**
     * 战斗时间
     */
    @Column(name = "battle_time", comment = "战斗时间")
    private int battleTime;
    /**
     * 购买次数，每天重置
     */
    @Column(name = "purchases", comment = "每天购买次数，每天重置")
    private int purchases;
    /**
     * 匹配cd
     */
    @Column(name = "match_cd", comment = "匹配cd")
    private int matchCD;
    /**
     * 匹配出错次数，每天重置
     */
    @Column(name = "error_times", comment = "匹配出错次数，当扣减玩家匹配次数，但是战斗异常未收到结果时记录")
    private int errorTimes;
    /**
     * 剩余匹配次数，每天重置
     */
    @Column(name = "matches", comment = "匹配次数")
    private int matches;
    /**
     * 赛季排名，赛季重置
     */
    @Column(name = "rank", comment = "赛季排名，赛季重置")
    private int rank;
    /**
     * 赛季匹配次数，赛季重置
     */
    @Column(name = "total_matches", comment = "匹配出错次数，当扣减玩家匹配次数，但是战斗异常未收到结果时记录")
    private int totalMatches;
    /**
     * 已经领取的赛季段位奖励id列表，赛季重置
     */
    @Column(name = "stage_reward_id", comment = "赛季段位奖励id列表，赛季重置")
    private int stageRewardId;
    /**
     * 用于结算段位继承提示
     */
    @Column(name = "settlement", comment = "是否结算过，提示给玩家段位重置")
    private boolean settlement;
    /** 对手基础信息 */
    @Column(name = "opponent_dto", comment = "对手基本信息")
    private OpponentDto opponentDto;
    @Column(name = "reset_time", comment = "每天重置")
    private int resetTime;

    /**
     * 初始化
     */
    public void initialize(){
        this.stageRewardId = StageMatchConst.SUPER_STAGE_INITIAL_STAGE_ID;
        this.stageId = StageMatchConst.SUPER_STAGE_INITIAL_STAGE_ID;
        this.maxSeasonStageId = StageMatchConst.SUPER_STAGE_INITIAL_STAGE_ID;
        this.eliteIntegral = StageMatchConst.SUPER_STAGE_INITIAL_POINTS;
        this.lastSeasonStageId = StageMatchConst.SUPER_STAGE_INITIAL_STAGE_ID;
        this.resetTime = DateTimeUtil.currentSecond();
    }

    /**
     * 匹配对手
     * @param opponentDto
     * @param battleTime
     */
    public void match(OpponentDto opponentDto, int battleTime){
        this.opponent_id = opponentDto.getRid();
        this.battleTime = battleTime;
        this.opponentDto = opponentDto;
        this.totalMatches++;
        this.matches++;
    }

    /**
     * 单次匹配重置
     */
    public void matchReset(){
        this.opponent_id = 0;
        this.battleTime = 0;
        this.matchCD = 0;
    }

    /**
     * 赛季重置
     */
    public void seasonReset(int inheritStageId){
        this.settlement = true;
        this.lastSeasonStageId = this.stageId;
        this.stageId = inheritStageId;
        this.maxSeasonStageId = inheritStageId;
        this.integral = 0;
        this.rank = 0;
        this.battleTime = 0;
        this.totalMatches = 0;
        this.matches = 0;
        this.purchases = 0;
        this.errorTimes = 0;
        this.matchCD = 0;
        this.qualifyingMatch = false;
        this.resetTime = DateTimeUtil.currentSecond();
        this.stageRewardId = StageMatchConst.SUPER_STAGE_INITIAL_STAGE_ID;
        this.opponent_id = 0;
        this.eliteIntegral = this.eliteIntegral * 100 / StageMatchConst.INHERIT_ELITE_POINTS_RATIO;
        this.eliteIntegral = Math.max(this.eliteIntegral, StageMatchConst.SUPER_STAGE_INITIAL_POINTS);
    }

    /**
     * 更新信息
     * @param stageId
     * @param integral
     * @param eliteIntegral
     * @param rank
     */
    public void updateInfo(int stageId, int integral, int eliteIntegral, int rank){
        this.stageId = stageId;
        this.integral = integral;
        this.eliteIntegral = eliteIntegral;
        this.rank = rank;
    }

    /**
     * 更新信息
     * @param stageId
     * @param integral
     * @param eliteIntegral
     * @param rank
     * @param qualifyingMatch
     * @param resultSet
     */
    public void updateResult(int stageId, int integral, int eliteIntegral, int rank, boolean qualifyingMatch, List<Integer> resultSet){
        this.stageId = stageId;
        this.integral = integral;
        this.eliteIntegral = eliteIntegral;
        this.rank = rank;
        this.qualifyingMatch = qualifyingMatch;
        this.advanceRecord = resultSet;
        if(this.stageId > this.maxSeasonStageId){
            this.maxSeasonStageId = this.stageId;
        }
    }

    /**
     * 领取一次奖励
     */
    public void receiveReward(){
        this.stageRewardId++;
    }

    /**
     * 是否没有超过购买次数上限
     * @return
     */
    public boolean notPurchaseLimit(){
        return  this.purchases < StageMatchConst.BUY_TIMES;
    }

    /**
     * 获取剩余匹配次数
     * @return
     */
    public int getRemainingMatches(){
        return this.purchases + StageMatchConst.DAILY_MATCHES - this.matches;
    }

    /**
     * 获取剩余购买次数次数
     * @return
     */
    public int getRemainingPurchases(){
        return StageMatchConst.BUY_TIMES - this.purchases;
    }

    /**
     * 添加错误次数
     */
    public void addErrorTimes(){
        this.errorTimes++;
    }

    /**
     * 增加购买次数
     */
    public void addPurchases(){
        this.purchases++;
    }

    /**
     * 是否匹配中
     */
    public boolean isMatching(){
        return this.opponent_id != 0;
    }

    /**
     * 获取匹配战斗等待时间
     * @param skipArray
     * @return
     */
    public int getWaitingTime(boolean skipArray){
        int skipArrayWaitingTime = StageMatchConst.SKIP_ARRAY_WAITING_TIME;
        int matchingWaitingTime = StageMatchConst.MATCHING_WAITING_TIME;
        return skipArray ? skipArrayWaitingTime : matchingWaitingTime;
    }
    /**
     * 匹配cd
     */
    public void matchCool(boolean skipArray){
        int waitingTime = getWaitingTime(skipArray);
        this.matchCD = DateTimeUtil.currentSecond() + waitingTime;
    }


    /**
     * 是否匹配cd中
     * @return
     */
    public boolean isMatchCool(){
        return DateTimeUtil.currentSecond() < this.matchCD;
    }

    /**
     * 是否可以匹配
     * @return
     */
    public boolean canMatch(){
        return (StageMatchConst.DAILY_MATCHES + this.purchases - this.matches) > 0;
    }

    /**
     * 是否有奖励可以领取
     * @return
     */
    public boolean hasReward(){
        return this.stageRewardId < this.stageId;
    }

    /**
     * 每天重置
     */
    public void dailyReset(){
        this.errorTimes = 0;
        this.matches = 0;
        this.purchases = 0;
        this.resetTime = DateTimeUtil.currentSecond();
    }

    /**
     * 获取晋级赛记录
     * @return
     */
    public List<Integer> getAdvanceRecord(){
        return getAdvanceRecord(this.qualifyingMatch);
    }

    /**
     * 获取晋级赛记录
     * @return
     */
    public List<Integer> getAdvanceRecord(boolean qualifyingMatch){
        if(!qualifyingMatch || this.advanceRecord == null){
            return Collections.emptyList();
        }
        return this.advanceRecord;
    }

}