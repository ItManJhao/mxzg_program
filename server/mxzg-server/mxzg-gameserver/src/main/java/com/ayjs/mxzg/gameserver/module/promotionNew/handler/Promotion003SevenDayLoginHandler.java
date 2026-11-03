package com.ayjs.mxzg.gameserver.module.promotionNew.handler;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.JsonUtil;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.TimeConstants;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion003NewSevenDayLoginSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion003NewSevenDayLogin;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.TargetStruct;
import com.ayjs.mxzg.config.struct.TargetType;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.event.SevenDayLoginRewardEvent;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.targetCounter.service.TargetCounterService;
import com.ayjs.mxzg.protocol.SevenDayLoginGMsg.GReqSevenDayLoginData;
import com.ayjs.mxzg.protocol.SevenDayLoginGMsg.GReqSevenDayLoginReward;
import com.ayjs.mxzg.protocol.SevenDayLoginGMsg.GResSevenDayLoginData;
import com.ayjs.mxzg.protocol.SevenDayLoginGMsg.GResSevenDayLoginReward;
import com.ayjs.mxzg.protocol.SevenDayLoginGMsg.PSSevenLoginStatus;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * @description:
 * @author: CWJ
 * @date: 2019/10/13 22:26
 */
@Component
public class Promotion003SevenDayLoginHandler extends ProtocolHandler {

    @Autowired
    private RoleService roleService;
    @Autowired
    private Promotion003NewSevenDayLoginSysCache promotionNew7DayLoginSysCache;
    @Autowired
    private ThingService thingService;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private TargetCounterService targetCounterService;

    /**
     * 七日登录数据
     *
     * @param playerContext
     * @param req
     */
    @CMD(id = CmdCode._22000)
    public void sendData(PlayerContext playerContext, GReqSevenDayLoginData req) {
        long rid = playerContext.getId();
        GResSevenDayLoginData.Builder builder = GResSevenDayLoginData.newBuilder();
        Role role = roleService.getOrThrow(rid);
        // 发送七日登录信息
        List<CPromotion003NewSevenDayLogin> allConfig = promotionNew7DayLoginSysCache.getAll();
        allConfig.forEach(promotionNew7DayLogin -> {
            PSSevenLoginStatus.Builder statusBuilder = PSSevenLoginStatus.newBuilder();
            statusBuilder.setIdx(promotionNew7DayLogin.getDay());
            statusBuilder.setStatus(role.getSevenDayLoginRewards().contains(promotionNew7DayLogin.getDay()) ? 1 : 0);
            builder.addList(statusBuilder);
        });

        builder.setCurDay((int) targetCounterService.calcTaskCount(rid,
                TargetStruct.of(TargetType.LOGIN, 0, 0)));
        builder.setEndTime(DateTimeUtil.theDayBreak((int) (role.getCreateTime() / TimeConstants.ONE_SECOND_MILLIS)) + 7 * TimeConstants.ONE_DAY_SECOND);
        playerContext.write(CmdCode._22000, builder.build());

    }

    /**
     * 领取七日登录奖励
     *
     * @param playerContext
     * @param req
     */
    @CMD(id = CmdCode._22001)
    public void rewardSevenDay(PlayerContext playerContext, GReqSevenDayLoginReward req) {
        CPromotion003NewSevenDayLogin cPromotion7DayTarget = promotionNew7DayLoginSysCache.getOrThrow(req.getDay());

        Role role = roleService.getOrThrow(playerContext.getId());

        int loginDays = (int) targetCounterService.calcTaskCount(playerContext.getId(), TargetStruct.of(TargetType.LOGIN, 0, 0));
        Asserts.isTrue(!role.getSevenDayLoginRewards().contains(req.getDay()),
                ErrorCode.SEVEN_DAY_TARGET_HAD_REWARD.getValue(), String.format("七天登录已经领取,已领取{%s},请求领取{%s}",
                        JsonUtil.toJson(role.getSevenDayLoginRewards()), req.getDay()));

        Asserts.isTrue(req.getDay() <= loginDays,
                ErrorCode.SEVEN_DAY_TARGET_HAD_REWARD.getValue(), String.format("开户天数不足,当前开服天数{%s},请求领取天数{%s}", loginDays, req.getDay()));

        role.getSevenDayLoginRewards().add(req.getDay());
        roleService.updateRole(role);
        // 奖励
        thingService.add(role.getId(), cPromotion7DayTarget.getItem(), GameEvent.SEVEN_LOGIN_REWARD);

        GResSevenDayLoginReward.Builder builder = GResSevenDayLoginReward.newBuilder();
        PSSevenLoginStatus.Builder statusBuilder = PSSevenLoginStatus.newBuilder();
        statusBuilder.setIdx(req.getDay());
        statusBuilder.setStatus(1);
        builder.setStatus(statusBuilder);
        playerContext.write(CmdCode._22001, builder.build());

        eventBus.post(SevenDayLoginRewardEvent.of(role.getId(), req.getDay()));
    }
}
