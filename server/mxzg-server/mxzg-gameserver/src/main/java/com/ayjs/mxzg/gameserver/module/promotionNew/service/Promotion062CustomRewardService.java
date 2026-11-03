package com.ayjs.mxzg.gameserver.module.promotionNew.service;

import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.config.excel.cache.BuyGemSysCache;
import com.ayjs.mxzg.config.excel.entity.CBuyGem;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.Promotion062CustomRewardDao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion062CustomReward;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.struct.CustomRewardData;
import com.ayjs.mxzg.gameserver.module.recharge.constant.BuyGemType;
import com.ayjs.mxzg.gameserver.module.recharge.service.IRechargeBuyingService;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion062CustomRewardConfig;
import com.ayjs.mxzg.protocol.Promotion062GMsg;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

/**
 * 私人定制
 */
@Service
@Slf4j
public class Promotion062CustomRewardService extends BasePromotionService<Promotion062CustomReward> implements IRechargeBuyingService {

    @Autowired
    private Promotion062CustomRewardDao promotion062CustomRewardDao;
    @Autowired
    private ThingService thingService;
    @Autowired
    private BuyGemSysCache buyGemSysCache;
    @Autowired
    private ContextManager contextManager;

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.CUSTOM;
    }

    @Override
    public IRepository<Promotion062CustomReward> getRepository() {
        return promotion062CustomRewardDao;
    }

    @Override
    protected void resetOnNewTurns(Promotion062CustomReward promotion, PromotionControl control) {
        promotion.getCustomData().clear();
    }

    @Override
    public BuyGemType buyGemType() {
        return BuyGemType.CUSTOM;
    }

    @Override
    public boolean canBuy(long rid, int productId) {
        if (!promotionControlService.isPromotionRunning(thisPromotionType())) {
            return false;
        }

        Promotion062CustomReward promotionInfo = getPromotionInfo(rid);
        CBuyGem buyGem = buyGemSysCache.getById(productId);

        CustomRewardData customRewardData = promotionInfo.getCustomData().get(productId);

        return customRewardData != null && customRewardData.getBuyCount() < buyGem.getLimit_times() &&
                customRewardData.getCustomRewardIds().size() > 0;
    }

    public Collection<Promotion062CustomRewardConfig> getConfigList() {
        PromotionControl promotionControl = promotionControlService.getControl(thisPromotionType());
        return promotionControl.getAllConfig(Promotion062CustomRewardConfig.class);
    }

    public Promotion062CustomRewardConfig getConfigById(int idx) {
        PromotionControl promotionControl = promotionControlService.getControl(thisPromotionType());
        return promotionControl.getConfig(idx, Promotion062CustomRewardConfig.class);
    }

    @Override
    public void buyGoodsSuccess(long rid, CBuyGem cBuyGem, boolean isGm) {
        Promotion062CustomReward promotionInfo = getPromotionInfo(rid);
        CustomRewardData customRewardData = promotionInfo.getCustomData().get(cBuyGem.getIdx());
        if (customRewardData == null) {
            log.error("定制奖励购买成功后，但是没有定制奖励");
            return;
        }
        customRewardData.setBuyCount(customRewardData.getBuyCount() + 1);
        updatePromotion(promotionInfo);

        List<Integer> rewardIds = customRewardData.getCustomRewardIds();
        PromotionControl control = promotionControlService.getControl(thisPromotionType());
        if (rewardIds == null) {
            log.error("定制奖励购买成功后，但是没有定制奖励");
            return;
        }

        List<ImmutableThing> reward = new ArrayList<>();
        rewardIds.forEach(rewardId -> {
            Promotion062CustomRewardConfig config = control.getConfig(rewardId, Promotion062CustomRewardConfig.class);
            reward.addAll(config.getRewardThings());
        });
        reward.addAll(cBuyGem.getItem());
        ImmutableThingUtil.mergeThing(reward);
        thingService.add(rid, reward, GameEvent.CUSTOM_REWARD);
        sendData(rid);
    }

    public void sendData(long rid) {
        Promotion062CustomReward promotionInfo = getPromotionInfo(rid);
        Promotion062GMsg.GResCustomRewardData.Builder builder = Promotion062GMsg.GResCustomRewardData.newBuilder();
        promotionInfo.getCustomData().forEach((key, value) -> {
            Promotion062GMsg.PSCustomData.Builder buyRecord = Promotion062GMsg.PSCustomData.newBuilder();
            buyRecord.setProductId(value.getProductId());
            buyRecord.addAllCustomRewardId(value.getCustomRewardIds());
            buyRecord.setBuyCount(value.getBuyCount());
            builder.addBuyRecord(buyRecord);
        });
        contextManager.write(rid, CmdCode._71001, builder.build());
    }
}
