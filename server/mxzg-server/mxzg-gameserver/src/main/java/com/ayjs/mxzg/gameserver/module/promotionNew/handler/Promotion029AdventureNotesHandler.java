/**
 *
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.handler;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion029AdventureNotesLevelRewardSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion029AdventureNotesRechargeRewardSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion029AdventureNotesSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion029AdventureNotes;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion029AdventureNotesLevelReward;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion029AdventureNotesRechargeReward;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion029AdventureNotes;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion029AdventureNotesService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.protocol.Task4GMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

/**
 * cwj
 */
@Controller
public class Promotion029AdventureNotesHandler extends ProtocolHandler {

    @Autowired
    private Promotion029AdventureNotesService promotion029AdventureNotesService;
    @Autowired
    private PromotionControlService promotionControlService;
    @Autowired
    private ThingService thingService;
    @Autowired
    private Promotion029AdventureNotesSysCache promotion029AdventureNotesSysCache;
    @Autowired
    private Promotion029AdventureNotesLevelRewardSysCache promotion029AdventureNotesLevelRewardSysCache;
    @Autowired
    private Promotion029AdventureNotesRechargeRewardSysCache promotion029AdventureNotesRechargeRewardSysCache;

    private PromotionType getPromotionType() {
        return PromotionType.MAO_XIAN_RI_JI;
    }


    /***
     * .活动数据
     * @param playerContext
     * @param req
     */
    @CMD(id = CmdCode._13132)
    public void scanInfo(PlayerContext playerContext, Task4GMsg.GReqAdventureNoteInfo req) {
        Promotion029AdventureNotes promotion = promotion029AdventureNotesService.getPromotionInfo(playerContext.getId());

        Task4GMsg.GResAdventureNoteInfo.Builder builder = Task4GMsg.GResAdventureNoteInfo.newBuilder();
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
        promotion029AdventureNotesService.getConfigByTurns().forEach(config -> {

            Task4GMsg.PSActivityUnit.Builder unitBuilder = Task4GMsg.PSActivityUnit.newBuilder();
            unitBuilder.setIdx(config.getIdx());
            unitBuilder.setIsGot(promotion.getRewardRecord().contains(config.getIdx()) ? 1 : 0);
            unitBuilder.setProgress(promotion.getCountMap().getOrDefault(config.getIdx(), 0));
            builder.addList(unitBuilder);
        });

        playerContext.write(CmdCode._13132, builder.build());
    }

    /***
     * 任务领取
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._13133)
    public void getReward(PlayerContext playerContext, Task4GMsg.GReqAdventureNoteGet msg) {
        int idx = msg.getIdx();
        Asserts.isTrue(promotionControlService.isPromotionRunning(getPromotionType()), ErrorCode.HERO_ARRIVE_END.getValue(), "活动已关闭！");

        CPromotion029AdventureNotes config = promotion029AdventureNotesSysCache.getOrThrow(idx);
        Promotion029AdventureNotes promotionInfo = promotion029AdventureNotesService.getPromotionInfo(playerContext.getId());

        Asserts.isTrue(config.getTargetStruct().getTarget() <= promotionInfo.getCountMap().getOrDefault(idx, 0),
                ErrorCode.ACHIEVEMENT_PROCESS_LOW.getValue(), String.format("进度值不够，领取失败！[%s]-[%s]", config.getTargetStruct().getTarget(),
                        promotionInfo.getCountMap().getOrDefault(idx, 0)));

        Asserts.isTrue(!promotionInfo.getRewardRecord().contains(idx), ErrorCode.PROMOTION_ID_HAD_REWARD.getValue(), String.format("该奖励已经领取！"));

        promotionInfo.getRewardRecord().add(idx);
        promotionInfo.setExp(promotionInfo.getExp() + config.getExp());
        promotion029AdventureNotesService.updatePromotion(promotionInfo);

        promotion029AdventureNotesService.updateToClient(playerContext.getId(),config,promotionInfo);
    }

    /***
     * 充值领取
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._13134)
    public void getRechargeReward(PlayerContext playerContext, Task4GMsg.GReqAdventureNoteRechargeGet msg) {
        int idx = msg.getIdx();
        Asserts.isTrue(promotionControlService.isPromotionRunning(getPromotionType()), ErrorCode.HERO_ARRIVE_END.getValue(), "活动已关闭！");

        CPromotion029AdventureNotesRechargeReward config = promotion029AdventureNotesRechargeRewardSysCache.getOrThrow(idx);
        Promotion029AdventureNotes promotionInfo = promotion029AdventureNotesService.getPromotionInfo(playerContext.getId());

        Asserts.isTrue(config.getRecharge_need() <= promotionInfo.getRecharge(),
                ErrorCode.ACHIEVEMENT_PROCESS_LOW.getValue(), String.format("充值金额不够，领取失败！[%s]-[%s]", config.getRecharge_need(), promotionInfo.getRecharge()));

        Asserts.isTrue(!promotionInfo.getRechargeRewardRecord().contains(idx), ErrorCode.PROMOTION_ID_HAD_REWARD.getValue(), String.format("该奖励已经领取！"));

        promotionInfo.getRechargeRewardRecord().add(idx);
        promotion029AdventureNotesService.updatePromotion(promotionInfo);
        thingService.add(playerContext.getId(), config.getReward(), GameEvent.ADVENTURE_NOTES);

        Task4GMsg.GResAdventureNoteRechargeGet.Builder builder = Task4GMsg.GResAdventureNoteRechargeGet.newBuilder();
        builder.setIdx(config.getIdx());
        playerContext.write(CmdCode._13134, builder.build());
    }

    /***
     * 等级领取
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._13135)
    public void getLevelReward(PlayerContext playerContext, Task4GMsg.GReqAdventureNoteAdvGet msg) {
        int idx = msg.getIdx();
        Asserts.isTrue(promotionControlService.isPromotionRunning(getPromotionType()), ErrorCode.HERO_ARRIVE_END.getValue(), "活动已关闭！");

        CPromotion029AdventureNotesLevelReward config = promotion029AdventureNotesLevelRewardSysCache.getOrThrow(idx);
        Promotion029AdventureNotes promotionInfo = promotion029AdventureNotesService.getPromotionInfo(playerContext.getId());

        Asserts.isTrue(config.getExp_need() <= promotionInfo.getExp(), ErrorCode.ACHIEVEMENT_PROCESS_LOW.getValue(),
                String.format("经验值不够，领取失败！[%s]-[%s]", config.getExp_need(), promotionInfo.getExp()));

        Asserts.isTrue(!promotionInfo.getLevelRewardRecord().contains(idx), ErrorCode.PROMOTION_ID_HAD_REWARD.getValue(), String.format("该奖励已经领取！"));

        promotionInfo.getLevelRewardRecord().add(idx);
        promotion029AdventureNotesService.updatePromotion(promotionInfo);
        thingService.add(playerContext.getId(), config.getReward(), GameEvent.ADVENTURE_NOTES);

        Task4GMsg.GResAdventureNoteRechargeGet.Builder builder = Task4GMsg.GResAdventureNoteRechargeGet.newBuilder();
        builder.setIdx(config.getLevel());
        playerContext.write(CmdCode._13135, builder.build());
    }
}
