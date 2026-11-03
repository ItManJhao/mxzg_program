package com.ayjs.mxzg.gameserver.module.promotionNew.promotion080.service;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.promotion080.Promotion080MissionSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion080.CPromotion080Mission;
import com.ayjs.mxzg.config.struct.TargetStruct;
import com.ayjs.mxzg.config.struct.TargetType;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion080.dao.Promotion080Dao;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion080.domain.Promotion080;
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
public class Promotion080Service extends BasePromotionService<Promotion080> {

    @Autowired
    private Promotion080Dao promotion080Dao;
    @Autowired
    private Promotion080MissionSysCache promotion080MissionSysCache;

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.WAN_SHENG_MISSION;
    }

    @Override
    public Promotion080 getPromotionInfo(long rid) {
        Promotion080 promotion = super.getPromotionInfo(rid);
        if (!LocalDate.now().isEqual(promotion.getMissionRefresh())) {
            promotion.getMissionInfoMap().clear();
            promotion.getMissionBoxRecord().clear();
            promotion.setMissionRefresh(LocalDate.now());
            updatePromotion(promotion);
        }
        return promotion;
    }

    @Override
    public IRepository<Promotion080> getRepository() {
        return promotion080Dao;
    }

    @Override
    protected void resetOnNewTurns(Promotion080 promotion, PromotionControl control) {
        promotion.getMissionInfoMap().clear();
        promotion.getMissionBoxRecord().clear();
        promotion.getMissionBoxRecord().clear();
        promotion.setMissionRefresh(LocalDate.now());

    }

    public boolean isOpening() {
        return promotionControlService.isPromotionRunning(thisPromotionType());
    }

    public List<CPromotion080Mission> getMissionConfigsByDay() {
        if (!isOpening()) {
            return null;
        }
        return promotion080MissionSysCache.getMissionByDay(getOpenDay());
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

    public List<CPromotion080Mission> getMissionConfigByTarget(TargetStruct targetStruct) {
        List<CPromotion080Mission> missions = getMissionConfigsByDay();
        if (CollectionUtil.isEmpty(missions)) {
            return null;
        }

        List<CPromotion080Mission> configList = missions.stream().filter(config -> TargetType.checkTrigger(config.getTarget(),
                targetStruct)).collect(Collectors.toList());

        return configList;
    }
}
