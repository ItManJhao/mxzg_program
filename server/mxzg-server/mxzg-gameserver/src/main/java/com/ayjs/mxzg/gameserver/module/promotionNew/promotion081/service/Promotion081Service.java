package com.ayjs.mxzg.gameserver.module.promotionNew.promotion081.service;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.config.excel.cache.promotion081.Promotion081MissionSysCache;
import com.ayjs.mxzg.config.excel.entity.CBuyGem;
import com.ayjs.mxzg.config.excel.entity.promotion081.CPromotion081Mission;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.config.struct.TargetStruct;
import com.ayjs.mxzg.config.struct.TargetType;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion081.converter.Promotion081PB;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion081.dao.Promotion081Dao;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion081.domain.Promotion081;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.BasePromotionService;
import com.ayjs.mxzg.gameserver.module.recharge.constant.BuyGemType;
import com.ayjs.mxzg.gameserver.module.recharge.service.IRechargeBuyingService;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion081GiftConfig;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Collection;
import java.util.List;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2020/9/22
 **/
@Slf4j
@Service
public class Promotion081Service extends BasePromotionService<Promotion081> implements IRechargeBuyingService {

    @Autowired
    private Promotion081Dao promotion081Dao;
    @Autowired
    private Promotion081MissionSysCache promotion081MissionSysCache;
    @Autowired
    private Promotion081PB promotion081PB;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private ThingService thingService;

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.HEI_WU_MISSION;
    }

    @Override
    public IRepository<Promotion081> getRepository() {
        return promotion081Dao;
    }

    @Override
    protected void resetOnNewTurns(Promotion081 promotion, PromotionControl control) {
        promotion.getMissionInfoMap().clear();
        promotion.getMissionBoxRecord().clear();
        promotion.getMissionBoxRecord().clear();
        promotion.setMissionRewardCount(0);
        promotion.getBuyRecord().clear();
    }

    public boolean isOpening() {
        return promotionControlService.isPromotionRunning(thisPromotionType());
    }


    public List<CPromotion081Mission> getMissionConfigByTarget(TargetStruct targetStruct) {
        List<CPromotion081Mission> missions = promotion081MissionSysCache.getAll();
        if (CollectionUtil.isEmpty(missions)) {
            return null;
        }

        List<CPromotion081Mission> configList = missions.stream().filter(config -> TargetType.checkTrigger(config.getTarget(),
                targetStruct)).collect(Collectors.toList());

        return configList;
    }

    @Override
    public BuyGemType buyGemType() {
        return BuyGemType.BLACK_FIVE_MISSION_GIFT;
    }

    @Override
    public boolean canBuy(long rid, int productId) {
        PromotionControl control = promotionControlService.getControl(thisPromotionType());

        if (!isOpening()) {
            return false;
        }

        Promotion081 promotionInfo = getPromotionInfo(rid);
        Collection<Promotion081GiftConfig> allConfig = control.getAllConfig(Promotion081GiftConfig.class);
        Promotion081GiftConfig giftConfig = allConfig.stream().filter(config -> config.getProduct_id() == productId
                || config.getDiscount_product_id() == productId).findFirst().orElse(null);
        if (giftConfig == null) {
            log.info("{}商品id对应的配置不存在", productId);
            return false;
        }

        //完成数量达到限制后，只能以低价购买
        if (giftConfig.getNeed_count() > promotionInfo.getMissionRewardCount()) {
            if (giftConfig.getProduct_id() != productId) {
                return false;
            }
        } else {
            if (giftConfig.getDiscount_product_id() != productId) {
                return false;
            }
        }

        if (promotionInfo.getBuyRecord().getOrDefault(giftConfig.getId(), 0) >= giftConfig.getBuy_limit()) {
            log.info("{}购买上限{},{}", productId, promotionInfo.getBuyRecord().getOrDefault(giftConfig.getId(), 0), giftConfig.getBuy_limit());
            return false;
        }

        return true;
    }

    @Override
    public void buyGoodsSuccess(long rid, CBuyGem cBuyGem, boolean isGm) {
        Promotion081 promotionInfo = getPromotionInfo(rid);
        PromotionControl control = promotionControlService.getControl(thisPromotionType());
        Collection<Promotion081GiftConfig> allConfig = control.getAllConfig(Promotion081GiftConfig.class);
        int productId = cBuyGem.getIdx();
        Promotion081GiftConfig giftConfig = allConfig.stream().filter(config -> config.getProduct_id() == productId
                || config.getDiscount_product_id() == productId).findFirst().orElse(null);

        if (giftConfig == null) {
            log.error("该礼包不存在对应的配置{}", productId);
            return;
        }

        promotionInfo.getBuyRecord().put(giftConfig.getId(), promotionInfo.getBuyRecord().getOrDefault(giftConfig.getId(), 0) + 1);
        updatePromotion(promotionInfo);

        thingService.add(rid, ImmutableThingUtil.fromJson(giftConfig.getReward()), GameEvent.PROMOTION_081_MISSION_GIFT_REWARD);

        contextManager.write(rid, CmdCode._76005, promotion081PB.buildMissionGiftBuy(rid, giftConfig.getId()));
    }
}
