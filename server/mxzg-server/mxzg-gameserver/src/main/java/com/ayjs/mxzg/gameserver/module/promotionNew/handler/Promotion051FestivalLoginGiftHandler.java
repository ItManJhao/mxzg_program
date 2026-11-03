package com.ayjs.mxzg.gameserver.module.promotionNew.handler;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion051FestivalLoginGift;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion051FestivalLoginGiftService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion051FestivalLoginGiftConfig;
import com.ayjs.mxzg.protocol.Promotion051GMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

/**
 * 节日登陆赠礼
 *
 * @author hyx
 */
@Controller
public class Promotion051FestivalLoginGiftHandler extends ProtocolHandler {

    @Autowired
    private Promotion051FestivalLoginGiftService promotion051FestivalLoginGiftService;
    @Autowired
    private PromotionControlService promotionControlService;
    @Autowired
    private ThingService thingService;

    /**
     * 获取节日登陆数据
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._52001)
    public void getFestivalLoginInfo(PlayerContext playerContext, Promotion051GMsg.GReqFestivalLoginInfo msg) {
        Promotion051GMsg.GResFestivalLoginInfo.Builder builder = Promotion051GMsg.GResFestivalLoginInfo.newBuilder();
        Promotion051FestivalLoginGift promotionInfo = promotion051FestivalLoginGiftService.getPromotionInfo(playerContext.getId());
        //当不处于同一天时。
        if (promotionControlService.isPromotionRecording(PromotionType.JIE_RI_DENG_LU)
                && !DateTimeUtil.isSameDate(promotionInfo.getTime(), DateTimeUtil.currentSecond())) {
            promotionInfo.setDay(promotionInfo.getDay() + 1);
            promotionInfo.setTime(DateTimeUtil.currentSecond());
            promotion051FestivalLoginGiftService.updatePromotion(promotionInfo);
        }
        builder.setDay(promotionInfo.getDay());
        builder.addAllRewardList(promotionInfo.getRewardList());
        playerContext.write(CmdCode._52001, builder.build());
    }

    /**
     * 领取节日登陆奖励
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._52002)
    public void getFestivalLoginReward(PlayerContext playerContext, Promotion051GMsg.GReqFestivalLoginReward msg) {

        Asserts.isTrue(promotionControlService.isPromotionRunning(PromotionType.JIE_RI_DENG_LU),
                ErrorCode.PROMOTION_NOT_RUNNING.getValue(), "活动id:" + PromotionType.JIE_RI_DENG_LU);

        Promotion051GMsg.GResFestivalLoginReward.Builder builder = Promotion051GMsg.GResFestivalLoginReward.newBuilder();
        Promotion051FestivalLoginGift promotion = promotion051FestivalLoginGiftService.getPromotionInfo(playerContext.getId());

        Asserts.isTrue(promotion.getDay() >= msg.getDay(), ErrorCode.FESTIVAL_LOGIN_DAY_LOW.getValue(),
                String.format("当前登陆天数｛%s｝,要求天数｛%s｝", promotion.getDay(), msg.getDay()));

        Asserts.isTrue(!promotion.getRewardList().contains(msg.getDay()), ErrorCode.PROMOTION_ID_HAD_REWARD.getValue(), "奖励已领取");

        promotion.getRewardList().add(msg.getDay());
        promotion051FestivalLoginGiftService.updatePromotion(promotion);

        Promotion051FestivalLoginGiftConfig promotionConfig = promotion051FestivalLoginGiftService.selectConfig(msg.getDay());
        thingService.add(playerContext.getId(), ImmutableThingUtil.fromJson(promotionConfig.getItem()), GameEvent.FESTIVAL_LOGIN_GIFT, NoticeType.NORMAL);

        playerContext.write(CmdCode._52002, builder.build());
    }

}
