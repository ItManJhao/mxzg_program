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
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion050FestivalOvervalueGift;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion050FestivalOvervalueGiftService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion050FestivalOvervalueGiftConfig;
import com.ayjs.mxzg.protocol.Promotion050GMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

/**
 * 节日豪礼
 *
 * @author hyx
 */
@Controller
public class Promotion050FestivalOvervalueGiftHandler extends ProtocolHandler {

    @Autowired
    private Promotion050FestivalOvervalueGiftService promotion050FestivalOvervalueGiftService;
    @Autowired
    private ThingService thingService;
    @Autowired
    private PromotionControlService promotionControlService;

    @CMD(id = CmdCode._53001)
    public void getFestivalGiftInfo(PlayerContext playerContext, Promotion050GMsg.GReqFestivalOvervalueGift msg) {
        Promotion050GMsg.GResFestivalOvervalueGift.Builder builder = Promotion050GMsg.GResFestivalOvervalueGift.newBuilder();

        Promotion050FestivalOvervalueGift promotionInfo = promotion050FestivalOvervalueGiftService.getPromotionInfo(playerContext.getId());

        builder.setDay(promotion050FestivalOvervalueGiftService.getPromotionRunDay(DateTimeUtil.currentSecond()));
        builder.setReceiveDay(promotionInfo.getReceiveDay());
        builder.addAllIdx(promotionInfo.getBuyGift());

        playerContext.write(CmdCode._53001, builder.build());
    }

    /**
     * 领取奖励内容
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._53002)
    public void receiveFestivalGift(PlayerContext playerContext, Promotion050GMsg.GResFestivalGiftReceive msg) {

        Promotion050FestivalOvervalueGiftConfig promotionConfig = promotion050FestivalOvervalueGiftService.selectConfigIdx(msg.getIdx());
        Asserts.isTrue(promotionConfig.getGrid_type() == 1, ErrorCode.FESTIVAL_GIFT_TYPE.getValue(), "节日礼包类型不符合");

        Promotion050FestivalOvervalueGift promotion050FestivalOvervalueGift = promotion050FestivalOvervalueGiftService.getPromotionInfo(playerContext.getId());
        Asserts.isTrue(promotion050FestivalOvervalueGift.getBuyGift().contains(promotionConfig.getIdx()), ErrorCode.FESTIVAL_GIFT_NOT_BUY.getValue(), "节日礼包尚未购买");

        Asserts.isTrue(promotion050FestivalOvervalueGiftService.getPromotionRunDay(DateTimeUtil.currentSecond()) > promotion050FestivalOvervalueGift.getReceiveDay(),
                ErrorCode.FESTIVAL_GIFT_LOGIN_DAY.getValue(), "节日礼包登陆天数不满足");

        Asserts.isTrue(promotionControlService.isPromotionRunning(PromotionType.JIE_RI_LI_BAO), ErrorCode.PROMOTION_NOT_RUNNING.getValue(), "活动已经结束。");

        promotion050FestivalOvervalueGift.setReceiveDay(promotion050FestivalOvervalueGift.getReceiveDay() + 1);
        promotion050FestivalOvervalueGiftService.updatePromotion(promotion050FestivalOvervalueGift);

        thingService.add(playerContext.getId(), ImmutableThingUtil.fromJson(promotionConfig.getGift_reward()), GameEvent.FESTIVAL_OVERVALUE_GIFT, NoticeType.NORMAL);

        Promotion050GMsg.GResFestivalGiftReceive.Builder builder = Promotion050GMsg.GResFestivalGiftReceive.newBuilder();
        builder.setIdx(msg.getIdx());
        builder.setReceiveDay(promotion050FestivalOvervalueGift.getReceiveDay());
        playerContext.write(CmdCode._53002, builder.build());

    }

}
