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
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.Promotion071QiShenQiDao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion071QiShenQi;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.recharge.constant.BuyGemType;
import com.ayjs.mxzg.gameserver.module.recharge.service.IRechargeBuyingService;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion071QSQConfig;
import com.ayjs.mxzg.protocol.ObjectGMsg;
import com.ayjs.mxzg.protocol.Promotion071GMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Collection;

/**
 * 七神器
 */
@Service
public class Promotion071QiShenQiService extends BasePromotionService<Promotion071QiShenQi> implements IRechargeBuyingService {

    @Autowired
    private Promotion071QiShenQiDao promotion071QiShenQiDao;

    @Autowired
    private ThingService thingService;
    @Autowired
    private ContextManager contextManager;


    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.QI_SHEN_QI;
    }

    @Override
    public IRepository<Promotion071QiShenQi> getRepository() {
        return promotion071QiShenQiDao;
    }

    @Override
    protected void resetOnNewTurns(Promotion071QiShenQi promotion, PromotionControl control) {
        promotion.getBuyList().clear();
    }

    @Override
    public BuyGemType buyGemType() {
        return BuyGemType.QI_SHEN_QI;
    }

    @Override
    public boolean canBuy(long rid, int productId) {
        if (!promotionControlService.isPromotionRunning(thisPromotionType())) {
            return false;
        }
        Promotion071QSQConfig config = getConfig(productId);
        Promotion071QiShenQi promotion071QiShenQi = getPromotionInfo(rid);
        return promotion071QiShenQi.getBuyList().getOrDefault(config.getIdx(), 0) < config.getBuy_limit();
    }

    public Collection<Promotion071QSQConfig> getConfigList() {
        PromotionControl promotionControl = promotionControlService.getControl(thisPromotionType());
        return promotionControl.getAllConfig(Promotion071QSQConfig.class);
    }

    /**
     * 根据商品id获取配置
     *
     * @param productId
     * @return
     */
    private Promotion071QSQConfig getConfig(int productId) {
        Promotion071QSQConfig promotion071QSQConfig = null;
        for (Promotion071QSQConfig config : getConfigList()) {
            if (config.getProduct_id() == productId) {
                promotion071QSQConfig = config;
                break;
            }
        }
        Asserts.notNull(promotion071QSQConfig, ErrorCode.CONFIG_NOT_EXISTS.getValue(), String.format("七神器活动不存在商品id:{%s}的配置", productId));
        return promotion071QSQConfig;
    }


    @Override
    public void buyGoodsSuccess(long rid, CBuyGem cBuyGem, boolean isGm) {
        Promotion071QSQConfig config = getConfig(cBuyGem.getIdx());

        Promotion071QiShenQi promotion071QiShenQi = getPromotionInfo(rid);
        promotion071QiShenQi.getBuyList().put(config.getIdx(), promotion071QiShenQi.getBuyList().getOrDefault(config.getIdx(), 0) + 1);

        updatePromotion(promotion071QiShenQi);

        thingService.add(rid, ImmutableThingUtil.fromJson(config.getReward()), GameEvent.QI_SHEN_QI);
        //购买推送数据
        Promotion071GMsg.GResQiShenQiBuy.Builder builder = Promotion071GMsg.GResQiShenQiBuy.newBuilder();
        ObjectGMsg.PSMapData.Builder data = ObjectGMsg.PSMapData.newBuilder();
        data.setKey(config.getIdx());
        data.setValue(promotion071QiShenQi.getBuyList().getOrDefault(config.getIdx(), 0));
        builder.setBuy(data);
        contextManager.write(rid, CmdCode._75102, builder.build());
    }
}
