package com.ayjs.mxzg.cross.module.crusadegroup.group.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.entity.crusadegroup.CCrusadeGroupCycle;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

@Entity
@Table(name = "crusade_system", comment = "跨服讨贼团")
@Getter
@Setter
public class CrusadeSystem extends AbstractEntity {

    @Id
    @Column(name = "id", comment = "唯一ID")
    private int id;

    @Column(name = "regroup", comment = "是否重组过了")
    private boolean regroup;

    @Column(name = "last_regroup_time", comment = "上次重组的时间")
    private LocalDateTime lastRegroupTime = LocalDateTime.now();

    @Column(name = "cycle_id", comment = "周期id")
    private int cycleId;

    @Column(name = "stage", comment = "阶段")
    private int stage;

    @Column(name = "registration_start_time", comment = "报名开始时间")
    private LocalDateTime registrationStartTime = LocalDateTime.now();

    @Column(name = "registration_end_time", comment = "报名结束时间")
    private LocalDateTime registrationEndTime = LocalDateTime.now();

    @Column(name = "battle_start_time", comment = "战斗开始时间")
    private LocalDateTime battleStartTime = LocalDateTime.now();

    @Column(name = "battle_end_time", comment = "结束时间")
    private LocalDateTime battleEndTime = LocalDateTime.now();

    @Column(name = "territorial_elements", comment = "领地元素", longtext = true)
    private Map<Integer, Integer> territorialElements = new HashMap<>();

    @Column(name = "territorial_team_ids", comment = "领地的npc队伍信息", longtext = true)
    private Map<Integer, Set<Integer>> territorialTeamIds = new HashMap<>();

    @Column(name = "serial_number", comment = "流水号")
    private int serialNumber;

    /**
     * 初始化
     * @param stage
     * @param registrationStartTime
     * @param registrationEndTime
     * @param battleStartTime
     * @param battleEndTime
     */
    public void init(int stage, LocalDateTime registrationStartTime, LocalDateTime registrationEndTime, LocalDateTime battleStartTime, LocalDateTime battleEndTime){
        this.stage = stage;
        this.registrationStartTime = registrationStartTime;
        this.registrationEndTime = registrationEndTime;
        this.battleStartTime = battleStartTime;
        this.battleEndTime = battleEndTime;
    }

    /**
     * 下一个周期
     * @param startCycle
     */
    public void setCycle(CCrusadeGroupCycle startCycle){
        this.cycleId = startCycle.getIdx();
        this.stage = startCycle.getStage_type().ordinal();
        this.serialNumber = TimeDateUtil.getCurrentTimeInt();
    }

    /**
     * 根据领地id获取元素
     * @param territorialId
     * @return
     */
    public int getElement(int territorialId){
        return this.territorialElements.get(territorialId);
    }


    /**
     * 根据领地id获取领地队伍列表
     * @param territorialId
     * @return
     */
    public Set<Integer> getTeamIds(int territorialId){
        return this.territorialTeamIds.getOrDefault(territorialId, Collections.emptySet());
    }

}
