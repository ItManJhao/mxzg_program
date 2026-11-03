package com.ayjs.mxzg.gameserver.module.stagematch.battle.domain;


import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.common.util.time.LocalDateTimeUtil;
import com.ayjs.mxzg.config.struct.StageType;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

/**
 * 段位赛信息
 */
@Entity
@Getter
@Setter
@Table(name = "stage_match", comment = "段位赛信息表")
public class StageMatch extends AbstractEntity {


    @Id
    @Column(name = "id", readOnly = true, comment = "主键")
    private int id;
    @Column(name = "serial_number", comment = "流水号")
    private int serialNumber;
    @Column(name = "season", comment = "赛季")
    private int season;
    @Column(name = "stage", comment = "赛季阶段")
    private int stage;
    @Column(name = "start_time", comment = "开始时间")
    private LocalDateTime startTime;
    @Column(name = "end_time", comment = "结束时间")
    private LocalDateTime endTime;

    /**
     * 修改信息
     * @param serialNumber
     * @param season
     * @param stage
     * @param startTime
     * @param endTime
     */
    public void updateInfo(int serialNumber, int season, int stage, LocalDateTime startTime, LocalDateTime endTime){
        this.serialNumber = serialNumber;
        this.season = season;
        this.stage = stage;
        this.startTime = startTime;
        this.endTime = endTime;
    }

    /**
     * 赛季开始
     * @param serialNumber
     * @param season
     * @param startTime
     * @param endTime
     */
    public void openStageMatch(int serialNumber, int season, LocalDateTime startTime, LocalDateTime endTime){
        this.season = season;
        this.startTime = startTime;
        this.endTime = endTime;
        this.serialNumber = serialNumber;
        this.stage = StageType.START_SEASON.ordinal();
    }

    /**
     * 开启匹配
     * @param serialNumber
     */
    public void openMatching(int serialNumber){
        this.serialNumber = serialNumber;
        this.stage = StageType.MATCH.ordinal();
    }

    /**
     * 关闭段位赛
     * @param serialNumber
     */
    public void closeStageMatch(int serialNumber){
        this.serialNumber = serialNumber;
        this.stage = StageType.FINISH.ordinal();
    }

    /**
     * 结算段位赛
     */
    public void settlementStageMatch(){
        this.stage = StageType.SETTLEMENT.ordinal();
    }

    /**
     * 获取开启时间的时间戳
     * @return
     */
    public int getStartTimeS(){
        return LocalDateTimeUtil.toEpochSecond(this.startTime);
    }

    /**
     * 获取结束时间戳
     * @return
     */
    public int getEndTimeS(){
        return LocalDateTimeUtil.toEpochSecond(this.endTime);
    }

    /**
     * 是否是匹配阶段
     * @return
     */
    public boolean isMatchStage(){
        return this.stage == StageType.MATCH.ordinal() || this.stage == StageType.START_SEASON.ordinal() ||
                this.stage == StageType.PRELIMINARIES.ordinal() || this.stage == StageType.FINALS.ordinal();
    }

    /**
     * 是否是常规赛
     * @return
     */
    public boolean isRegularSeason(){
        return this.stage != StageType.PRELIMINARIES.ordinal() && this.stage != StageType.FINALS.ordinal();
    }

    /**
     * 获取巅峰赛阶段
     * @return
     */
    public int getPinnacleStage(){
        if(this.stage == StageType.PRELIMINARIES.ordinal() || this.stage == StageType.FINALS.ordinal()){
            return this.stage;
        }
        return 0;
    }

}