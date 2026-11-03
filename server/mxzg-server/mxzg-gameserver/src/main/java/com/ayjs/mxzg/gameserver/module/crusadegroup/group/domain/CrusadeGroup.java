/**
 *
 */
package com.ayjs.mxzg.gameserver.module.crusadegroup.group.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.config.excel.constant.CrusadeGroupConst;
import com.ayjs.mxzg.config.struct.CrusadeGroupStage;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;


@Entity
@Table(name = "crusade_group", comment = "讨伐团信息,数据从跨服讨伐团同步而来")
@Getter
@Setter
public class CrusadeGroup extends AbstractEntity {

    @Id
    @Column(name = "id", readOnly = true)
    private int id;

    @Column(name = "group_map_id", comment = "讨伐团地图id")
    private int groupMapId;

    @Column(name = "group_id", comment = "讨伐团id")
    private int groupId;

    @Column(name = "stage", comment = "活动所处的阶段")
    private int stage;

    @Column(name = "head", comment = "团战id")
    private long head;

    @Column(name = "commander", comment = "指挥官id")
    private Set<Long> commander = new HashSet<>();

    @Column(name = "registration_start_time", comment = "报名开始时间")
    private LocalDateTime registrationStartTime = LocalDateTime.now();

    @Column(name = "registration_end_time", comment = "报名截止时间")
    private LocalDateTime registrationEndTime = LocalDateTime.now();

    @Column(name = "battle_start_time", comment = "战斗开始时间")
    private LocalDateTime battleStartTime = LocalDateTime.now();

    @Column(name = "battle_end_time", comment = "活动结束时间")
    private LocalDateTime battleEndTime = LocalDateTime.now();

    @Column(name = "boss_refresh_countdown", comment = "boss刷新倒计时")
    private LocalDateTime bossRefreshCountdown = LocalDateTime.now();

    @Column(name = "emblem", comment = "团徽")
    private int emblem;

    @Column(name = "group_name", comment = "讨伐团名称")
    private String groupName = "";
    /**
     * 更新信息
     * @param groupMapId
     * @param groupId
     * @param stage
     * @param head
     * @param commanders
     * @param registrationStartTime
     * @param registrationEndTime
     * @param battleStartTime
     * @param battleEndTime
     */
    public void updateGroup(int groupMapId, int groupId, int stage, long head, Set<Long> commanders, LocalDateTime registrationStartTime, LocalDateTime registrationEndTime
            , LocalDateTime battleStartTime, LocalDateTime battleEndTime,int emblem,String groupName){
        this.groupMapId = groupMapId;
        this.groupId = groupId;
        this.stage = stage;
        this.head = head;
        this.commander = commanders;
        this.registrationStartTime = registrationStartTime;
        this.registrationEndTime = registrationEndTime;
        this.battleStartTime = battleStartTime;
        this.battleEndTime = battleEndTime;
        this.emblem = emblem;
        if(groupName!=null) {
            this.groupName = groupName;
        }
    }

    /**
     * 是否在重命名时间内
     * @return
     */
    public boolean isInRenameTime(){
        LocalDateTime now = LocalDateTime.now();
        return now.isBefore(this.battleStartTime.plusDays(CrusadeGroupConst.RENAME_DAYS));

    }

    /**
     * 讨伐团是否关闭
     * @return
     */
    public boolean isClosed(){
        return this.stage == CrusadeGroupStage.UN_OPEN.ordinal() || this.stage == CrusadeGroupStage.CLOSE.ordinal();
    }

}
