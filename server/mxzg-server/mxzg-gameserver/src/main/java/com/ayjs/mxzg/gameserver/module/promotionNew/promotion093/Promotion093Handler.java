package com.ayjs.mxzg.gameserver.module.promotionNew.promotion093;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.DropUtil;
import com.ayjs.mxzg.config.excel.cache.promotion093.Promotion093Const;
import com.ayjs.mxzg.config.excel.cache.promotion093.Promotion093DiceGroupSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion093.Promotion093DicePointSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion093.Promotion093GridSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion093.Promotion093ScenicSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion093.CPromotion093DiceGroup;
import com.ayjs.mxzg.config.excel.entity.promotion093.CPromotion093DicePoint;
import com.ayjs.mxzg.config.excel.entity.promotion093.CPromotion093Grid;
import com.ayjs.mxzg.config.excel.entity.promotion093.CPromotion093Scenic;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion093.domain.Promotion093;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion093.service.Promotion093Service;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion093RandomRewardConfig;
import com.ayjs.mxzg.protocol.Promotion093GMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 女神献花
 */
@Controller
@Slf4j
public class Promotion093Handler extends ProtocolHandler {
    @Autowired
    private Promotion093Service promotion093Service;
    @Autowired
    private ThingService thingService;
    @Autowired
    private Promotion093DiceGroupSysCache promotion093DiceGroupSysCache;
    @Autowired
    private Promotion093DicePointSysCache promotion093DicePointSysCache;
    @Autowired
    private Promotion093GridSysCache promotion093GridSysCache;
    @Autowired
    private PromotionControlService promotionControlService;
    @Autowired
    private Promotion093ScenicSysCache promotion093ScenicSysCache;
    @Autowired
    private Promotion093Const promotion093Const;


    @CMD(id = CmdCode._76251)
    public void getData(PlayerContext playerContext, Promotion093GMsg.GReqSpringOutingGrid req) {
        Promotion093 promotion = promotion093Service.getPromotionInfo(playerContext.getId());
        Promotion093GMsg.GResSpringOutingGrid.Builder builder = Promotion093GMsg.GResSpringOutingGrid.newBuilder();
        builder.setCurrIdx(promotion.getCurrIdx());
        builder.addAllScenicRecord(promotion.getScenicReward());
        promotion.getScenicCount().forEach((type, count) -> builder.addScenicCount(PbUtil.builderMap(type, count)));
        playerContext.write(CmdCode._76251, builder.build());

    }

