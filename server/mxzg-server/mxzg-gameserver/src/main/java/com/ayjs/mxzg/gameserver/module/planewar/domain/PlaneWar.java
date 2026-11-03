package com.ayjs.mxzg.gameserver.module.planewar.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.common.persistence.hook.GetAfter;
import com.google.common.collect.Maps;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Map;

/**
 * @Author: CWJ
 * @Date: 2020/9/15
 **/
@Table(name = "plane_war", comment = "位面之战")
@Getter
@Setter
@Entity
public class PlaneWar extends AbstractEntity implements GetAfter {

    @Id
    @Column(name = "rid", comment = "玩家标识")
    private long rid;

    @Column(name = "pass_level_info", comment = "通关信息集合")
    private Map<Integer, Integer> passLevelInfo = Maps.newHashMap();

    @Column(name = "last_level_info", comment = "上次通关信息集合")
    private Map<Integer, Integer> lastLevelInfo = Maps.newHashMap();

    @Column(name = "pass_level_reset", comment = "通关信息重置时间")
    private LocalDate passLevelReset = LocalDate.of(2000, 1, 1);

    @Column(name = "had_challenge_count", comment = "已挑战次数")
    private int hadChallengeCount;

    @Column(name = "count_reset", comment = "次数重置时间")
    private LocalDate countReset = LocalDate.of(2000, 1, 1);

    @Column(name = "had_buy_count", comment = "已购买次数")
    private int hadBuyCount;

    @Column(name = "had_buy_privilege", comment = "是否已购买特权")
    private boolean hadBuyPrivilege;

    @Column(name = "rank_time", comment = "排行榜排名时间")
    private LocalDateTime rankTime = LocalDateTime.of(2000, 1, 1, 0, 0);

    public void addPassLevel(int element) {
        int curr = passLevelInfo.getOrDefault(element, 0);
        passLevelInfo.put(element, curr + 1);
        rankTime = LocalDateTime.now();
    }

    public void addHadChallengeCount(int addCount) {
        this.hadChallengeCount += addCount;
    }

    @Override
    public boolean getAfter() {
        boolean result = false;
        LocalDate now = LocalDate.now();
        if (!now.isEqual(getCountReset())) {
            setHadChallengeCount(0);
            setHadBuyCount(0);
            setCountReset(now);
            result = true;
        }
        return result;
    }
}
