/**
 *
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.service;

import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.common.util.JsonUtil;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.config.excel.entity.CBuyGem;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.Promotion056FashionBuyDao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion056FashionBuy;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.recharge.constant.BuyGemType;
import com.ayjs.mxzg.gameserver.module.recharge.service.IRechargeBuyingService;
import com.ayjs.mxzg.gameserver.module.server.service.ServerParamService;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion056FashionBuyConfig;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Collection;
import java.util.List;
import java.util.stream.Collectors;

/**
 * cwj
 */
@Slf4j
@Service
public class Promotion056FashionBuyService extends BasePromotionService<Promotion056FashionBuy> implements IRechargeBuyingService {

    @Autowired
    private ThingService thingService;
    @Autowired
    private Promotion056FashionBuyDao promotion056FashionBuyDao;
    @Autowired
    private PromotionControlService promotionControlService;
    @Autowired
    private ServerParamService serverParamService;

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.FASHION_BUY;
    }


    @Override
    public BuyGemType buyGemType() {
        return BuyGemType.FASHION_BUY;
    }

    @Override
    protected void resetOnNewTurns(Promotion056FashionBuy promotion, PromotionControl control) {
        promotion.getBuyCount().clear();
    }

    @Override
    public IRepository<Promotion056FashionBuy> getRepository() {
        return promotion056FashionBuyDao;
    }


    @Override
    public boolean canBuy(long rid, int productId) {
        if (!promotionControlService.isPromotionRunning(thisPromotionType())) {
            return false;
        }
        PromotionControl control = promotionControlService.getControl(thisPromotionType());
        Collection<Promotion056FashionBuyConfig> configs = control.getAllConfig(Promotion056FashionBuyConfig.class);

        Promotion056FashionBuyConfig config = configs.stream().filter(configTemp -> configTemp.getProduction_id() == productId).findFirst().orElse(null);

        if (config == null) {
            log.info("---------------皮肤活动错误的商品id:" + productId);
            return false;
        }

        return getCount(getPromotionInfo(rid), config) < config.getNum();
    }

    @Override
    public void buyGoodsSuccess(long rid, CBuyGem cBuyGem, boolean isGm) {
        PromotionControl control = promotionControlService.getControl(thisPromotionType());
        Collection<Promotion056FashionBuyConfig> configs = control.getAllConfig(Promotion056FashionBuyConfig.class);
        Promotion056FashionBuyConfig config = configs.stream().filter(configTemp -> configTemp.getProduction_id() == cBuyGem.getIdx()).findFirst().orElse(null);

        if (config == null) {
            log.info("----------------发货失败,皮肤活动错误的商品id:" + cBuyGem.getIdx());
            return;
        }

        Promotion056FashionBuy promotionInfo = getPromotionInfo(rid);
        promotionInfo.getBuyCount().put(config.getId(), promotionInfo.getBuyCount().getOrDefault(config.getId(), 0) + 1);
        updatePromotion(promotionInfo);

        thingService.add(rid, ImmutableThingUtil.fromJson(config.getReward()), GameEvent.FASHION_BUY);
    }

    public int getCount(Promotion056FashionBuy promotion056FashionBuy, Promotion056FashionBuyConfig config) {

        if (!promotionControlService.isPromotionRunning(thisPromotionType())) {
            return Integer.MAX_VALUE;
        }

        return promotion056FashionBuy.getBuyCount().getOrDefault(config.getId(), 0);

    }


}
