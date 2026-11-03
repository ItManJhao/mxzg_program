package com.ayjs.mxzg.gameserver.module.promotionNew.promotion095.service;

import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.config.excel.entity.CBuyGem;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion095.dao.Promotion095Dao;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion095.domain.Promotion095;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.BasePromotionService;
import com.ayjs.mxzg.gameserver.module.recharge.constant.BuyGemType;
import com.ayjs.mxzg.gameserver.module.recharge.service.IRechargeBuyingService;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion095GiftConfig;
import com.ayjs.mxzg.protocol.ObjectGMsg;
import com.ayjs.mxzg.protocol.Promotion095GMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Collection;

/**
 * @Author: CWJ
 * @Date: 2020/10/21
 **/
@Service
@Slf4j
public class Promotion095Service extends BasePromotionService<Promotion095> implements IRechargeBuyingService {
    @Autowired
    private ThingService thingService;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private Promotion095Dao promotion095Dao;

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.CHUN_YOU_JI;
    }

    @Override
    public IRepository<Promotion095> getRepository() {
        return promotion095Dao;
    }

    @Override
    protected void resetOnNewTurns(Promotion095 promotion, PromotionControl control) {
        promotion.getBuyList().clear();
    }

    @Override
    public BuyGemType buyGemType() {
        return BuyGemType.PROMOTION_095;
    }

    @Override
    public boolean canBuy(long rid, int productId) {
        if (!promotionControlService.isPromotionRunning(thisPromotionType())) {
            log.error("活动未开始。。。");
            return false;
        }
        Promotion095GiftConfig config = getConfig(productId);
        Promotion095 promotion095 = getPromotionInfo(rid);
        Integer hadBuyCount = promotion095.getBuyList().getOrDefault(config.getIdx(), 0);
        if (hadBuyCount < config.getBuy_limit()) {
            log.error("{}购买次数上限{}-{}", productId, hadBuyCount, config.getBuy_limit());
        }
        return hadBuyCount < config.getBuy_limit();
    }

    public Collection<Promotion095GiftConfig> getConfigList() {
        PromotionControl promotionControl = promotionControlService.getControl(thisPromotionType());
        return promotionControl.getAllConfig(Promotion095GiftConfig.class);
    }

    /**
     * 根据商品id获取配置
     *
     * @param productId
     * @return
     */
    private Promotion095GiftConfig getConfig(int productId) {
        Promotion095GiftConfig promotion095GiftConfig = null;
        for (Promotion095GiftConfig config : getConfigList()) {
            if (config.getProduct_id() == productId) {
                promotion095GiftConfig = config;
                break;
            }
        }
        Asserts.notNull(promotion095GiftConfig, ErrorCode.CONFIG_NOT_EXISTS.getValue(), String.format("万圣礼包活动不存在商品id:{%s}的配置", productId));
        return promotion095GiftConfig;
    }

    @Override
    public void buyGoodsSuccess(long rid, CBuyGem cBuyGem, boolean isGm) {
        Promotion095GiftConfig config = getConfig(cBuyGem.getIdx());

        Promotion095 promotion095 = getPromotionInfo(rid);
        promotion095.getBuyList().put(config.getIdx(), promotion095.getBuyList().getOrDefault(config.getIdx(), 0) + 1);

        updatePromotion(promotion095);

        thingService.add(rid, ImmutableThingUtil.fromJson(config.getReward()), GameEvent.PROMOTION_095_GIFT_REWARD);
        //购买推送数据
        Promotion095GMsg.GResSpringOutingGiftBuy.Builder builder = Promotion095GMsg.GResSpringOutingGiftBuy.newBuilder();
        ObjectGMsg.PSMapData.Builder data = ObjectGMsg.PSMapData.newBuilder();
        data.setKey(config.getIdx());
        data.setValue(promotion095.getBuyList().getOrDefault(config.getIdx(), 0));
        builder.setBuy(data);
        contextManager.write(rid, CmdCode._76282, builder.build());
    }
}
