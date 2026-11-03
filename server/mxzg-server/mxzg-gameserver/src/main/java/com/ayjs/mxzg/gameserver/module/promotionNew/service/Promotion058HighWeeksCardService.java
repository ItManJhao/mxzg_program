package com.ayjs.mxzg.gameserver.module.promotionNew.service;

import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.config.excel.entity.CBuyGem;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.Promotion058HighWeeksCardDao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion058HighWeeksCard;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.recharge.constant.BuyGemType;
import com.ayjs.mxzg.gameserver.module.recharge.service.IRechargeBuyingService;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion056FashionBuyConfig;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion058HighWeeksCardConfig;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Collection;
import java.util.List;

/**
 * 高级周卡
 *
 * @author hyx
 */
@Service
public class Promotion058HighWeeksCardService extends BasePromotionService<Promotion058HighWeeksCard> implements IRechargeBuyingService {

    @Autowired
    private Promotion058HighWeeksCardDao promotion058HighWeeksCardDao;
    @Autowired
    private ThingService thingService;


    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.GAO_JI_ZHOU_KA;
    }

    @Override
    public IRepository<Promotion058HighWeeksCard> getRepository() {
        return promotion058HighWeeksCardDao;
    }

    @Override
    protected void resetOnNewTurns(Promotion058HighWeeksCard promotion, PromotionControl control) {
        promotion.getBuyList().clear();
    }

    @Override
    public BuyGemType buyGemType() {
        return BuyGemType.HIGH_WEEK_CARD;
    }

    @Override
    public boolean canBuy(long rid, int productId) {
        if (!promotionControlService.isPromotionRunning(thisPromotionType())) {
            return false;
        }

        Promotion058HighWeeksCardConfig config = getConfig(productId);
        Promotion058HighWeeksCard promotion058HighWeeksCard = getPromotionInfo(rid);

        return promotion058HighWeeksCard.getBuyList().getOrDefault(config.getIdx(), 0) < config.getBuy_limit();
    }

    public Collection<Promotion058HighWeeksCardConfig> getConfigList() {
        PromotionControl promotionControl = promotionControlService.getControl(thisPromotionType());
        return promotionControl.getAllConfig(Promotion058HighWeeksCardConfig.class);
    }

    /**
     * 根据商品id获取配置
     *
     * @param productId
     * @return
     */
    private Promotion058HighWeeksCardConfig getConfig(int productId) {
        Promotion058HighWeeksCardConfig promotion058HighWeeksCardConfig = null;
        for (Promotion058HighWeeksCardConfig config : getConfigList()) {
            if (config.getProduct_id() == productId) {
                promotion058HighWeeksCardConfig = config;
                break;
            }
        }
        Asserts.notNull(promotion058HighWeeksCardConfig, ErrorCode.CONFIG_NOT_EXISTS.getValue(), String.format("高级周卡活动不存在商品id:{%s}的配置", productId));
        return promotion058HighWeeksCardConfig;
    }

    @Override
    public void buyGoodsSuccess(long rid, CBuyGem cBuyGem, boolean isGm) {

        Promotion058HighWeeksCardConfig config = getConfig(cBuyGem.getIdx());

        Promotion058HighWeeksCard promotion058HighWeeksCard = getPromotionInfo(rid);
        promotion058HighWeeksCard.getBuyList().put(config.getIdx(), promotion058HighWeeksCard.getBuyList().getOrDefault(config.getIdx(), 0) + 1);

        updatePromotion(promotion058HighWeeksCard);

        thingService.add(rid, ImmutableThingUtil.fromJson(config.getReward()), GameEvent.PROMOTION_HIGH_WEEKS_CARD);

    }


}
