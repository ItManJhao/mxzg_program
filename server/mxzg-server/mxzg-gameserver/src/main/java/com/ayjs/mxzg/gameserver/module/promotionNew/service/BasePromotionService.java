/**
 *
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.service;

import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.BaseLoopingPromotion;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.protocol.Task4GMsg;
import org.springframework.beans.factory.annotation.Autowired;

import java.lang.reflect.ParameterizedType;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author YY
 *
 */
public abstract class BasePromotionService<T extends BaseLoopingPromotion> {

    private static Map<PromotionType, BasePromotionService<?>> promotionServiceMap = new HashMap<>();

    @Autowired
    protected PromotionControlService promotionControlService;

    private Class<T> promotionClazz;

    @SuppressWarnings("unchecked")
    public BasePromotionService() {
        ParameterizedType type = (ParameterizedType) this.getClass().getGenericSuperclass();
        promotionClazz = (Class<T>) type.getActualTypeArguments()[0];

        promotionServiceMap.put(thisPromotionType(), this);
    }

    /**
     * 活动类型
     * @return
     */
    protected abstract PromotionType thisPromotionType();

    /**
     * Dao对象
     * @return
     */
    public abstract IRepository<T> getRepository();

    public T getPromotionInfo(long rid) {
        T promotion = getRepository().get(rid);
        if (promotion == null) {
            try {
                promotion = promotionClazz.newInstance();
                promotion.setRid(rid);
                onCreatingInfo(promotion);
                getRepository().add(promotion);
            } catch (InstantiationException e) {
                e.printStackTrace();
            } catch (IllegalAccessException e) {
                e.printStackTrace();
            }
        }
        tryResetPromotion(promotion);
        return promotion;
    }

    private void tryResetPromotion(T promotion) {
        PromotionControl control = promotionControlService.getControl(thisPromotionType());
        boolean needReset = false;
        if (promotion.getTurns() != control.getTurns()) {
            //轮次不一样，重置活动数据
            needReset = true;
        } else {
            if (promotion.getTurnsTime() != control.getTurnsTime()) {
                //轮次一样但轮次的时间不一样，比如在相隔一个月之后，活动回到第一轮，
                //活动上的时间是现在，玩家上的时间是一个月之前，则需要重置数据，重置活动数据
                needReset = true;
            }
        }
        if (needReset) {
            promotion.setTurns(control.getTurns());
            promotion.setTurnsTime(control.getTurnsTime());
            resetOnNewTurns(promotion, control);
            getRepository().update(promotion);
        }
        if (resetOnSpecial(promotion)) {
            getRepository().update(promotion);
        }
    }

    public List<T> getAllPromotionInfo() {
        List<T> result = getRepository().listAll();
        result.forEach(this::tryResetPromotion);
        return result;
    }

    protected void onCreatingInfo(T promotion) {

    }

    /**
     * 每一轮新开始的时候重置活动数据
     * @param promotion
     */
    protected abstract void resetOnNewTurns(T promotion, PromotionControl control);

    /**
     * 重置活动的一些独特数据，比如每日重置
     * @param promotion
     * @return
     */
    protected boolean resetOnSpecial(T promotion) {
        return false;
    }

    public void updatePromotion(T promotion) {
        getRepository().update(promotion);
    }

    /**
     * 在新一轮活动开始时执行
     * @param control
     */
    public void handleOnPromotionNewTurns(PromotionControl control) {

    }

    /**
     * 在本轮活动结束时执行
     * @param control
     */
    public void handleOnPromotionClear(PromotionControl control) {

    }

    public static BasePromotionService<?> getPromotionService(PromotionType promotionType) {
        return promotionServiceMap.get(promotionType);
    }

    /***
     * 请求活动信息
     * @param rid
     */
    public Task4GMsg.PSActivityInfo sendActivityData(long rid) {
        return null;
    }

    /***
     * 领取活动奖励
     * @param rid
     * @param idx
     */
    public boolean getActivityReward(long rid, int idx) {
        return true;
    }

    /***
     * 获取运营配置接口
     * @return
     */
    public String getConfigStr() {
        if (thisPromotionType().getOpenType() == 2)
            return promotionControlService.getControl(thisPromotionType()).getConfig();
        return null;
    }

}
