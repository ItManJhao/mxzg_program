package com.ayjs.mxzg.gameserver.module.statistic.domain;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;

/**
 * 角色资源统计
 */
@Getter
@Setter
public class RoleStatistic {
    private long rid;

    private LocalDate date;
    // item id ,number
    Map<Integer, Long> itemMap = new HashMap<>();
    // star星级 --> 数量
    Map<Integer, Long> heroMap = new HashMap<>();

    public RoleStatistic(long rid) {
        this.rid = rid;
        this.date = LocalDate.now();
    }

    public void reset() {
        itemMap.clear();
        heroMap.clear();
        date = LocalDate.now();
    }
}
