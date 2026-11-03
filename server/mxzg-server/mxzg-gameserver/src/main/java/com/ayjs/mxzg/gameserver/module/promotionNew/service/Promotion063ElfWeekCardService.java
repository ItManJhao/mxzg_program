package com.ayjs.mxzg.gameserver.module.promotionNew.service;

import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion063ElfWeekCardSysCache;
import com.ayjs.mxzg.config.excel.entity.CBuyGem;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion063ElfWeekCard;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.Promotion063ElfWeekCardDao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion063ElfWeekCard;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.recharge.constant.BuyGemType;
import com.ayjs.mxzg.gameserver.module.recharge.service.IRechargeBuyingService;
import com.ayjs.mxzg.protocol.ObjectGMsg;
import com.ayjs.mxzg.protocol.Promotion063GMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * 精灵周卡
 *
 * @author hyx
 */
@Service
public class Promotion063ElfWeekCardService extends BasePromotionService<Promotion063ElfWeekCard> implements IRechargeBuyingService {

    @Autowired
    private Promotion063ElfWeekCardDao promotion063ElfWeekCardDao;
    @Autowired
    private Promotion063ElfWeekCardSysCache promotion063ElfWeekCardSysCache;
    @Autowired
    private ThingService thingService;
    @Autowired
    private ContextManager contextManager;

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.JING_LING_ZHOU_KA;
    }

    @Override
    public IRepository<Promotion063ElfWeekCard> getRepository() {
        return promotion063ElfWeekCardDao;
    }

    @Override
    protected void resetOnNewTurns(Promotion063ElfWeekCard promotion, PromotionControl control) {
        promotion.getBuyList().clear();
    }

    @Override
    public BuyGemType buyGemType() {
        return BuyGemType.ELF_WEEK_CARD;
    }

    @Override
    public boolean canBuy(long rid, int productId) {
        if (!promotionControlService.isPromotionRunning(thisPromotionType())) {
            return false;
        }

        CPromotion063ElfWeekCard config = this.getProductConfig(productId);

        Promotion063ElfWeekCard promotion063ElfWeekCard = this.getPromotionInfo(rid);

        return promotion063ElfWeekCard.getBuyList().getOrDefault(config.getIdx(), 0) < config.getBuy_limit();
    }

    private CPromotion063ElfWeekCard getProductConfig(int productId) {
        CPromotion063ElfWeekCard cPromotion063ElfWeekCard = null;
        for (CPromotion063ElfWeekCard config : promotion063ElfWeekCardSysCache.getAll()) {
            if (config.getProduct_id() == productId) {
                cPromotion063ElfWeekCard = config;
            }
        }
        Asserts.notNull(cPromotion063ElfWeekCard, ErrorCode.CONFIG_NOT_EXISTS.getValue(), String.format("精灵周卡活动不存在商品id:{%s}的配置", productId));
        return cPromotion063ElfWeekCard;
    }

    @Override
    public void buyGoodsSuccess(long rid, CBuyGem cBuyGem, boolean isGm) {

        CPromotion063ElfWeekCard config = getProductConfig(cBuyGem.getIdx());

        Promotion063ElfWeekCard promotion063ElfWeekCard = getPromotionInfo(rid);
        promotion063ElfWeekCard.getBuyList().put(config.getIdx(), promotion063ElfWeekCard.getBuyList().getOrDefault(config.getIdx(), 0) + 1);

        updatePromotion(promotion063ElfWeekCard);

        if(isGm) {
            thingService.add(rid, config.getReward(), GameEvent.GM_RECHARGE);
        } else {
            thingService.add(rid, config.getReward(), GameEvent.PROMOTION_ELF_WEEKS_CARD);
        }

        this.sendPromotionInfo(rid);
    }

    public void sendPromotionInfo(long rid) {
        Promotion063ElfWeekCard promotion063ElfWeekCard = this.getPromotionInfo(rid);

        Promotion063GMsg.GResElfWeeksCardInfo.Builder builder = Promotion063GMsg.GResElfWeeksCardInfo.newBuilder();
        promotion063ElfWeekCardSysCache.getAll().forEach(config -> {
            ObjectGMsg.PSMapData.Builder data = ObjectGMsg.PSMapData.newBuilder();
            data.setKey(config.getIdx());
            data.setValue(promotion063ElfWeekCard.getBuyList().getOrDefault(config.getIdx(), 0));
            builder.setBuy(data);
        });

        contextManager.write(rid, CmdCode._13240, builder.build());
    }

}
