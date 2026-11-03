package com.ayjs.mxzg.gameserver.module.promotionNew.promotion085.service;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.promotion085.Promotion085MissionSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion085.CPromotion085Mission;
import com.ayjs.mxzg.config.struct.TargetStruct;
import com.ayjs.mxzg.config.struct.TargetType;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion085.dao.Promotion085Dao;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion085.domain.Promotion085;
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
public class Promotion085Service extends BasePromotionService<Promotion085> {

    @Autowired
    private Promotion085Dao promotion085Dao;
    @Autowired
    private Promotion085MissionSysCache promotion085MissionSysCache;

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.CHRISTMAS_MISSION;
    }

    @Override
    public Promotion085 getPromotionInfo(long rid) {
        Promotion085 promotion = super.getPromotionInfo(rid);
        if (!LocalDate.now().isEqual(promotion.getMissionRefresh())) {
            promotion.getMissionInfoMap().clear();
            promotion.getMissionBoxRecord().clear();
            promotion.setMissionRefresh(LocalDate.now());
            updatePromotion(promotion);
        }
        return promotion;
    }

    @Override
    public IRepository<Promotion085> getRepository() {
        return promotion085Dao;
    }

    @Override
    protected void resetOnNewTurns(Promotion085 promotion, PromotionControl control) {
        promotion.getMissionInfoMap().clear();
        promotion.getMissionBoxRecord().clear();
        promotion.getMissionBoxRecord().clear();
        promotion.setMissionRefresh(LocalDate.now());

    }

    public boolean isOpening() {
        return promotionControlService.isPromotionRunning(thisPromotionType());
    }

    public List<CPromotion085Mission> getMissionConfigsByDay() {
        if (!isOpening()) {
            return null;
        }
        return promotion085MissionSysCache.getMissionByDay(getOpenDay());
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

    public List<CPromotion085Mission> getMissionConfigByTarget(TargetStruct targetStruct) {
        List<CPromotion085Mission> missions = getMissionConfigsByDay();
        if (CollectionUtil.isEmpty(missions)) {
            return null;
        }

        List<CPromotion085Mission> configList = missions.stream().filter(config -> TargetType.checkTrigger(config.getTarget(),
                targetStruct)).collect(Collectors.toList());

        return configList;
    }

}
