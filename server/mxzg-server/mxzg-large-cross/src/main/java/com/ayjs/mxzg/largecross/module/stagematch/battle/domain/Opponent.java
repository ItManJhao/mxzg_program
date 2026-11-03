package com.ayjs.mxzg.largecross.module.stagematch.battle.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.common.util.StringUtil;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.config.excel.constant.StageMatchConst;
import com.ayjs.mxzg.config.excel.entity.CSuperStage;
import com.ayjs.mxzg.message.module.stagematch.dto.BattleResultType;
import com.ayjs.mxzg.message.module.stagematch.dto.OpponentDto;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
@Entity
@Table(name = "opponent", comment = "对手表")
public class Opponent extends AbstractEntity implements Comparable<Opponent>{

    @Id
    @Column(name = "rid", comment = "玩家ID")
    private long rid;
    @Column(name = "server_id", comment = "分区ID")
    private int serverId;
    @Column(name = "name", comment = "昵称")
    private String name;
    @Column(name = "rank", comment = "排名")
    private int rank;
    @Column(name = "stage_id", comment = "段位")
    private int stageId;
    @Column(name = "last_stage_id", comment = "上一段位")
    private int lastStageId;
    @Column(name = "integral", comment = "段位积分")
    private int integral;
    @Column(name = "opponent_id", comment = "匹配的对手id")
    private long opponentId;
    @Column(name = "battle_time", comment = "战斗时间")
    private int battleTime;
    @Column(name = "qualifying_match", comment = "是否晋级赛中")
    private boolean qualifyingMatch;
    @Column(name = "advance_integral", comment = "晋级积分")
    private int advanceIntegral;
    @Column(name = "advance_result_set", comment = "晋级结果列表")
    private List<Integer> advanceResultSet = new ArrayList<>();
    @Column(name = "protection_integral", comment = "保护积分")
    private int protectionIntegral;
    @Column(name = "elite_integral", comment = "精英积分")
    private int eliteIntegral;
    @Column(name = "battler_vo", comment = "战斗Vo对象", length = 32768)
    private String battlerVo;
    @Column(name = "fighting", comment = "战力")
    private int fighting;
    @Column(name = "max_fighting", comment = "历史最大战力")
    private int maxFighting;
    @Column(name = "level", comment = "等级")
    private int level;
    @Column(name = "image_id", comment = "形象id")
    private int image_id;
    @Column(name = "border_id", comment = "头像框")
    private int borderId;
    @Column(name = "head_id", comment = "头像")
    private int headId;
    @Column(name = "max_stage_id", comment = "当前赛季最大的段位id")
    private int maxStageId;
    @Column(name = "consecutive_failures_number", comment = "连续失败的次数")
    private int consecutiveFailuresNumber;
    //匹配到的临时对手
    private volatile Opponent opponent;

    public static Opponent createOf(long rid){
        Opponent opponent = new Opponent();
        opponent.setRid(rid);
        return opponent;
    }

    public static Opponent createRobotOf(long rid, int integral, int eliteIntegral, int stageId, String name, String battlerVo, int serverId,  int fighting){
        Opponent opponent = new Opponent();
        opponent.setRid(rid);
        opponent.setIntegral(integral);
        opponent.setEliteIntegral(eliteIntegral);
        opponent.setName(name);
        opponent.setBattlerVo(battlerVo);
        opponent.setRank(opponent.getRank());
        opponent.setServerId(serverId);
        opponent.setStageId(stageId);
        opponent.setFighting(fighting);
        return opponent;
    }


    /**
     * 初始化
     */
    public void initialize(){
        this.stageId = StageMatchConst.SUPER_STAGE_INITIAL_STAGE_ID;
        this.maxStageId = StageMatchConst.SUPER_STAGE_INITIAL_STAGE_ID;
        this.lastStageId = StageMatchConst.SUPER_STAGE_INITIAL_STAGE_ID;
        this.eliteIntegral = StageMatchConst.SUPER_STAGE_INITIAL_POINTS;
        if(StringUtil.isBlank(this.battlerVo)){
            this.battlerVo = "";
        }

        if(StringUtil.isBlank(this.name)){
            this.name = "";
        }
    }

    /**
     * 赛季重置
     */
    public void seasonReset(int inheritStageId){
        this.stageId = inheritStageId;
        this.maxStageId = inheritStageId;
        this.integral = 0;
        this.rank = 0;
        this.battleTime = 0;
        this.qualifyingMatch = false;
        this.eliteIntegral = this.eliteIntegral * 100 / StageMatchConst.INHERIT_ELITE_POINTS_RATIO;
        this.eliteIntegral = Math.max(this.eliteIntegral, StageMatchConst.SUPER_STAGE_INITIAL_POINTS);
    }

    /**
     * 修改
     * @param serverId
     * @param name
     * @param battlerVo
     * @param fighting
     * @param level
     */
    public void updateInfo(int serverId, String name, String battlerVo, int fighting, int imageId, int level){
        this.serverId = serverId;
        this.battlerVo = battlerVo;
        this.fighting = fighting;
        this.name = name;
        this.image_id = imageId;
        this.level = level;
        if(this.fighting > this.maxFighting){
            this.maxFighting = this.fighting;
        }
    }

    /**
     * 更新战斗信息
     * @param battlerVo
     * @param fighting
     * @param headId
     * @param borderId
     */
    public void updateBattleInfo(String battlerVo, int fighting, int headId, int borderId){
        this.battlerVo = battlerVo;
        this.fighting = fighting;
        this.headId = headId;
        this.borderId = borderId;
    }

    /**
     * 更新战斗信息
     * @param battlerVo
     * @param fighting
     */
    public void updateBattleInfo(String battlerVo, int fighting){
        this.battlerVo = battlerVo;
        this.fighting = fighting;
    }

