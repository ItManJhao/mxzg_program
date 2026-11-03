package com.ayjs.mxzg.gameserver.module.promotionNew.promotion086.service;

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
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion086.dao.Promotion086Dao;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion086.domain.Promotion086;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.BasePromotionService;
import com.ayjs.mxzg.gameserver.module.recharge.constant.BuyGemType;
import com.ayjs.mxzg.gameserver.module.recharge.service.IRechargeBuyingService;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion086GiftConfig;
import com.ayjs.mxzg.protocol.ObjectGMsg;
import com.ayjs.mxzg.protocol.Promotion086GMsg;
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
public class Promotion086Service extends BasePromotionService<Promotion086> implements IRechargeBuyingService {
    @Autowired
    private ThingService thingService;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private Promotion086Dao promotion086Dao;

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.CHRISTMAS_GIFT;
    }

    @Override
    public IRepository<Promotion086> getRepository() {
        return promotion086Dao;
    }

    @Override
    protected void resetOnNewTurns(Promotion086 promotion, PromotionControl control) {
        promotion.getBuyList().clear();
    }

    @Override
    public BuyGemType buyGemType() {
        return BuyGemType.CHRISTMAS_GIFT;
    }

    @Override
    public boolean canBuy(long rid, int productId) {
        if (!promotionControlService.isPromotionRunning(thisPromotionType())) {
            log.error("活动未开始。。。");
            return false;
        }
        Promotion086GiftConfig config = getConfig(productId);
        Promotion086 promotion086 = getPromotionInfo(rid);
        Integer hadBuyCount = promotion086.getBuyList().getOrDefault(config.getIdx(), 0);
        if (hadBuyCount < config.getBuy_limit()) {
            log.error("{}购买次数上限{}-{}", productId, hadBuyCount, config.getBuy_limit());
        }
        return hadBuyCount < config.getBuy_limit();
    }

    public Collection<Promotion086GiftConfig> getConfigList() {
        PromotionControl promotionControl = promotionControlService.getControl(thisPromotionType());
        return promotionControl.getAllConfig(Promotion086GiftConfig.class);
    }

    /**
     * 根据商品id获取配置
     *
     * @param productId
     * @return
     */
    private Promotion086GiftConfig getConfig(int productId) {
        Promotion086GiftConfig promotion086GiftConfig = null;
        for (Promotion086GiftConfig config : getConfigList()) {
            if (config.getProduct_id() == productId) {
                promotion086GiftConfig = config;
                break;
            }
        }
        Asserts.notNull(promotion086GiftConfig, ErrorCode.CONFIG_NOT_EXISTS.getValue(), String.format("万圣礼包活动不存在商品id:{%s}的配置", productId));
        return promotion086GiftConfig;
    }

    @Override
    public void buyGoodsSuccess(long rid, CBuyGem cBuyGem, boolean isGm) {
        Promotion086GiftConfig config = getConfig(cBuyGem.getIdx());

        Promotion086 promotion086 = getPromotionInfo(rid);
        promotion086.getBuyList().put(config.getIdx(), promotion086.getBuyList().getOrDefault(config.getIdx(), 0) + 1);

        updatePromotion(promotion086);

        thingService.add(rid, ImmutableThingUtil.fromJson(config.getReward()), GameEvent.PROMOTION_086_GIFT_REWARD);
        //购买推送数据
        Promotion086GMsg.GResChristmasGiftBuy.Builder builder = Promotion086GMsg.GResChristmasGiftBuy.newBuilder();
        ObjectGMsg.PSMapData.Builder data = ObjectGMsg.PSMapData.newBuilder();
        data.setKey(config.getIdx());
        data.setValue(promotion086.getBuyList().getOrDefault(config.getIdx(), 0));
        builder.setBuy(data);
        contextManager.write(rid, CmdCode._76102, builder.build());
    }
}
