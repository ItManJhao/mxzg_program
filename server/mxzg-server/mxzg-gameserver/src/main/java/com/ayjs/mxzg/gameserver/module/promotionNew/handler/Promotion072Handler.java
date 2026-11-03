package com.ayjs.mxzg.gameserver.module.promotionNew.handler;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.config.excel.cache.promotion072.Promotion072floorSysCache;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.Rewards;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion072Service;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.protocol.Promotion072GMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

/**
 * 诸神祭坛
 */
@Controller
public class Promotion072Handler extends ProtocolHandler {

    @Autowired
    private Promotion072Service promotion072Service;
    @Autowired
    private PromotionControlService promotionControlService;
    @Autowired
    private Promotion072floorSysCache promotion072floorSysCache;
    @Autowired
    private ThingService thingService;

    /**
     * 诸神祭坛信息
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._75121)
    public void zSJTInfo(PlayerContext playerContext, Promotion072GMsg.GReqZSJTInfo msg) {
        Promotion072GMsg.GResZSJTInfo.Builder builder = Promotion072GMsg.GResZSJTInfo.newBuilder();
        builder.setInfo(promotion072Service.creatZSJTInfo(playerContext.getId()));
        playerContext.write(CmdCode._75121, builder.build());
    }

    /**
     * 抽奖
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._75122)
    public void zSJTLuckDraw(PlayerContext playerContext, Promotion072GMsg.GReqZSJTLuckDraw msg) {
        if(!promotionControlService.isPromotionRunning(PromotionType.ZHU_SHEN_JI_TAN)){
            Asserts.isTrue(false, ErrorCode.PROMOTION_072_TIME_OVER.getValue(),
                    String.format("诸神祭坛抽活动已经结束"));
            return;
        }
        long rid = playerContext.getId();
        int type = msg.getType();//抽奖类型，1:1次道具抽奖  2：多次道具抽奖  3：钻石抽奖
        Asserts.isTrue(type == 1 || type == 2 || type == 3, ErrorCode.PROMOTION_072_PARAM_ERRO.getValue(),
                String.format("诸神祭坛抽奖参数操作类型错误type{%s}", type));
        boolean isBatch = false;//是否批量抽奖
        boolean isMoneyDraw = false;//是否钻石抽奖
        if (type == 3) {//钻石抽奖
            isMoneyDraw = true;
        }
        if (type == 2) {//多次道具抽奖
            isBatch = true;
        }
        Promotion072GMsg.GResZSJTLuckDraw.Builder builder = Promotion072GMsg.GResZSJTLuckDraw.newBuilder();
        promotion072Service.luckDraw(rid, isBatch, isMoneyDraw,builder);
        builder.setInfo(promotion072Service.creatZSJTInfo(rid));
//        builder.addAllRewards(PbUtil.buildReward(gotList.getThingSet().asList()));
        playerContext.write(CmdCode._75122, builder.build());
    }
}