    /**
     * 设置匹配对手
     * @param opponent
     * @param waitTime
     */
    public void matchOpponent(Opponent opponent, int waitTime){
        this.opponent = opponent;
        this.opponentId = opponent.getRid();
        this.battleTime = DateTimeUtil.currentSecond() + waitTime;
    }

    /**
     * 清空匹配对手
     */
    public void cleanOpponent() {
        this.opponentId = 0;
        this.opponent = null;
        this.battleTime = 0;
    }

    /**
     * 是否有匹配对手
     * @return
     */
    public boolean hasMatchOpponent(){
        return this.opponentId != 0 && this.opponent != null;
    }

    /**
     * 添加晋级结果
     * @param advanceIntegral
     */
    public void addAdvanceResult(int advanceIntegral){
        this.advanceIntegral += advanceIntegral;
        this.eliteIntegral += advanceIntegral;
        int result = advanceIntegral > 0 ? BattleResultType.VICTORY : BattleResultType.FAILURE;
        this.advanceResultSet.add(result);
    }

    /**
     * 积分是否满了，可以开始晋级
     * @return
     */
    public boolean isFull(int integralUpperLimit){
        return this.integral >= integralUpperLimit;
    }

    /**
     * 晋级结束，更新晋级积分
     */
    public void advanceFinish(){
        this.qualifyingMatch = false;
        this.integral += this.advanceIntegral;
    }

    /**
     * 开始晋级赛，重置上一轮的晋级数据
     * @param integralLimit
     */
    public void startAdvance(int integralLimit){
        this.qualifyingMatch = true;
        this.advanceIntegral = 0;
        this.integral = integralLimit;
        this.advanceResultSet.clear();
    }

    /**
     * 是否晋级完成
     * @param advanceMaximum
     * @return
     */
    public boolean isAdvanceFinish(int advanceMaximum, int winCount){
        long failureCount = this.advanceResultSet.stream().filter(type-> type == BattleResultType.FAILURE).count();
        long winNumber = this.advanceResultSet.size() - failureCount;
        return this.advanceResultSet.size() >= advanceMaximum || (advanceMaximum - failureCount < winCount) || winNumber >= winCount;
    }

    /**
     * 是否晋级成功
     * @param advanceVictory
     * @return
     */
    public boolean isAdvanceSuccess(int advanceVictory){
        return this.advanceResultSet.stream().filter(result -> result == BattleResultType.VICTORY).count() >= advanceVictory;
    }

    /**
     * 升级段位
     * @param nextSuperStage
     */
    public void upgradeStage(CSuperStage nextSuperStage){
        this.lastStageId = this.stageId;
        this.stageId = nextSuperStage.getIdx();
        this.integral = this.advanceIntegral;
        this.advanceIntegral = 0;
        this.protectionIntegral = nextSuperStage.getProtection_integral();
        if(this.stageId > this.maxStageId){
            this.maxStageId = this.stageId;
        }
    }

    /**
     * 添加战斗结果
     * @param win
     */
    public void addBattleResult(boolean win){
        if(win){
            this.consecutiveFailuresNumber = 0;
        } else {
            this.consecutiveFailuresNumber++;
        }
    }

    /**
     * 连败次数
     * @return
     */
    public boolean isConsecutiveFailures(){
        return this.stageId < StageMatchConst.ROBOT_MAX_STAGE_ID && this.consecutiveFailuresNumber >= StageMatchConst.CONSECUTIVE_FAILURES_NUMBER;
    }

    /**
     * 更新积分
     * @param updateIntegral
     * @param lowestStage
     */
    public void updateIntegral(int updateIntegral, CSuperStage lowestStage){
        this.integral += updateIntegral;
        this.eliteIntegral += updateIntegral;
        if(this.integral < 0){
            this.protectionIntegral += this.integral;
            this.integral = 0;
            if(this.protectionIntegral < 0){
                if(lowestStage != null && this.stageId > StageMatchConst.PROTECTION_LEVEL_STAGE_ID){
                    this.stageId = lowestStage.getIdx();
                    this.integral = lowestStage.getIntegral_limit() + this.protectionIntegral;
                    this.protectionIntegral = lowestStage.getProtection_integral();
                } else {
                    this.protectionIntegral = 0;
                }
            }
        }
    }

    /**
     * 更新排行，如果排行有修改则返回true否则false
     * @param rank
     * @return
     */
    public boolean updateRank(int rank){
        if(this.rank == rank){
            return false;
        }
        this.rank = rank;
        return true;
    }

    /**
     * 转换OpponentDto, 暂时不包含阵容信息
     * @return
     */
    public OpponentDto toOpponentDto(){
        OpponentDto opponentDto = new OpponentDto();
        opponentDto.setFighting(this.fighting);
        opponentDto.setImage_id(this.image_id);
        opponentDto.setStageId(this.stageId);
        opponentDto.setServerId(this.serverId);
        opponentDto.setRank(this.rank);
        opponentDto.setName(this.name);
        opponentDto.setEliteIntegral(this.eliteIntegral);
        opponentDto.setIntegral(this.integral);
        opponentDto.setRid(this.rid);
        return opponentDto;
    }

    @Override
    public int compareTo(Opponent o) {
        if(this.stageId > o.getStageId()){
            return -1;
        } else if(this.stageId < o.getStageId()){
            return 1;
        }

        if(this.eliteIntegral > o.getEliteIntegral()){
            return -1;
        } else if(this.eliteIntegral < o.getEliteIntegral()){
            return 1;
        }

        return Integer.compare(this.battleTime, o.getBattleTime());
    }
}
