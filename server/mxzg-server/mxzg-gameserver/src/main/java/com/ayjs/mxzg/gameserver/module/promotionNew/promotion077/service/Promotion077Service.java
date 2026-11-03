package com.ayjs.mxzg.gameserver.module.promotionNew.promotion077.service;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.promotion077.Promotion077MissionSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion077.CPromotion077Mission;
import com.ayjs.mxzg.config.struct.TargetStruct;
import com.ayjs.mxzg.config.struct.TargetType;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion077.dao.Promotion077Dao;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion077.domain.Promotion077;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.BasePromotionService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2020/9/22
 **/
@Slf4j
@Service
public class Promotion077Service extends BasePromotionService<Promotion077> {

    @Autowired
    private Promotion077Dao promotion077Dao;
    @Autowired
    private Promotion077MissionSysCache promotion077MissionSysCache;

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.GUANG_YUE_REN_WU;
    }

    @Override
    public Promotion077 getPromotionInfo(long rid) {
        Promotion077 promotion = super.getPromotionInfo(rid);
        if (!LocalDate.now().isEqual(promotion.getMissionRefresh())) {
            promotion.getMissionInfoMap().clear();
            promotion.getMissionBoxRecord().clear();
            promotion.setMissionRefresh(LocalDate.now());
            updatePromotion(promotion);
        }
        return promotion;
    }

    @Override
    public IRepository<Promotion077> getRepository() {
        return promotion077Dao;
    }

    @Override
    protected void resetOnNewTurns(Promotion077 promotion, PromotionControl control) {
        promotion.getMissionInfoMap().clear();
        promotion.getMissionBoxRecord().clear();
        promotion.getMissionBoxRecord().clear();
        promotion.setMissionRefresh(LocalDate.now());

    }

    public boolean isOpening() {
        return promotionControlService.isPromotionRunning(thisPromotionType());
    }

    public List<CPromotion077Mission> getMissionConfigsByDay() {
        if (!isOpening()) {
            return null;
        }
        return promotion077MissionSysCache.getMissionByDay(getOpenDay());
    }

    /***
     * 活动未开启时，天数未0
     * @return
     */
    public int getOpenDay() {
        PromotionControl control = promotionControlService.getControl(thisPromotionType());
        if (Objects.isNull(control)) {
            log.error("不存在该活动类型：{}", thisPromotionType());
            return 0;
        }

        if (!isOpening()) {
            return 0;
        }

        int intervalDay = TimeDateUtil.intervalDays(control.getStartTime(), TimeDateUtil.getCurrentTimeInt());
        return intervalDay;
    }

    public List<CPromotion077Mission> getMissionConfigByTarget(TargetStruct targetStruct) {
        List<CPromotion077Mission> missions = getMissionConfigsByDay();
        if (CollectionUtil.isEmpty(missions)) {
            return null;
        }

        List<CPromotion077Mission> configList = missions.stream().filter(config -> TargetType.checkTrigger(config.getTarget(),
                targetStruct)).collect(Collectors.toList());

        return configList;
    }
}
