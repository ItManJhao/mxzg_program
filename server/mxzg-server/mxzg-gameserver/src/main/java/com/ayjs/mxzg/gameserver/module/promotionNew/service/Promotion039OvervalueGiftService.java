package com.ayjs.mxzg.gameserver.module.promotionNew.service;

import java.util.Collection;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.common.util.JsonUtil;
import com.ayjs.mxzg.config.excel.cache.BuyGemSysCache;
import com.ayjs.mxzg.config.excel.entity.CBuyGem;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.Promotion039OvervalueGiftDao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion039OvervalueGift;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.recharge.constant.BuyGemType;
import com.ayjs.mxzg.gameserver.module.recharge.service.IRechargeBuyingService;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion039OvervalueGiftConfig;
import com.ayjs.mxzg.protocol.ObjectGMsg;
import com.ayjs.mxzg.protocol.Promotion039GMsg;

@Service
public class Promotion039OvervalueGiftService extends BasePromotionService<Promotion039OvervalueGift> implements IRechargeBuyingService {

    @Autowired
    private Promotion039OvervalueGiftDao promotion039OvervalueGiftDao;
    @Autowired
    private ThingService thingService;
    @Autowired
    private BuyGemSysCache buyGemSysCache;
    @Autowired
    private ContextManager contextManager;

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.CHAO_ZHI_LI_BAO;
    }

    @Override
    protected void resetOnNewTurns(Promotion039OvervalueGift promotion, PromotionControl control) {
        promotion.getBuyMap().clear();
    }

    @Override
    public IRepository<Promotion039OvervalueGift> getRepository() {
        return promotion039OvervalueGiftDao;
    }

    /**
     * 获取所有配置
     *
     * @return
     */
    public Collection<Promotion039OvervalueGiftConfig> selectConfigList() {
        return promotionControlService.getControl(thisPromotionType()).getAllConfig(Promotion039OvervalueGiftConfig.class);
    }


    /**
     * 获取活动单条配置
     *
     * @param productionId
     * @return
     */
    public Promotion039OvervalueGiftConfig selectConfig(int productionId) {
        Promotion039OvervalueGiftConfig model = null;
        for (Promotion039OvervalueGiftConfig config : selectConfigList()) {
            if (config.getProduction_id() == productionId) {
                model = config;
            }
        }
        return model;
    }

    @Override
    public BuyGemType buyGemType() {
        return BuyGemType.OVERVALUE_GIFT;
    }

    @Override
    public String getConfigStr() {
        return JsonUtil.toJson(selectConfigList());
    }

    /**
     * 该礼包是否可以购买
     *
     * @param rid
     * @param productionId
     * @return
     */
    @Override
    public boolean canBuy(long rid, int productionId) {

        if (!promotionControlService.isPromotionRecording(thisPromotionType())) {
            return false;
        }

        CBuyGem buyGem = buyGemSysCache.getOrThrow(productionId);
        if (buyGem == null) {
            return false;
        }
        Promotion039OvervalueGiftConfig config = selectConfig(productionId);
        if (config == null) {
            return false;
        }

        Promotion039OvervalueGift promotion039OvervalueGift = getPromotionInfo(rid);
        if (promotion039OvervalueGift.getBuyMap().get(config.getIdx()) == null) {
            return true;
        }

        if (promotion039OvervalueGift.getBuyMap().get(config.getIdx()) < config.getBuy_limit()) {
            return true;
        }

        return false;
    }

    /**
     * 记录限购次数
     *
     * @param rid
     * @param cBuyGem
     */
    @Override
    public void buyGoodsSuccess(long rid, CBuyGem cBuyGem, boolean isGm) {
        Promotion039OvervalueGift promotion039OvervalueGift = getPromotionInfo(rid);
        Promotion039OvervalueGiftConfig config = selectConfig(cBuyGem.getIdx());
        if (config == null) {
            return;
        }
        Integer buyNum = promotion039OvervalueGift.getBuyMap().get(config.getIdx());
        if (buyNum == null) {
            buyNum = 0;
        }
        promotion039OvervalueGift.getBuyMap().put(config.getIdx(), buyNum + 1);
        updatePromotion(promotion039OvervalueGift);

        if(isGm) {
        	thingService.add(rid, ImmutableThingUtil.fromJson(config.getGift_reward()), GameEvent.GM_RECHARGE);
        } else {
        	thingService.add(rid, ImmutableThingUtil.fromJson(config.getGift_reward()), GameEvent.OVERVALUE_GIFT);
        }
        getOverValueData(rid);
    }

    /**
     * 获取超值礼包列表
     *
     * @param rid
     */
    public void getOverValueData(long rid) {
        Promotion039GMsg.GResOverValueData.Builder builder = Promotion039GMsg.GResOverValueData.newBuilder();

        PromotionControl promotionControl = promotionControlService.getControl(PromotionType.CHAO_ZHI_LI_BAO);

        Promotion039OvervalueGift overvalueGift = getPromotionInfo(rid);

        overvalueGift.getBuyMap().forEach((k, v) -> {
            ObjectGMsg.PSMapData.Builder data = ObjectGMsg.PSMapData.newBuilder();
            data.setKey(k);
            data.setValue(v);
            builder.addList(data);
        });

        contextManager.write(rid, CmdCode._13181, builder.build());
    }

}
