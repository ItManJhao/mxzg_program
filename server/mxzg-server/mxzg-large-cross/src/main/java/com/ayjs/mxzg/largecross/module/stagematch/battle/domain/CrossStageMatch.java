package com.ayjs.mxzg.largecross.module.stagematch.battle.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.entity.CSuperStageCycle;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;


@Getter
@Setter
@Entity
@Table(name = "cross_stage_match", comment = "段位赛")
public class CrossStageMatch extends AbstractEntity {

    @Id
    @Column(name = "id", comment = "主键")
    private int id;
    @Column(name = "cycle_id", comment = "周期id")
    private int cycleId;
    @Column(name = "season", comment = "赛季")
    private int season;
    @Column(name = "stage_type", comment = "阶段类型")
    private int stageType;
    @Column(name = "start_time", comment = "开始时间")
    private LocalDateTime startTime = LocalDateTime.now();
    @Column(name = "end_time", comment = "结束时间")
    private LocalDateTime endTime = LocalDateTime.now();
    @Column(name = "serial_number", comment = "流水号")
    private int serialNumber;

    /**
     * 是否是同一个周期
     * @param cycle
     * @return
     */
    public boolean isSameCycle(CSuperStageCycle cycle){
        return this.season == cycle.getSeason() && this.stageType == cycle.getStage_type().ordinal();
    }

    /**
     * 是否是同一个周期
     * @param cycle
     * @return
     */
    public boolean isLaterThan(CSuperStageCycle cycle){
        return this.season > cycle.getSeason() ||(this.season == cycle.getSeason() && this.stageType > cycle.getStage_type().ordinal());
    }

    /**
     * 是否是同一个周期
     * @param cycle
     * @return
     */
    public boolean isSameSeason(CSuperStageCycle cycle){
        return this.season == cycle.getSeason();
    }

    /**
     * 段位赛未开启
     * @return
     */
    public boolean isUnOpen(){
        return this.season == 0;
    }

    /**
     * 开启新赛季
     * @param startCycle
     * @param endCycle
     */
    public void openNewSeason(CSuperStageCycle startCycle, CSuperStageCycle endCycle){
        this.startTime = startCycle.getStart_time();
        this.endTime = endCycle.getStart_time();
        this.season = startCycle.getSeason();
        this.stageType = startCycle.getStage_type().ordinal();
    }

    /**
     * 下一个周期
     * @param startCycle
     */
    public void nextCycle(CSuperStageCycle startCycle){
        this.cycleId = startCycle.getIdx();
        this.stageType = startCycle.getStage_type().ordinal();
        this.serialNumber = TimeDateUtil.getCurrentTimeInt();
    }

}
