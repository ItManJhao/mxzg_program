package com.ayjs.mxzg.gameserver.module.promotionNew.promotion082.service;

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
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion082.dao.Promotion082Dao;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion082.domain.Promotion082;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.BasePromotionService;
import com.ayjs.mxzg.gameserver.module.recharge.constant.BuyGemType;
import com.ayjs.mxzg.gameserver.module.recharge.service.IRechargeBuyingService;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion082GiftConfig;
import com.ayjs.mxzg.protocol.ObjectGMsg;
import com.ayjs.mxzg.protocol.Promotion082GMsg;
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
public class Promotion082Service extends BasePromotionService<Promotion082> implements IRechargeBuyingService {
    @Autowired
    private ThingService thingService;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private Promotion082Dao promotion082Dao;

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.HEI_WU_GIFT;
    }

    @Override
    public IRepository<Promotion082> getRepository() {
        return promotion082Dao;
    }

    @Override
    protected void resetOnNewTurns(Promotion082 promotion, PromotionControl control) {
        promotion.getBuyList().clear();
    }

    @Override
    public BuyGemType buyGemType() {
        return BuyGemType.BLACK_FIVE_GIFT;
    }

    @Override
    public boolean canBuy(long rid, int productId) {
        if (!promotionControlService.isPromotionRunning(thisPromotionType())) {
            log.error("活动未开始。。。");
            return false;
        }
        Promotion082GiftConfig config = getConfig(productId);
        Promotion082 promotion082 = getPromotionInfo(rid);
        Integer hadBuyCount = promotion082.getBuyList().getOrDefault(config.getIdx(), 0);
        if (hadBuyCount < config.getBuy_limit()) {
            log.error("{}购买次数上限{}-{}", productId, hadBuyCount, config.getBuy_limit());
        }
        return hadBuyCount < config.getBuy_limit();
    }

    public Collection<Promotion082GiftConfig> getConfigList() {
        PromotionControl promotionControl = promotionControlService.getControl(thisPromotionType());
        return promotionControl.getAllConfig(Promotion082GiftConfig.class);
    }

    /**
     * 根据商品id获取配置
     *
     * @param productId
     * @return
     */
    private Promotion082GiftConfig getConfig(int productId) {
        Promotion082GiftConfig promotion082GiftConfig = null;
        for (Promotion082GiftConfig config : getConfigList()) {
            if (config.getProduct_id() == productId) {
                promotion082GiftConfig = config;
                break;
            }
        }
        Asserts.notNull(promotion082GiftConfig, ErrorCode.CONFIG_NOT_EXISTS.getValue(), String.format("万圣礼包活动不存在商品id:{%s}的配置", productId));
        return promotion082GiftConfig;
    }

    @Override
    public void buyGoodsSuccess(long rid, CBuyGem cBuyGem, boolean isGm) {
        Promotion082GiftConfig config = getConfig(cBuyGem.getIdx());

        Promotion082 promotion082 = getPromotionInfo(rid);
        promotion082.getBuyList().put(config.getIdx(), promotion082.getBuyList().getOrDefault(config.getIdx(), 0) + 1);

        updatePromotion(promotion082);

        thingService.add(rid, ImmutableThingUtil.fromJson(config.getReward()), GameEvent.PROMOTION_082_GIFT_REWARD);
        //购买推送数据
        Promotion082GMsg.GResBlackFiveGiftBuy.Builder builder = Promotion082GMsg.GResBlackFiveGiftBuy.newBuilder();
        ObjectGMsg.PSMapData.Builder data = ObjectGMsg.PSMapData.newBuilder();
        data.setKey(config.getIdx());
        data.setValue(promotion082.getBuyList().getOrDefault(config.getIdx(), 0));
        builder.setBuy(data);
        contextManager.write(rid, CmdCode._76022, builder.build());
    }
}
