package com.ayjs.mxzg.gameserver.module.firstRecharge.handler;

import java.util.ArrayList;
import java.util.List;
import java.util.Map.Entry;
import java.util.stream.Collectors;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.gameserver.module.firstRecharge.event.FirstRechargeEvent;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion001FirstRechargeSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion001FirstRecharge;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.firstRecharge.domain.FirstRecharge;
import com.ayjs.mxzg.gameserver.module.firstRecharge.service.FirstRechargeService;
import com.ayjs.mxzg.gameserver.module.recharge.domain.RoleRecharge;
import com.ayjs.mxzg.gameserver.module.recharge.service.RoleRechargeService;
import com.ayjs.mxzg.protocol.FirstRechargeMsg.GReqFirstRecharge;
import com.ayjs.mxzg.protocol.FirstRechargeMsg.GReqFirstRechargeReward;
import com.ayjs.mxzg.protocol.FirstRechargeMsg.GResFirstRecharge;
import com.ayjs.mxzg.protocol.FirstRechargeMsg.GResFirstRechargeReward;
import com.ayjs.mxzg.protocol.ObjectGMsg.PSMapData;
import com.ayjs.mxzg.template.constant.ErrorCode;

/**
 * @Author: CWJ
 * @Date: 2019/10/30
 **/
@Component
public class FirstRechargeHandler extends ProtocolHandler {

    @Autowired
    private FirstRechargeService firstRechargeService;
    @Autowired
    private RoleRechargeService roleRechargeService;
    @Autowired
    private Promotion001FirstRechargeSysCache promotion001FirstRechargeSysCache;
    @Autowired
    private ThingService thingService;
    @Autowired
    private EventBus eventBus;

    /***
     * 新手充值礼包
     * @param playerContext
     * @param req
     */
    @CMD(id = CmdCode._20012)
    public void rechargeFirstData(PlayerContext playerContext, GReqFirstRecharge req) {
        FirstRecharge entity = firstRechargeService.get(playerContext.getId());

        GResFirstRecharge.Builder builder = GResFirstRecharge.newBuilder();
        RoleRecharge roleRecharge = roleRechargeService.getRoleRecharge(playerContext.getId());

        builder.setRecharge((int) roleRecharge.getTotalRecharge());

        for (Entry<Integer, Integer> entry : entity.getActiveTimeMap().entrySet()) {
            List<CPromotion001FirstRecharge> rewards = promotion001FirstRechargeSysCache.getDaysReward(entry.getKey());
            boolean noReward = true;
            for (CPromotion001FirstRecharge reward : rewards) {
                if (!entity.getRewards().contains(reward.getIdx())) {
                    noReward = false;
                }
            }
            boolean isToday = TimeDateUtil.isToday(entity.getRewardTime().getOrDefault(entry.getKey(), 0));

            PSMapData.Builder model = PSMapData.newBuilder();
            model.setKey(entry.getKey());
            //今天已经领取或者没有奖励可以领取返回1
            model.setValue(isToday || noReward ? 1 : 0);
            builder.addCanReward(model.build());
        }
        builder.addAllList(entity.getRewards());
        playerContext.write(CmdCode._20012, builder.build());
    }

    /***
     * 领取新手充值
     * @param playerContext
     * @param req
     */
    @CMD(id = CmdCode._20013)
    public void rewardFirstRecharge(PlayerContext playerContext, GReqFirstRechargeReward msg) {
        //msg.getIdx()是首充奖励表的type
        FirstRecharge entity = firstRechargeService.get(playerContext.getId());
        Integer time = entity.getActiveTimeMap().get(msg.getIdx());

        Asserts.isTrue(time != null, ErrorCode.FIRST_RECHARGE_NOT_ACTIVE.getValue(), "未激活充值");

        int now = TimeDateUtil.getCurrentTimeInt();
        int interval = TimeDateUtil.intervalDays(time, now);
        List<CPromotion001FirstRecharge> rewardConfigs = promotion001FirstRechargeSysCache.getAll().stream()
                .filter(config -> config.getType() == msg.getIdx() && config.getDay() <= interval
                        && !entity.getRewards().contains(config.getIdx()))
                .collect(Collectors.toList());

        Asserts.isTrue(!rewardConfigs.isEmpty(), ErrorCode.PROMOTION_TOOK_REWARD.getValue(), "奖励已经领取");

        entity.getRewardTime().put(msg.getIdx(), now);
        List<ImmutableThing> rewardList = new ArrayList<>();
        for (CPromotion001FirstRecharge cFirstRecharge : rewardConfigs) {
            entity.getRewards().add(cFirstRecharge.getIdx());
            rewardList.addAll(cFirstRecharge.getReward());
        }
        List<ImmutableThing> rewardListMerge = ImmutableThingUtil.mergeThing(rewardList);
        firstRechargeService.update(entity);

        thingService.add(playerContext.getId(), rewardListMerge, GameEvent.FIRST_RECHARGE_REWARD);

        GResFirstRechargeReward.Builder builder = GResFirstRechargeReward.newBuilder();
        builder.setIdx(msg.getIdx());
        playerContext.write(CmdCode._20013, builder.build());

        eventBus.post(FirstRechargeEvent.of(playerContext.getId()));
    }
}
