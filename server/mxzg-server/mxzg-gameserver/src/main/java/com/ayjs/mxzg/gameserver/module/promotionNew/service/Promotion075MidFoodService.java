package com.ayjs.mxzg.gameserver.module.promotionNew.service;

import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.config.excel.entity.CBuyGem;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.Promotion075MidFoodDao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion075MidFood;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.recharge.constant.BuyGemType;
import com.ayjs.mxzg.gameserver.module.recharge.service.IRechargeBuyingService;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion075MidFoodConfig;
import com.ayjs.mxzg.protocol.ObjectGMsg;
import com.ayjs.mxzg.protocol.Promotion075GMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Collection;

/**
 * 赏月佳肴
 */
@Service
public class Promotion075MidFoodService extends BasePromotionService<Promotion075MidFood> implements IRechargeBuyingService {
    @Autowired
    private ThingService thingService;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private Promotion075MidFoodDao promotion075MidFoodDao;

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.MID_FOOD;
    }

    @Override
    public IRepository<Promotion075MidFood> getRepository() {
        return promotion075MidFoodDao;
    }

    @Override
    protected void resetOnNewTurns(Promotion075MidFood promotion, PromotionControl control) {
        promotion.getBuyList().clear();
    }

    @Override
    public BuyGemType buyGemType() {
        return BuyGemType.MID_FOOD;
    }

    @Override
    public boolean canBuy(long rid, int productId) {
        if (!promotionControlService.isPromotionRunning(thisPromotionType())) {
            return false;
        }
        Promotion075MidFoodConfig config = getConfig(productId);
        Promotion075MidFood promotion075MidFood = getPromotionInfo(rid);
        return promotion075MidFood.getBuyList().getOrDefault(config.getIdx(), 0) < config.getBuy_limit();
    }

    public Collection<Promotion075MidFoodConfig> getConfigList() {
        PromotionControl promotionControl = promotionControlService.getControl(thisPromotionType());
        return promotionControl.getAllConfig(Promotion075MidFoodConfig.class);
    }

    /**
     * 根据商品id获取配置
     *
     * @param productId
     * @return
     */
    private Promotion075MidFoodConfig getConfig(int productId) {
        Promotion075MidFoodConfig promotion075MidFoodConfig = null;
        for (Promotion075MidFoodConfig config : getConfigList()) {
            if (config.getProduct_id() == productId) {
                promotion075MidFoodConfig = config;
                break;
            }
        }
        Asserts.notNull(promotion075MidFoodConfig, ErrorCode.CONFIG_NOT_EXISTS.getValue(), String.format("赏月佳肴活动不存在商品id:{%s}的配置", productId));
        return promotion075MidFoodConfig;
    }

    @Override
    public void buyGoodsSuccess(long rid, CBuyGem cBuyGem, boolean isGm) {
        Promotion075MidFoodConfig config = getConfig(cBuyGem.getIdx());

        Promotion075MidFood promotion075MidFood = getPromotionInfo(rid);
        promotion075MidFood.getBuyList().put(config.getIdx(), promotion075MidFood.getBuyList().getOrDefault(config.getIdx(), 0) + 1);

        updatePromotion(promotion075MidFood);

        thingService.add(rid, ImmutableThingUtil.fromJson(config.getReward()), GameEvent.MID_FOOD);
        //购买推送数据
        Promotion075GMsg.GResMidFoodBuy.Builder builder = Promotion075GMsg.GResMidFoodBuy.newBuilder();
        ObjectGMsg.PSMapData.Builder data = ObjectGMsg.PSMapData.newBuilder();
        data.setKey(config.getIdx());
        data.setValue(promotion075MidFood.getBuyList().getOrDefault(config.getIdx(), 0));
        builder.setBuy(data);
        contextManager.write(rid, CmdCode._75132, builder.build());
    }
}
