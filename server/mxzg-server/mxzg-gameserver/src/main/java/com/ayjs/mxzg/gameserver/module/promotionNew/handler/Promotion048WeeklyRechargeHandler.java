package com.ayjs.mxzg.gameserver.module.promotionNew.handler;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion048WeeklyRecharge;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion048WeeklyRechargeService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion048WeeklyRechargeConfig;
import com.ayjs.mxzg.protocol.Promotion048GMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;


/**
 * 运营累计充值活动
 *
 * @Author: CWJ
 * @Date: 2019/11/3
 **/
@Component
public class Promotion048WeeklyRechargeHandler extends ProtocolHandler {

    @Autowired
    private Promotion048WeeklyRechargeService promotion048WeeklyRechargeService;
    @Autowired
    private PromotionControlService promotionControlService;
    @Autowired
    private ThingService thingService;


    @CMD(id = CmdCode._13015)
    public void sendData(PlayerContext playerContext, Promotion048GMsg.GReqRechargeWeekList req) {
        playerContext.write(CmdCode._13015, promotion048WeeklyRechargeService.sendData(playerContext.getId()));
    }

    @CMD(id = CmdCode._13016)
    public void reward(PlayerContext playerContext, Promotion048GMsg.GReqRechargeWeekGain req) {

        Asserts.isTrue(promotionControlService.isPromotionRunning(PromotionType.MEI_ZHOU_LEI_CHONG),
                ErrorCode.PROMOTION_NOT_RUNNING.getValue(), String.format("活动{%s}已关闭!", PromotionType.MEI_ZHOU_LEI_CHONG));

        Promotion048WeeklyRechargeConfig config = promotion048WeeklyRechargeService.getConfig(req.getIdx());
        Asserts.notNull(config, ErrorCode.CONFIG_NOT_EXIST.getValue(), String.format("活动配置{%s}不存在!", req.getIdx()));

        Promotion048WeeklyRecharge promotionInfo = promotion048WeeklyRechargeService.getPromotionInfo(playerContext.getId());
        Asserts.isTrue(promotionInfo.getRecharge() >= config.getRmb()
                , ErrorCode.RECHARGE_LOW.getValue(), String.format("重置金额{%s},需求金额{%s}", promotionInfo.getRecharge(), config.getRmb()));

        promotionInfo.getRewardIdx().add(config.getIdx());
        promotion048WeeklyRechargeService.updatePromotion(promotionInfo);

        thingService.add(playerContext.getId(), ImmutableThingUtil.fromJson(config.getItem()), GameEvent.WEEKLY_RECHARGE);

        playerContext.write(CmdCode._13015, promotion048WeeklyRechargeService.sendData(playerContext.getId()));
    }


}
