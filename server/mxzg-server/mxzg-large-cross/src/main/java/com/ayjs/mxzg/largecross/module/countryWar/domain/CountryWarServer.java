package com.ayjs.mxzg.largecross.module.countryWar.domain;

/**
 * @Author: CWJ
 * @Date: 2021/4/12
 **/

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.message.module.countryWar.dto.CountryWarLogInfo;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.CopyOnWriteArrayList;

/**
 * @Author: CWJ
 * @Date: 2020/4/11
 **/
@Getter
@Setter
@Table(name = "country_war_server", comment = "国战服务器信息")
public class CountryWarServer extends AbstractEntity {
    @Id
    @Column(name = "server_id", comment = "服务器id")
    private int serverId;

    @Column(name = "score", comment = "积分")
    private int score;

    @Column(name = "round", comment = "轮次")
    private int round;

    @Column(name = "rank_time", comment = "分组时间")
    private LocalDateTime rankTime = LocalDateTime.of(1970, 1, 1, 0, 0);

    @Column(name = "active_fighting", comment = "活跃战斗力")
    private long activeFighting;

    @Column(name = "faction", comment = "阵营")
    private int faction;

    @Column(name = "base_camp", comment = "大本营")
    private int baseCamp;

    @Column(name = "city_reward_count", comment = "城池发奖次数")
    private Map<Integer, Integer> cityRewardCount = new HashMap<>();

    @Column(name = "event_reward_count", comment = "事件发奖次数")
    private Map<Integer, Integer> eventRewardCount = new HashMap<>();

    @Column(name = "logs", comment = "日志")
    private CopyOnWriteArrayList<CountryWarLogInfo> logs = new CopyOnWriteArrayList<>();

    @Column(name = "valid_server", comment = "服务器是否有效，合并后就无效")
    private boolean validServer;

    public void addCityRewardCount(int idx, int value) {
        cityRewardCount.put(idx, cityRewardCount.getOrDefault(idx, 0) + value);
    }

    public void addEventRewardCount(int idx, int value) {
        eventRewardCount.put(idx, eventRewardCount.getOrDefault(idx, 0) + value);
    }
}
