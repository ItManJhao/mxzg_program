package com.ayjs.mxzg.gameserver.module.weekendGift.handler;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.WeekendGiftSysCache;
import com.ayjs.mxzg.config.excel.entity.CWeekendGift;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.weekendGift.domain.WeekendGift;
import com.ayjs.mxzg.gameserver.module.weekendGift.service.WeekendGiftService;
import com.ayjs.mxzg.gameserver.module.weekendGift.struct.WeekendGiftRewardStatus;
import com.ayjs.mxzg.protocol.WeekendGiftGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * @Author: CWJ
 * @Date: 2020/3/21
 **/
@Component
public class WeekendGiftHandler extends ProtocolHandler {

    @Autowired
    private WeekendGiftService weekendGiftService;
    @Autowired
    private WeekendGiftSysCache weekendGiftSysCache;
    @Autowired
    private ThingService thingService;

    @CMD(id = CmdCode._61001)
    public void sendData(PlayerContext playerContext, WeekendGiftGMsg.GReqWeekendGiftData req) {
        WeekendGift weekendGift = weekendGiftService.load(playerContext.getId());
        WeekendGiftGMsg.GResWeekendGiftData.Builder builder = WeekendGiftGMsg.GResWeekendGiftData.newBuilder();
        builder.setStartTime(weekendGift.getStartTime());
        builder.setEndTime(weekendGift.getEndTime());
        weekendGift.getRewardStatus().forEach((key, value) -> {
            WeekendGiftGMsg.RewardStatus.Builder statusBuilder = WeekendGiftGMsg.RewardStatus.newBuilder();
            statusBuilder.setIdx(weekendGiftSysCache.getByDays(key).getIdx());
            statusBuilder.setStatus(value);
            builder.addRewardStatus(statusBuilder);
        });

        playerContext.write(CmdCode._61001, builder.build());
    }

    @CMD(id = CmdCode._61002)
    public void getReward(PlayerContext playerContext, WeekendGiftGMsg.GReqGetReward req) {
        WeekendGift weekendGift = weekendGiftService.load(playerContext.getId());
        int now = TimeDateUtil.getCurrentTimeInt();
        CWeekendGift config = weekendGiftSysCache.getById(req.getIdx());

        Asserts.isTrue(now > weekendGift.getStartTime() && now <= weekendGift.getEndTime(), ErrorCode.WEEKEND_GIFT_NOT_OPEN.getValue(),
                String.format("活动时间未开启{%s}-{%s}", weekendGift.getStartTime(), weekendGift.getEndTime()));
        Asserts.isTrue(weekendGift.getRewardStatus().get(config.getDays()) == WeekendGiftRewardStatus.CAN.getValue(), ErrorCode.WEEKEND_GIFT_NOT_OPEN.getValue(),
                String.format("领取状态不对{%s},idx:{%s}", weekendGift.getRewardStatus().get(config.getDays()), req.getIdx()));

        weekendGift.getRewardStatus().put(config.getDays(), WeekendGiftRewardStatus.HAD.getValue());
        weekendGiftService.update(weekendGift);

        thingService.add(playerContext.getId(), config.getReward(), GameEvent.WEEK_END_GIFT);

        WeekendGiftGMsg.GResGetReward.Builder builder = WeekendGiftGMsg.GResGetReward.newBuilder();
        weekendGift.getRewardStatus().forEach((key, value) -> {
            WeekendGiftGMsg.RewardStatus.Builder statusBuilder = WeekendGiftGMsg.RewardStatus.newBuilder();
            statusBuilder.setIdx(weekendGiftSysCache.getByDays(key).getIdx());
            statusBuilder.setStatus(value);
            builder.addRewardStatus(statusBuilder);
        });
        playerContext.write(CmdCode._61002, builder.build());
    }
}
