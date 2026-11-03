package com.ayjs.mxzg.gameserver.module.statistic.service;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.gameserver.module.statistic.domain.RoleStatistic;
import com.ayjs.mxzg.gameserver.module.statistic.event.RoleStatisticDailyEvent;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * 角色资源统计
 */
@Component
public class RoleStatisticService {

    @Autowired
    private EventBus eventBus;

    private static Map<Long, RoleStatistic> statisticMap = new ConcurrentHashMap<>();

    public RoleStatistic getOrCreate(long rid) {
        RoleStatistic roleStatistic = statisticMap.computeIfAbsent(rid, key -> new RoleStatistic(rid));
        if (!LocalDate.now().isEqual(roleStatistic.getDate())) {
            RoleStatisticDailyEvent event = RoleStatisticDailyEvent.of(roleStatistic.getRid(),
                    roleStatistic.getDate());
            event.getItemMap().putAll(roleStatistic.getItemMap());
            event.getHeroMap().putAll(roleStatistic.getHeroMap());
            eventBus.post(event);

            roleStatistic.reset();
        }
        return roleStatistic;
    }


    public void update(long rid, int thingId, long number) {
        RoleStatistic roleStatistic = getOrCreate(rid);

        roleStatistic.getItemMap().compute(thingId, (k, v) -> (v == null) ? number : v + number);

        checkWarn(roleStatistic);
    }

    public void updateHero(long rid, int star) {
        RoleStatistic roleStatistic = getOrCreate(rid);

        roleStatistic.getHeroMap().compute(star, (k, v) -> (v == null) ? 1 : v + 1);

    }

    // TODO
    public void checkWarn(RoleStatistic roleStatistic) {
        // 下个版本再实现
    }


}
