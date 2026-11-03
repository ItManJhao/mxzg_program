package com.ayjs.mxzg.gameserver.module.onlineReward.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Data;

import java.time.LocalDate;
import java.util.HashSet;
import java.util.Set;

/**
 * @description: 在线奖励
 * @author: CWJ
 * @date: 2019/10/11 16:43
 */
@Entity
@Table(name = "online_reward", comment = "在线奖励表")
@Data
public class OnlineReward extends AbstractEntity {
    @Id
    @Column(name = "rid", readOnly = true, unique = true, nullable = false)
    private long rid;
    @Column(name = "online_time", comment = "累计在线时间")
    private int onlineTime;
    @Column(name = "rewards", comment = "领取累计在线奖励数据")
    private Set<Integer> rewards = new HashSet<>();

    @Column(name = "today_online_time", comment = "当天在线时间")
    private int todayOnlineTime;

    @Column(name = "online_time_refresh_date", comment = "当天在线时间刷新日期")
    private LocalDate onlineTimeRefreshDate;

    @Column(name = "once_again_rewards",comment = "已再领取一次奖励集",defaultValue = "[]")
    private Set<Integer> onceAgainList = new HashSet<>();

}