    @CMD(id = CmdCode._76252)
    public void dice(PlayerContext playerContext, Promotion093GMsg.GReqSpringOutingGridDice req) {
        Asserts.isTrue(promotion093Service.isOpen(),
                ErrorCode.PROMOTION_NOT_RUNNING.getValue(), "活动未开启");
        Promotion093 promotion = promotion093Service.getPromotionInfo(playerContext.getId());

        thingService.cost(playerContext.getId(), promotion093Const.getDiceCost(), GameEvent.PROMOTION_093_DICE);
        //起点时，随机一个骰子组
        if (promotion.getCurrIdx() == promotion093GridSysCache.getStart()) {
            CPromotion093DiceGroup groupConfig = DropUtil.randomDrop(promotion093DiceGroupSysCache.getAll());
            promotion.setDiceGroup(groupConfig.getGroup());
            promotion.setDiceCount(0);
        }
        int diceCount = promotion.getDiceCount() + 1;
        CPromotion093DicePoint pointConfig = promotion093DicePointSysCache.getBy(promotion.getDiceGroup(), diceCount);

        Asserts.isTrue(pointConfig != null, ErrorCode.CONFIG_NOT_EXIST.getValue(),
                String.format("组{%s}，次数{%s}不存在", promotion.getDiceGroup(), diceCount));

        int nextIdx = pointConfig.getDice_point() + promotion.getCurrIdx();
        List<CPromotion093Grid> configs = promotion093GridSysCache.getAll().stream().filter(configTemp -> configTemp.getIdx() > promotion.getCurrIdx() &&
                configTemp.getIdx() <= nextIdx).collect(Collectors.toList());

        promotion.setCurrIdx(nextIdx >= promotion093GridSysCache.getMax() ? promotion093GridSysCache.getStart() : nextIdx);
        promotion.setDiceCount(diceCount);
        promotion093Service.updatePromotion(promotion);

        Map<Integer, List<CPromotion093Grid>> eventMap = configs.stream().collect(Collectors.groupingBy(CPromotion093Grid::getEvent_type));

        //累计景点
        configs = eventMap.get(1);
        if (configs != null) {
            for (CPromotion093Grid config : configs) {
                promotion.addCount(config.getEvent_param(), 1);
            }
            promotion093Service.updatePromotion(promotion);
        }

        List<ImmutableThing> rewards = new ArrayList<>();
        //奖励
        configs = eventMap.get(2);
        if (configs != null) {
            PromotionControl control = promotionControlService.getControl(PromotionType.CHUN_RI_TA_QING);
            Collection<Promotion093RandomRewardConfig> rewardConfigs = control.getAllConfig(Promotion093RandomRewardConfig.class);
            for (CPromotion093Grid config : configs) {
                List<Promotion093RandomRewardConfig> list = rewardConfigs.stream().filter(
                        configTemp -> configTemp.getType() == config.getEvent_param()).collect(Collectors.toList());
                if (list == null || list.isEmpty()) {
                    log.error("不存在奖励组" + config.getEvent_param());
                } else {
                    rewards.addAll(DropUtil.randomDrop(list).getRewardThing());
                }
            }
        }
        if (!rewards.isEmpty()) {
            rewards = ImmutableThingUtil.mergeThing(rewards);
            thingService.add(playerContext.getId(), rewards, GameEvent.PROMOTION_093_DICE, NoticeType.SLIENT);
        }
        Promotion093GMsg.GResSpringOutingGridDice.Builder builder = Promotion093GMsg.GResSpringOutingGridDice.newBuilder();
        builder.setCurrIdx(promotion.getCurrIdx());
        builder.setPoint(pointConfig.getDice_point());
        if (!rewards.isEmpty()) {
            builder.addAllReward(PbUtil.buildReward(rewards));
        }
        promotion.getScenicCount().forEach((type, count) -> builder.addScenicCount(PbUtil.builderMap(type, count)));
        playerContext.write(CmdCode._76252, builder.build());

    }

    @CMD(id = CmdCode._76253)
    public void scenicReward(PlayerContext playerContext, Promotion093GMsg.GReqSpringOutingGridScenicReward req) {
        Promotion093 promotion = promotion093Service.getPromotionInfo(playerContext.getId());

        CPromotion093Scenic config = promotion093ScenicSysCache.getById(req.getIdx());
        Integer count = promotion.getScenicCount().getOrDefault(config.getType(), 0);
        Asserts.isTrue(count >= config.getCount(),
                ErrorCode.PROMOTION_093_COUNT_LOW.getValue(), String.format("配置{%s}，次数{%s}不足", req.getIdx(), count));

        Asserts.isTrue(!promotion.getScenicReward().contains(config.getIdx()),
                ErrorCode.PROMOTION_093_HAD_REWARD.getValue(), String.format("配置{%s}已经领取", count, req.getIdx()));

        promotion.getScenicReward().add(config.getIdx());
        promotion093Service.updatePromotion(promotion);

        thingService.add(playerContext.getId(), config.getReward(), GameEvent.PROMOTION_093_SCENIC);

        Promotion093GMsg.GResSpringOutingGridScenicReward.Builder builder = Promotion093GMsg.GResSpringOutingGridScenicReward.newBuilder();
        builder.addAllScenicRecord(promotion.getScenicReward());
        playerContext.write(CmdCode._76253, builder.build());
    }


}
