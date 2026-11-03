/**
 *
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.handler;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion030MysteryBoxLevelRewardSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion030MysteryBoxRechargeRewardSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion030MysteryBoxSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion030MysteryBox;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion030MysteryBoxLevelReward;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion030MysteryBoxRechargeReward;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion030MysteryBox;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion030MysteryBoxService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.protocol.Task4GMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

/**
 * cwj
 */
@Controller
public class Promotion030MysteryBoxHandler extends ProtocolHandler {

    @Autowired
    private Promotion030MysteryBoxService promotion030MysteryBoxService;
    @Autowired
    private PromotionControlService promotionControlService;
    @Autowired
    private ThingService thingService;
    @Autowired
    private Promotion030MysteryBoxSysCache promotion030MysteryBoxSysCache;
    @Autowired
    private Promotion030MysteryBoxLevelRewardSysCache promotion030MysteryBoxLevelRewardSysCache;
    @Autowired
    private Promotion030MysteryBoxRechargeRewardSysCache promotion030MysteryBoxRechargeRewardSysCache;

    private PromotionType getPromotionType() {
        return PromotionType.SHEN_MI_MO_HE;
    }


    /***
     * .活动数据
     * @param playerContext
     * @param req
     */
    @CMD(id = CmdCode._13137)
    public void scanInfo(PlayerContext playerContext, Task4GMsg.GReqMysteryBoxInfo req) {
        Promotion030MysteryBox promotion = promotion030MysteryBoxService.getPromotionInfo(playerContext.getId());
        Task4GMsg.GResMysteryBoxInfo.Builder builder = Task4GMsg.GResMysteryBoxInfo.newBuilder();
        builder.setIdx(getPromotionType().getId());
        PromotionControl control = promotionControlService.getControl(getPromotionType());
        builder.setEndTime(control.getEndTime());
        builder.setStartTime(control.getStartTime());
        builder.setTurns(control.getTurns());
        builder.setClearTime(control.getClearTime());

        builder.setExp(promotion.getExp());
//        builder.set(promotion.getLevel());
        builder.addAllLvRewards(promotion.getLevelRewardRecord());
        builder.addAllIdxRechargeReward(promotion.getRechargeRewardRecord());
        builder.setTotalRecharge(promotion.getRecharge());
        builder.setCurrDay(DateTimeUtil.apartDay(control.getStartTime(), DateTimeUtil.currentSecond()) + 1);
        promotion.getCountMap().forEach((idx, count) -> {
            Task4GMsg.PSActivityUnit.Builder unitBuilder = Task4GMsg.PSActivityUnit.newBuilder();
            unitBuilder.setIdx(idx);
            unitBuilder.setIsGot(promotion.getRewardRecord().contains(idx) ? 1 : 0);
            unitBuilder.setProgress(count);
            builder.addList(unitBuilder);
        });

        playerContext.write(CmdCode._13137, builder.build());
    }

