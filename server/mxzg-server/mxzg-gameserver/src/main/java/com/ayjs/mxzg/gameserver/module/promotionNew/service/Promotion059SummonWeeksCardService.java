package com.ayjs.mxzg.gameserver.module.promotionNew.service;

import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.config.excel.entity.CBuyGem;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.Promotion059SummonWeeksCardDao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion059SummonWeeksCard;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.recharge.constant.BuyGemType;
import com.ayjs.mxzg.gameserver.module.recharge.service.IRechargeBuyingService;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion058HighWeeksCardConfig;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion059SummonWeeksCardConfig;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Collection;

/**
 * 召唤周卡
 *
 * @author hyx
 */
@Service
public class Promotion059SummonWeeksCardService extends BasePromotionService<Promotion059SummonWeeksCard> implements IRechargeBuyingService {

    @Autowired
    private Promotion059SummonWeeksCardDao promotion059SummonWeeksCardDao;
    @Autowired
    private ThingService thingService;

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.ZHAO_HUAN_ZHOU_KA;
    }

    @Override
    public IRepository<Promotion059SummonWeeksCard> getRepository() {
        return promotion059SummonWeeksCardDao;
    }

    @Override
    protected void resetOnNewTurns(Promotion059SummonWeeksCard promotion, PromotionControl control) {
        promotion.getBuyList().clear();
    }

    @Override
    public BuyGemType buyGemType() {
        return BuyGemType.SUMMON_WEEK_CARD;
    }

    @Override
    public boolean canBuy(long rid, int productId) {
        if (!promotionControlService.isPromotionRunning(thisPromotionType())) {
            return false;
        }

        Promotion059SummonWeeksCardConfig config = getConfig(productId);
        Promotion059SummonWeeksCard promotion059SummonWeeksCard = getPromotionInfo(rid);

        return promotion059SummonWeeksCard.getBuyList().getOrDefault(config.getIdx(), 0) < config.getBuy_limit();
    }

    public Collection<Promotion059SummonWeeksCardConfig> getConfigList() {
        PromotionControl promotionControl = promotionControlService.getControl(thisPromotionType());
        return promotionControl.getAllConfig(Promotion059SummonWeeksCardConfig.class);
    }

    /**
     * 根据商品id获取配置
     *
     * @param productId
     * @return
     */
    private Promotion059SummonWeeksCardConfig getConfig(int productId) {
        Promotion059SummonWeeksCardConfig promotion059SummonWeeksCardConfig = null;
        for (Promotion059SummonWeeksCardConfig config : getConfigList()) {
            if (config.getProduct_id() == productId) {
                promotion059SummonWeeksCardConfig = config;
                break;
            }
        }
        Asserts.notNull(promotion059SummonWeeksCardConfig, ErrorCode.CONFIG_NOT_EXISTS.getValue(), String.format("召唤周卡活动不存在商品id:{%s}的配置", productId));
        return promotion059SummonWeeksCardConfig;
    }

    @Override
    public void buyGoodsSuccess(long rid, CBuyGem cBuyGem, boolean isGm) {

        Promotion059SummonWeeksCardConfig config = getConfig(cBuyGem.getIdx());

        Promotion059SummonWeeksCard promotion059SummonWeeksCard = getPromotionInfo(rid);
        promotion059SummonWeeksCard.getBuyList().put(config.getIdx(), promotion059SummonWeeksCard.getBuyList().getOrDefault(config.getIdx(), 0) + 1);

        updatePromotion(promotion059SummonWeeksCard);

        thingService.add(rid, ImmutableThingUtil.fromJson(config.getReward()), GameEvent.PROMOTION_SUMMON_WEEKS_CARD);

    }
}
