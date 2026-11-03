package com.ayjs.mxzg.gameserver.web.api;

import com.alibaba.fastjson.JSON;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.util.JsonUtil;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.recharge.domain.RoleRecharge;
import com.ayjs.mxzg.gameserver.module.recharge.service.RoleRechargeService;
import com.ayjs.mxzg.gameserver.web.constant.WebErrorCode;
import com.ayjs.mxzg.gameserver.web.event.PlatformCostEvent;
import com.ayjs.mxzg.gameserver.web.support.WebResult;
import com.google.common.collect.Maps;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 */
@RestController
@RequestMapping("/cost")
@Slf4j
public class PlatformCostApi {

    @Autowired
    private ThingService thingService;
    @Autowired
    private RoleRechargeService roleRechargeService;
    @Autowired
    private EventBus eventBus;

    /**
     * 扣除道具
     *
     * @return
     */
    @RequestMapping(value = "/item", method = RequestMethod.POST)
    public String item(long rid, String item) {
        try {
            Map<Integer, Long> costItem = JsonUtil.getMap(item, Integer.class, Long.class);
            Maps.newHashMap(costItem).forEach((key, value) -> {
                if (key == null ||  value.longValue() <= 0) {
                    costItem.remove(key);
                }
            });
            List<ImmutableThing> costThing = new ArrayList<>();
            costItem.forEach((itemType, num) -> {
                if (num > 0)
                    costThing.add(ImmutableThing.of(itemType, num));
            });

            ImmutableThingUtil.mergeThing(costThing);
            thingService.cost(rid, costThing, GameEvent.PLATFORM);

            eventBus.post(PlatformCostEvent.of(rid, costItem, null));
        } catch (Exception e) {
            log.error("扣除道具失败，角色id:" + rid + ",道具信息：" + JsonUtil.toJson(item), e);
            return JSON.toJSONString(WebResult.of(WebErrorCode.FAIL.getCode(), "失败"));
        }
        return JSON.toJSONString(WebResult.of(WebErrorCode.SUCCESS.getCode(), "成功"));
    }

    /**
     * 扣除充值
     *
     * @return
     */
    @RequestMapping(value = "/recharge", method = RequestMethod.POST)
    public String recharge(long rid, long total, long week, long daily) {
        try {
            RoleRecharge roleRecharge = roleRechargeService.getRoleRecharge(rid);
            roleRecharge.setTotalRecharge(Math.max(roleRecharge.getTotalRecharge() - total, 0));
            roleRecharge.setWeeklyRecharge(Math.max(roleRecharge.getWeeklyRecharge() - week, 0));
            roleRecharge.setDailyRecharge(Math.max(roleRecharge.getDailyRecharge() - daily, 0));
            roleRechargeService.update(roleRecharge);

            Map<Integer, Long> map = new HashMap<>();
            map.put(PlatformCostEvent.RechargeType.TOTAL.getValue(), total);
            map.put(PlatformCostEvent.RechargeType.WEEK.getValue(), week);
            map.put(PlatformCostEvent.RechargeType.DAILY.getValue(), daily);
            eventBus.post(PlatformCostEvent.of(rid, null, map));
        } catch (Exception e) {
            log.error("扣除充值失败,角色id:" + rid + "，total=" + total + ",week=" + week + ",daily=" + daily, e);
            return JSON.toJSONString(WebResult.of(WebErrorCode.FAIL.getCode(), "失败"));
        }
        return JSON.toJSONString(WebResult.of(WebErrorCode.SUCCESS.getCode(), "成功"));
    }

}
