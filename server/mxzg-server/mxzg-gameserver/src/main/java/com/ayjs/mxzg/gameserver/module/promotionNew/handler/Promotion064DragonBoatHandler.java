package com.ayjs.mxzg.gameserver.module.promotionNew.handler;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.DropUtil;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion064DragonBoatBoxRewardSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion064DragonBoatCardSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion064DragonBoatTaskSysCache;
import com.ayjs.mxzg.config.excel.constant.DragonBoatConst;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion064DragonBoatBoxReward;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion064DragonBoatCard;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion064DragonBoatTask;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion064DragonBoat;
import com.ayjs.mxzg.gameserver.module.promotionNew.event.DragonBoatEvent;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion064DragonBoatService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.protocol.ObjectGMsg;
import com.ayjs.mxzg.protocol.Promotion064GMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.List;
import java.util.stream.Collectors;

/**
 * 龙舟活动
 *
 * @author hyx
 */
@Controller
public class Promotion064DragonBoatHandler extends ProtocolHandler {

    @Autowired
    private Promotion064DragonBoatService promotion064DragonBoatService;
    @Autowired
    private PromotionControlService promotionControlService;
    @Autowired
    private Promotion064DragonBoatTaskSysCache promotion064DragonBoatTaskSysCache;
    @Autowired
    private Promotion064DragonBoatBoxRewardSysCache promotion064DragonBoatBoxRewardSysCache;
    @Autowired
    private Promotion064DragonBoatCardSysCache promotion064DragonBoatCardSysCache;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private ThingService thingService;

