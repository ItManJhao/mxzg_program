package com.ayjs.mxzg.gameserver.module.promotionNew.promotion079.service;

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
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion079.dao.Promotion079Dao;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion079.domain.Promotion079;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.BasePromotionService;
import com.ayjs.mxzg.gameserver.module.recharge.constant.BuyGemType;
import com.ayjs.mxzg.gameserver.module.recharge.service.IRechargeBuyingService;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion079GiftConfig;
import com.ayjs.mxzg.protocol.ObjectGMsg;
import com.ayjs.mxzg.protocol.Promotion079GMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Collection;

/**
 * @Author: CWJ
 * @Date: 2020/10/21
 **/
@Service
public class Promotion079Service extends BasePromotionService<Promotion079> implements IRechargeBuyingService {
    @Autowired
    private ThingService thingService;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private Promotion079Dao promotion079Dao;

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.WANG_SHENG_GIFT;
    }

    @Override
    public IRepository<Promotion079> getRepository() {
        return promotion079Dao;
    }

    @Override
    protected void resetOnNewTurns(Promotion079 promotion, PromotionControl control) {
        promotion.getBuyList().clear();
    }

    @Override
    public BuyGemType buyGemType() {
        return BuyGemType.HALLOWEEN_GIFT;
    }

    @Override
    public boolean canBuy(long rid, int productId) {
        if (!promotionControlService.isPromotionRunning(thisPromotionType())) {
            return false;
        }
        Promotion079GiftConfig config = getConfig(productId);
        Promotion079 promotion079 = getPromotionInfo(rid);
        return promotion079.getBuyList().getOrDefault(config.getIdx(), 0) < config.getBuy_limit();
    }

    public Collection<Promotion079GiftConfig> getConfigList() {
        PromotionControl promotionControl = promotionControlService.getControl(thisPromotionType());
        return promotionControl.getAllConfig(Promotion079GiftConfig.class);
    }

    /**
     * 根据商品id获取配置
     *
     * @param productId
     * @return
     */
    private Promotion079GiftConfig getConfig(int productId) {
        Promotion079GiftConfig promotion079GiftConfig = null;
        for (Promotion079GiftConfig config : getConfigList()) {
            if (config.getProduct_id() == productId) {
                promotion079GiftConfig = config;
                break;
            }
        }
        Asserts.notNull(promotion079GiftConfig, ErrorCode.CONFIG_NOT_EXISTS.getValue(), String.format("万圣礼包活动不存在商品id:{%s}的配置", productId));
        return promotion079GiftConfig;
    }

    @Override
    public void buyGoodsSuccess(long rid, CBuyGem cBuyGem, boolean isGm) {
        Promotion079GiftConfig config = getConfig(cBuyGem.getIdx());

        Promotion079 promotion079 = getPromotionInfo(rid);
        promotion079.getBuyList().put(config.getIdx(), promotion079.getBuyList().getOrDefault(config.getIdx(), 0) + 1);

        updatePromotion(promotion079);

        thingService.add(rid, ImmutableThingUtil.fromJson(config.getReward()), GameEvent.MID_FOOD);
        //购买推送数据
        Promotion079GMsg.GResHalloweenGiftBuy.Builder builder = Promotion079GMsg.GResHalloweenGiftBuy.newBuilder();
        ObjectGMsg.PSMapData.Builder data = ObjectGMsg.PSMapData.newBuilder();
        data.setKey(config.getIdx());
        data.setValue(promotion079.getBuyList().getOrDefault(config.getIdx(), 0));
        builder.setBuy(data);
        contextManager.write(rid, CmdCode._75932, builder.build());
    }
}
