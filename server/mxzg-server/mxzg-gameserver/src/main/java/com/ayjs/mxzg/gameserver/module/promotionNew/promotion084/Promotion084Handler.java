package com.ayjs.mxzg.gameserver.module.promotionNew.promotion084;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.gson.GsonUtils;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion084.converter.Promotion084PB;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion084.domain.Promotion084;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion084.service.Promotion084Service;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion084ThreeDayConfig;
import com.ayjs.mxzg.protocol.Promotion084GMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * @Author: CWJ
 * @Date: 2020/9/22
 **/
@Component
public class Promotion084Handler extends ProtocolHandler {

    @Autowired
    private Promotion084Service promotion084Service;
    @Autowired
    private Promotion084PB promotion084PB;
    @Autowired
    private ThingService thingService;

    @CMD(id = CmdCode._76060)
    public void getData(PlayerContext playerContext, Promotion084GMsg.GReqThreeDay req) {
        if (!promotion084Service.isOpening()) {
            playerContext.write(CmdCode._76060, Promotion084GMsg.GResThreeDay.getDefaultInstance());
            return;
        }
        playerContext.write(CmdCode._76060, promotion084PB.buildData(promotion084Service.getPromotionInfo(playerContext.getId())));
    }

    @CMD(id = CmdCode._76061)
    public void get(PlayerContext playerContext, Promotion084GMsg.GReqThreeDayGet req) {
        Asserts.isTrue(promotion084Service.isOpening(), ErrorCode.PROMOTION_NOT_RUNNING.getValue(), String.format("活动为开启！"));
        Promotion084 promotionInfo = promotion084Service.getPromotionInfo(playerContext.getId());
        Promotion084ThreeDayConfig config = promotion084Service.getConfig(req.getIdx());
        Long currValue = promotionInfo.getRechargeInfo().getOrDefault(config.getId(), 0l);
        Asserts.isTrue(config.getRmb() <= currValue,
                ErrorCode.PROMOTION_084_RECHARGE_LOW.getValue(),
                String.format("充值金额不足{%s}-{%s}", config.getRmb(), currValue));

        Asserts.isTrue(!promotionInfo.getRewardRecord().contains(config.getId()),
                ErrorCode.PROMOTION_084_HAD_REWARD.getValue(),
                String.format("已经领奖{%s}-{%s}", GsonUtils.toJson(promotionInfo.getRewardRecord()), config.getId()));

        promotionInfo.getRewardRecord().add(config.getId());
        promotion084Service.updatePromotion(promotionInfo);

        thingService.add(playerContext.getId(), config.getRewardThings(), GameEvent.PROMOTION_084_GET_REWARD);
        playerContext.write(CmdCode._76061, promotion084PB.buildGet(req.getIdx()));
    }

}
