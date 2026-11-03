package com.ayjs.mxzg.gameserver.module.growthGiftBag.handler;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.config.excel.cache.GrowthGiftSysCache;
import com.ayjs.mxzg.config.excel.entity.CGrowthGift;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.growthGiftBag.constant.GrowthGiftType;
import com.ayjs.mxzg.gameserver.module.growthGiftBag.domain.GrowthGift;
import com.ayjs.mxzg.gameserver.module.growthGiftBag.service.GrowthGiftService;
import com.ayjs.mxzg.gameserver.module.recharge.domain.RoleRecharge;
import com.ayjs.mxzg.gameserver.module.recharge.service.RoleRechargeService;
import com.ayjs.mxzg.protocol.PromotionGMsg;
import com.ayjs.mxzg.protocol.PromotionGMsg.GResVipDecorateBuy;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

@Controller
public class GrowthGiftHandler extends ProtocolHandler {

    @Autowired
    private ThingService thingService;
    @Autowired
    private GrowthGiftService growthGiftService;
    @Autowired
    private RoleRechargeService roleRechargeService;
    @Autowired
    private GrowthGiftSysCache growthGiftSysCache;



    /**
     * 成长礼包列表1购买
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._20004)
    public void vipBuyReward(PlayerContext playerContext, PromotionGMsg.GReqVipRewardBuy msg) {
        RoleRecharge roleRecharge = roleRechargeService.getRoleRecharge(playerContext.getId());

        CGrowthGift cModel = growthGiftSysCache.getOrThrow(msg.getVipLevel());
        if(roleRecharge.getTotalRecharge() < cModel.getNeed_recharge()){
            playerContext.writeError(ErrorCode.RECHARGE_LOW);
            return;
        }

        GrowthGift growthGift = growthGiftService.select(playerContext.getId(),GrowthGiftType.BUY_GIFT);
        if(growthGift.getReward_idx().contains(msg.getVipLevel())){
            playerContext.writeError(ErrorCode.GROWTH_GIFT);
            return;
        }

        thingService.cost(playerContext.getId(), cModel.getPack_cost(), GameEvent.GROWTH_GIFT_BUY);

        thingService.add(playerContext.getId(), cModel.getGem_pack(), GameEvent.GROWTH_GIFT_BUY);

        growthGift.getReward_idx().add(msg.getVipLevel());
        growthGiftService.update(growthGift);

        PromotionGMsg.GResVipRewardBuy.Builder builder = PromotionGMsg.GResVipRewardBuy.newBuilder();
        builder.setVipLevel(msg.getVipLevel());
        playerContext.write(CmdCode._20004,builder.build());

        //更新列表
//        growthGiftService.vipBuyRewardList(playerContext.getId());

    }

    /**
     * 成长礼包列表2领取
     * @param playerContext
     * @param msg
     */
    @CMD( id = CmdCode._20010)
    public void vipDecorateReward(PlayerContext playerContext, PromotionGMsg.GReqVipDecorateBuy msg){
        RoleRecharge roleRecharge = roleRechargeService.getRoleRecharge(playerContext.getId());

        CGrowthGift cModel = growthGiftSysCache.getOrThrow(msg.getIdx());
        if(roleRecharge.getTotalRecharge() < cModel.getNeed_recharge()){
            playerContext.writeError(ErrorCode.RECHARGE_LOW);
            return;
        }

        GrowthGift growthGift = growthGiftService.select(playerContext.getId(),GrowthGiftType.DECORATE_GIFT);
        if(growthGift.getReward_idx().contains(msg.getIdx())){
            playerContext.writeError(ErrorCode.GROWTH_GIFT);
            return;
        }

        thingService.add(playerContext.getId(), cModel.getDecorate_item(),
                GameEvent.GROWTH_GIFT_GET);

        growthGift.getReward_idx().add(msg.getIdx());
        growthGiftService.update(growthGift);

        GResVipDecorateBuy.Builder builder = GResVipDecorateBuy.newBuilder();
        builder.setIdx(msg.getIdx());
        playerContext.write(CmdCode._20010, builder.build());

        growthGiftService.vipDecorateRewardList(playerContext.getId());
    }

    /**
     * 获取成长列表2
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._20011)
    public void getVipDecorateRewardList(PlayerContext playerContext, PromotionGMsg.GReqVipDecorateReward msg){
        growthGiftService.vipDecorateRewardList(playerContext.getId());
    }
}
