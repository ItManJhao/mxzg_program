package com.ayjs.mxzg.gameserver.module.promotionNew.service;


import com.ayjs.mxzg.gameserver.module.promotionNew.dao.Promotion066GamePlayPredictionDao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion066GamePlayPrediction;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * 新功能预活动
 *
 * @author hyx
 */
@Service
public class Promotion066GamePlayPredictionService {

    @Autowired
    private Promotion066GamePlayPredictionDao promotion066GamePlayPredictionDao;

   /* @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.GONG_NENG_YU_GAO;
    }

    @Override
    public IRepository<Promotion066GamePlayPrediction> getRepository() {
        return promotion066GamePlayPredictionDao;
    }

    @Override
    protected void resetOnNewTurns(Promotion066GamePlayPrediction promotion, PromotionControl control) {
        promotion.setReceiveTime(0);
    }

    *//**
     * 获取活动配置
     *
     * @return
     *//*
    public Promotion066GamePlayPredictionConfig getConfig() {
        String config = this.getConfigStr();
        Asserts.notNull(config, ErrorCode.CONFIG_NOT_EXISTS.getValue(), String.format("活动：{%s}，后台上传配置不存在", thisPromotionType().getId()));

        PromotionControl promotionControl = promotionControlService.getControl(thisPromotionType());
        Collection<Promotion066GamePlayPredictionConfig> configs = promotionControl.getAllConfig(Promotion066GamePlayPredictionConfig.class);
        return new ArrayList<>(configs).get(0);
    }*/

    /**
     * 获取数据
     *
     * @return
     */
    public Promotion066GamePlayPrediction getPromotionInfo(long rid) {
        Promotion066GamePlayPrediction promotion066GamePlayPrediction = promotion066GamePlayPredictionDao.get(rid);
        if (promotion066GamePlayPrediction == null) {
            promotion066GamePlayPrediction = new Promotion066GamePlayPrediction();
            promotion066GamePlayPrediction.setRid(rid);
            promotion066GamePlayPredictionDao.add(promotion066GamePlayPrediction);
        }
        return promotion066GamePlayPrediction;
    }

    /**
     * 更新数据
     *
     * @param promotion
     */
    public void update(Promotion066GamePlayPrediction promotion) {
        promotion066GamePlayPredictionDao.update(promotion);
    }

}