    /**
     * 龙舟任务数据
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._13250)
    public void dragonBoatTaskInfo(PlayerContext playerContext, Promotion064GMsg.GReqDragonBoatTaskInfo msg) {

        Promotion064DragonBoat promotion064DragonBoat = promotion064DragonBoatService.getPromotionInfo(playerContext.getId());

        //龙舟任务数据
        Promotion064GMsg.GResDragonBoatTaskInfo.Builder builder = Promotion064GMsg.GResDragonBoatTaskInfo.newBuilder();
        builder.setDayTurns(promotion064DragonBoatService.getPromotionDay());
        promotion064DragonBoat.getTaskList().forEach((key, value) -> {
            ObjectGMsg.PSTaskProgress.Builder data = promotion064DragonBoatService.builderTask(key, value);
            builder.addTaskList(data);
        });
        builder.addAllRewardIds(promotion064DragonBoat.getTaskRewards());
        builder.addAllBoxRewards(promotion064DragonBoat.getBoxRewards());

        //龙舟翻牌界面数据
        builder.setGridTurns(promotion064DragonBoat.getCardTurns());
        builder.setUltimateId(promotion064DragonBoat.getTargetIdx());
        promotion064DragonBoat.getGrids().forEach((k, v) -> {
            Promotion064GMsg.PSGridInfo.Builder data = Promotion064GMsg.PSGridInfo.newBuilder();
            data.setGridIdx(k);
            data.setRewardIdx(v);
            builder.addGrids(data);
        });

        //龙舟商品数据
        promotion064DragonBoatService.getProductConfig().forEach(config -> {
            ObjectGMsg.PSMapData.Builder data = ObjectGMsg.PSMapData.newBuilder();
            data.setKey(config.getIdx());
            data.setValue(promotion064DragonBoat.getBuyList().getOrDefault(config.getIdx(), 0));
            builder.addBuy(data);
        });

        playerContext.write(CmdCode._13250, builder.build());
    }

    /**
     * 请求龙舟活动翻牌数据
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._13251)
    public void dragonBoatCards(PlayerContext playerContext, Promotion064GMsg.GReqDragonBoatCards msg) {

        Promotion064GMsg.GResDragonBoatCards.Builder builder = Promotion064GMsg.GResDragonBoatCards.newBuilder();

        Promotion064DragonBoat promotion064DragonBoat = promotion064DragonBoatService.getPromotionInfo(playerContext.getId());
        builder.setGridTurns(promotion064DragonBoat.getCardTurns());
        builder.setUltimateId(promotion064DragonBoat.getTargetIdx());
        promotion064DragonBoat.getGrids().forEach((k, v) -> {
            Promotion064GMsg.PSGridInfo.Builder data = Promotion064GMsg.PSGridInfo.newBuilder();
            data.setGridIdx(k);
            data.setRewardIdx(v);
            builder.addGrids(data);
        });
        playerContext.write(CmdCode._13251, builder.build());

    }

    /**
     * 领取龙舟任务奖励
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._13253)
    public void dragonBoatTaskReward(PlayerContext playerContext, Promotion064GMsg.GReqGetTaskReward msg) {
        Asserts.isTrue(promotionControlService.isPromotionRunning(PromotionType.LONG_ZHOU_HOU_DONG),
                ErrorCode.PROMOTION_NOT_RUNNING.getValue(), "活动已结束");

        Promotion064DragonBoat promotion064DragonBoat = promotion064DragonBoatService.getPromotionInfo(playerContext.getId());
        Asserts.isTrue(!promotion064DragonBoat.getTaskRewards().contains(msg.getIdx()),
                ErrorCode.DRAGON_BOAT_TASK_REWARD.getValue(), "任务奖励已领取");

        CPromotion064DragonBoatTask taskConfig = promotion064DragonBoatTaskSysCache.getOrThrow(msg.getIdx());
        Asserts.isTrue(taskConfig.getTask_target().getTarget() <= promotion064DragonBoat.getTaskList().getOrDefault(msg.getIdx(), 0L),
                ErrorCode.DRAGON_BOAT_TASK_PROGRESS.getValue(), "任务进度不足");

        promotion064DragonBoat.getTaskRewards().add(msg.getIdx());
        promotion064DragonBoatService.updatePromotion(promotion064DragonBoat);

        thingService.add(playerContext.getId(), taskConfig.getTask_reward(), GameEvent.PROMOTION_DRAGON_BOAT_TASK_REWARD);

        Promotion064GMsg.GResGetTaskReward.Builder builder = Promotion064GMsg.GResGetTaskReward.newBuilder();
        builder.addAllRewardIds(promotion064DragonBoat.getTaskRewards());
        playerContext.write(CmdCode._13253, builder.build());

    }

    /**
     * 领取龙舟宝箱奖励
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._13254)
    public void dragonBoatBoxReward(PlayerContext playerContext, Promotion064GMsg.GReqGetBoxReward msg) {
        Asserts.isTrue(promotionControlService.isPromotionRunning(PromotionType.LONG_ZHOU_HOU_DONG),
                ErrorCode.PROMOTION_NOT_RUNNING.getValue(), "活动已结束");

        Promotion064DragonBoat promotion064DragonBoat = promotion064DragonBoatService.getPromotionInfo(playerContext.getId());
        Asserts.isTrue(!promotion064DragonBoat.getBoxRewards().contains(msg.getIdx()),
                ErrorCode.DRAGON_BOAT_BOX_REWARD.getValue(), "龙舟宝箱奖励已领取");

        CPromotion064DragonBoatBoxReward boxConfig = promotion064DragonBoatBoxRewardSysCache.getOrThrow(msg.getIdx());
        Asserts.isTrue(boxConfig.getTask_count() <= promotion064DragonBoat.getTaskRewards().size(),
                ErrorCode.DRAGON_BOAT_BOX_TASK_COUNT.getValue(), "龙舟宝箱进度不足");

        promotion064DragonBoat.getBoxRewards().add(msg.getIdx());
        promotion064DragonBoatService.updatePromotion(promotion064DragonBoat);

        thingService.add(playerContext.getId(), boxConfig.getBox_reward(), GameEvent.PROMOTION_DRAGON_BOAT_BOX_REWARD);

        Promotion064GMsg.GResGetBoxReward.Builder builder = Promotion064GMsg.GResGetBoxReward.newBuilder();
        builder.addAllBoxRewards(promotion064DragonBoat.getBoxRewards());
        playerContext.write(CmdCode._13254, builder.build());
    }

    /**
     * 选择龙舟目标奖励
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._13255)
    public void chooseUltimateReward(PlayerContext playerContext, Promotion064GMsg.GReqChooseUltimateReward msg) {
        Asserts.isTrue(promotionControlService.isPromotionRunning(PromotionType.LONG_ZHOU_HOU_DONG),
                ErrorCode.PROMOTION_NOT_RUNNING.getValue(), "活动已结束");

        CPromotion064DragonBoatCard cPromotion064DragonBoatCard = promotion064DragonBoatCardSysCache.getOrThrow(msg.getIdx());
        Asserts.isTrue(cPromotion064DragonBoatCard.getType() == 1,
                ErrorCode.DRAGON_BOAT_TARGET_REWARD_TYPE.getValue(), "当前替换的奖励非目标奖励池内容");

        Promotion064DragonBoat promotion064DragonBoat = promotion064DragonBoatService.getPromotionInfo(playerContext.getId());
        Asserts.isTrue(cPromotion064DragonBoatCard.getTurns() == promotion064DragonBoat.getCardTurns(),
                ErrorCode.DRAGON_BOAT_NOT_CARD_TURNS.getValue(), "牌组不可选择非本轮次的目标奖励");
        Asserts.isTrue(promotion064DragonBoat.getTargetStatus() == 0,
                ErrorCode.DRAGON_BOAT_TARGET_REWARD.getValue(), "目标奖励已被领走，不可再次选择");

        promotion064DragonBoat.setTargetIdx(msg.getIdx());
        promotion064DragonBoatService.updatePromotion(promotion064DragonBoat);

        Promotion064GMsg.GResChooseUltimateReward.Builder builder = Promotion064GMsg.GResChooseUltimateReward.newBuilder();
        builder.setIdx(msg.getIdx());
        playerContext.write(CmdCode._13255, builder.build());
    }

    /**
     * 翻牌
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._13256)
    public void turnOverCard(PlayerContext playerContext, Promotion064GMsg.GReqTurnOverCard msg) {
        Asserts.isTrue(promotionControlService.isPromotionRunning(PromotionType.LONG_ZHOU_HOU_DONG),
                ErrorCode.PROMOTION_NOT_RUNNING.getValue(), "活动已结束");

        Promotion064DragonBoat promotion064DragonBoat = promotion064DragonBoatService.getPromotionInfo(playerContext.getId());
        Asserts.isTrue(promotion064DragonBoat.getTargetIdx() > 0,
                ErrorCode.DRAGON_BOAT_CARDS_NOT_CHOOSE_TARGET_REWARD.getValue(), "龙舟卡牌未选择目标大奖");
        Asserts.isTrue(promotion064DragonBoat.getNum() < DragonBoatConst.PROMOTION_DRAGON_BOAT_CARD_COUNT,
                ErrorCode.DRAGON_BOAT_CARDS_ALL_TURN_OVER.getValue(), "当前轮的所有卡牌已被抽取完");
        Asserts.isTrue(!promotion064DragonBoat.getGrids().containsKey(msg.getGridIdx()),
                ErrorCode.DRAGON_BOAT_CARDS_TURN_OVER.getValue(), "当前选中卡牌已被抽取");

        //奖池
        List<CPromotion064DragonBoatCard> cardList = this.getRewardPondList(promotion064DragonBoat);
        //目标奖励
        CPromotion064DragonBoatCard targetConfig = promotion064DragonBoatCardSysCache.getOrThrow(promotion064DragonBoat.getTargetIdx());
        if (promotion064DragonBoat.getNum() >= targetConfig.getShow_min() && promotion064DragonBoat.getTargetStatus() == 0) {
            //将目标奖励添加奖池
            cardList.add(targetConfig);
        }
        Asserts.isTrue(!cardList.isEmpty(), ErrorCode.DRAGON_BOAT_REWARD_POND_NOT_NULL.getValue(), "龙舟翻牌奖池不能为空");

        //扣除道具
        thingService.cost(playerContext.getId(), DragonBoatConst.PROMOTION_DRAGON_BOAT_COST, GameEvent.PROMOTION_DRAGON_LOTTERY_CARD);

        promotion064DragonBoat.setNum(promotion064DragonBoat.getNum() + 1);
        //抽取的奖励
        CPromotion064DragonBoatCard config = null;
        //当翻牌达到最大卡牌数且目标卡牌未翻出
        if (promotion064DragonBoat.getNum() == DragonBoatConst.PROMOTION_DRAGON_BOAT_CARD_COUNT && promotion064DragonBoat.getTargetStatus() == 0) {
            config = targetConfig;
        } else {
            config = DropUtil.randomDrop(cardList, CPromotion064DragonBoatCard::getDropId, CPromotion064DragonBoatCard::getRate);
        }
        Asserts.notNull(config, ErrorCode.DRAGON_BOAT_CARDS_NOT_EXISTS.getValue(), "未抽取到卡牌");

        //若翻到目标奖励
        if (config.getIdx() == promotion064DragonBoat.getTargetIdx()) {
            promotion064DragonBoat.setTargetStatus(1);
        }
        //写入当前卡牌奖励
        promotion064DragonBoat.getGrids().put(msg.getGridIdx(), config.getIdx());
        //增加当前奖励已出现次数
        promotion064DragonBoat.getCardNum().put(config.getIdx(), promotion064DragonBoat.getCardNum().getOrDefault(config.getIdx(), 0) + 1);

        promotion064DragonBoatService.updatePromotion(promotion064DragonBoat);

        if (config.getIdx() != promotion064DragonBoat.getTargetIdx()) {
            thingService.add(playerContext.getId(), config.getReward(), GameEvent.PROMOTION_DRAGON_LOTTERY_CARD);
        } else {
            //获得大奖不给前端弹窗
            thingService.add(playerContext.getId(), config.getReward(), GameEvent.PROMOTION_DRAGON_LOTTERY_CARD, NoticeType.SLIENT);
        }

        Promotion064GMsg.GResTurnOverCard.Builder builder = Promotion064GMsg.GResTurnOverCard.newBuilder();
        promotion064DragonBoat.getGrids().forEach((k, v) -> {
            Promotion064GMsg.PSGridInfo.Builder data = Promotion064GMsg.PSGridInfo.newBuilder();
            data.setGridIdx(k);
            data.setRewardIdx(v);
            builder.addGrids(data);
        });
        builder.setGridId(msg.getGridIdx());
        builder.setRewardIdx(config.getIdx());
        builder.setStatus(promotion064DragonBoat.getNum() == DragonBoatConst.PROMOTION_DRAGON_BOAT_CARD_COUNT ? 1 : 0);
        playerContext.write(CmdCode._13256, builder.build());
    }

    /**
     * 获取奖池
     *
     * @return
     */
    private List<CPromotion064DragonBoatCard> getRewardPondList(Promotion064DragonBoat promotion064DragonBoat) {
        List<CPromotion064DragonBoatCard> configList = promotion064DragonBoatCardSysCache.getTurnsList(promotion064DragonBoat.getCardTurns()).
                stream().filter(config -> config.getShow_num() > promotion064DragonBoat.getCardNum().getOrDefault(config.getIdx(), 0)).collect(Collectors.toList());
        return configList;
    }

}
