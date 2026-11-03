package com.ayjs.mxzg.gameserver.module.promotionNew.promotion096.service;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.promotion096.Promotion096MissionSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion096.CPromotion096Mission;
import com.ayjs.mxzg.config.struct.TargetStruct;
import com.ayjs.mxzg.config.struct.TargetType;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion096.dao.Promotion096Dao;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion096.domain.Promotion096;
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
public class Promotion096Service extends BasePromotionService<Promotion096> {

    @Autowired
    private Promotion096Dao promotion096Dao;
    @Autowired
    private Promotion096MissionSysCache promotion096MissionSysCache;

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.CHU_YOU_XUN_CHUN;
    }

    @Override
    public Promotion096 getPromotionInfo(long rid) {
        Promotion096 promotion = super.getPromotionInfo(rid);
        if (!LocalDate.now().isEqual(promotion.getMissionRefresh())) {
            promotion.getMissionInfoMap().clear();
            promotion.getMissionBoxRecord().clear();
            promotion.setMissionRefresh(LocalDate.now());
            updatePromotion(promotion);
        }
        return promotion;
    }

    @Override
    public IRepository<Promotion096> getRepository() {
        return promotion096Dao;
    }

    @Override
    protected void resetOnNewTurns(Promotion096 promotion, PromotionControl control) {
        promotion.getMissionInfoMap().clear();
        promotion.getMissionBoxRecord().clear();
        promotion.getMissionBoxRecord().clear();
        promotion.setMissionRefresh(LocalDate.now());

    }

    public boolean isOpening() {
        return promotionControlService.isPromotionRunning(thisPromotionType());
    }

    public List<CPromotion096Mission> getMissionConfigsByDay() {
        if (!isOpening()) {
            return null;
        }
        return promotion096MissionSysCache.getMissionByDay(getOpenDay());
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

    public List<CPromotion096Mission> getMissionConfigByTarget(TargetStruct targetStruct) {
        List<CPromotion096Mission> missions = getMissionConfigsByDay();
        if (CollectionUtil.isEmpty(missions)) {
            return null;
        }

        List<CPromotion096Mission> configList = missions.stream().filter(config -> TargetType.checkTrigger(config.getTarget(),
                targetStruct)).collect(Collectors.toList());

        return configList;
    }

}
