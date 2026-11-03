package com.ayjs.mxzg.gameserver.module.achievement.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Data;

import java.util.ArrayList;
import java.util.List;

/**
 * @description: 玩家每日任务表
 * @author: CWJ
 * @date: 2019/10/12 15:31
 */
@Table(name = "role_daily_task")
@Data
@Entity
public class RoleDailyTask extends AbstractEntity {
    @Id
    @Column(name = "rid")
    private long rid;
    @Column(name = "task_value", comment = "任务值")
    private int taskValue;
    @Column(name = "reward_str", comment = "每日任务宝箱领取记录")
    private List<Integer> rewards = new ArrayList<>();
    @Column(name = "box_refresh_time", comment = "宝箱刷新时间")
    private int boxRefreshTime;
    @Column(name = "task_reset_time", comment = "每日任务重置时间")
    private long taskResetTime;
    @Column(name = "last_login_time")
    private int lastLoginTime;

    public long getRid() {
        return rid;
    }

    public void setRid(long rid) {
        this.rid = rid;
    }

    public int getTaskValue() {
        return taskValue;
    }

    public void setTaskValue(int taskValue) {
        this.taskValue = taskValue;
    }

    public void addReward(int rewardId) {
        rewards.add(rewardId);
    }

    public List<Integer> getRewards() {
        return rewards;
    }

    public void addTaskValue(int value) {
        this.taskValue += value;
    }
}
