package com.ayjs.mxzg.gameserver.module.statistic.event;

import lombok.Value;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;

@Value(staticConstructor = "of")
public class RoleStatisticDailyEvent {
    private long rid;

    private LocalDate date;
    // item id ,number
    private Map<Integer, Long> itemMap = new HashMap<>();
    // star星级 --> 数量
    private Map<Integer, Long> heroMap = new HashMap<>();

}