    /***
     * 任务领取
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._13138)
    public void getReward(PlayerContext playerContext, Task4GMsg.GReqMysteryBoxGet msg) {
        int idx = msg.getIdx();
        Asserts.isTrue(promotionControlService.isPromotionRunning(getPromotionType()), ErrorCode.HERO_ARRIVE_END.getValue(), "活动已关闭！");

        CPromotion030MysteryBox config = promotion030MysteryBoxSysCache.getOrThrow(idx);
        Promotion030MysteryBox promotionInfo = promotion030MysteryBoxService.getPromotionInfo(playerContext.getId());

        Asserts.isTrue(config.getTargetStruct().getTarget() <= promotionInfo.getCountMap().getOrDefault(idx, 0), ErrorCode.ACHIEVEMENT_PROCESS_LOW.getValue(), String.format("进度值不够，领取失败！[%s]-[%s]", config.getTargetStruct().getTarget(), promotionInfo.getCountMap().getOrDefault(idx, 0)));

        Asserts.isTrue(!promotionInfo.getRewardRecord().contains(idx), ErrorCode.PROMOTION_ID_HAD_REWARD.getValue(), String.format("该奖励已经领取！"));

        //经验加成后，客户端自己算
        promotionInfo.getRewardRecord().add(idx);
        promotionInfo.setExp(promotionInfo.getExp() + config.getExp());
        promotion030MysteryBoxService.updatePromotion(promotionInfo);
//        backPackService.add(rid, backPackService.jsonStrToReward(config.getExp()), GameEvent.HAPPY_TIME);

        promotion030MysteryBoxService.updateToClient(playerContext.getId(), config, promotionInfo);

    }

    /***
     * 充值领取
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._13139)
    public void getRechargeReward(PlayerContext playerContext, Task4GMsg.GReqMysteryBoxRechargeGet msg) {
        int idx = msg.getIdx();
        Asserts.isTrue(promotionControlService.isPromotionRunning(getPromotionType()), ErrorCode.HERO_ARRIVE_END.getValue(), "活动已关闭！");

        CPromotion030MysteryBoxRechargeReward config = promotion030MysteryBoxRechargeRewardSysCache.getOrThrow(idx);
        Promotion030MysteryBox promotionInfo = promotion030MysteryBoxService.getPromotionInfo(playerContext.getId());

        Asserts.isTrue(config.getRecharge_need() <= promotionInfo.getRecharge(), ErrorCode.ACHIEVEMENT_PROCESS_LOW.getValue(), String.format("充值金额不够，领取失败！[%s]-[%s]", config.getRecharge_need(), promotionInfo.getRecharge()));

        Asserts.isTrue(!promotionInfo.getRechargeRewardRecord().contains(idx), ErrorCode.PROMOTION_ID_HAD_REWARD.getValue(), String.format("该奖励已经领取！"));

        promotionInfo.getRechargeRewardRecord().add(idx);
        promotion030MysteryBoxService.updatePromotion(promotionInfo);
        thingService.add(playerContext.getId(), config.getReward(), GameEvent.MYSTERY_BOX);

        Task4GMsg.GResMysteryBoxRechargeGet.Builder builder = Task4GMsg.GResMysteryBoxRechargeGet.newBuilder();
        builder.setIdx(config.getIdx());
        playerContext.write(CmdCode._13139, builder.build());
    }

    /***
     * 等级领取
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._13140)
    public void getLevelReward(PlayerContext playerContext, Task4GMsg.GReqMysteryBoxExpGet msg) {
        int idx = msg.getIdx();
        Asserts.isTrue(promotionControlService.isPromotionRunning(getPromotionType()), ErrorCode.HERO_ARRIVE_END.getValue(), "活动已关闭！");

        CPromotion030MysteryBoxLevelReward config = promotion030MysteryBoxLevelRewardSysCache.getOrThrow(idx);
        Promotion030MysteryBox promotionInfo = promotion030MysteryBoxService.getPromotionInfo(playerContext.getId());

        Asserts.isTrue(config.getExp_need() <= promotionInfo.getExp(), ErrorCode.ACHIEVEMENT_PROCESS_LOW.getValue(), String.format("经验值不够，领取失败！[%s]-[%s]", config.getExp_need(), promotionInfo.getExp()));

        Asserts.isTrue(!promotionInfo.getLevelRewardRecord().contains(idx), ErrorCode.PROMOTION_ID_HAD_REWARD.getValue(), String.format("该奖励已经领取！"));

        promotionInfo.getLevelRewardRecord().add(idx);
        promotion030MysteryBoxService.updatePromotion(promotionInfo);
        thingService.add(playerContext.getId(), config.getReward(), GameEvent.ADVENTURE_NOTES);

        Task4GMsg.GResMysteryBoxExpGet.Builder builder = Task4GMsg.GResMysteryBoxExpGet.newBuilder();
        builder.setIdx(config.getLevel());
        playerContext.write(CmdCode._13140, builder.build());
    }
}
