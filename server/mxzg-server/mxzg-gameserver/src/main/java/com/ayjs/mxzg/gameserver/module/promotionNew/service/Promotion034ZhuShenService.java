package com.ayjs.mxzg.gameserver.module.promotionNew.service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion034PveDropsSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion034PveRewardSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion034PveDrops;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion034PveReward;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.Promotion034ZhuShenDao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion034ZhuShen;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.struct.ZhuShenLevelInfo;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2019/10/25
 **/
@Service
@Observer
public class Promotion034ZhuShenService extends BasePromotionService<Promotion034ZhuShen> {

    @Autowired
    private Promotion034ZhuShenDao promotion034ZhuShenDao;
    @Autowired
    private Promotion034PveRewardSysCache promotion034PveRewardSysCache;
    @Autowired
    private Promotion034PveDropsSysCache promotion034PveDropsSysCache;
    @Autowired
    private Promotion016DragonInfoService promotion016DragonInfoService;
    @Autowired
    private RoleService roleService;

    public static final int HP_RATE = 10000;

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.ZHU_SHEN_ZHI_ZHAN;
    }

    @Override
    public IRepository<Promotion034ZhuShen> getRepository() {
        return promotion034ZhuShenDao;
    }

    @Override
    protected void resetOnNewTurns(Promotion034ZhuShen promotion, PromotionControl control) {
        if (control.getStartTime() > promotion.getLastDropTime()) {
            promotion.setLastDropTime(control.getStartTime());
        }

        promotion.getTypeVoMap().clear();

        List<Integer> types = promotion034PveRewardSysCache.getConfigsByTurn(control.getTurns()).stream()
                .map(CPromotion034PveReward::getMission_type).distinct().collect(Collectors.toList());
        types.forEach(type -> {
            ZhuShenLevelInfo info = new ZhuShenLevelInfo();
            info.setCurrHpRate(HP_RATE);
            info.setLevel(1);
            promotion.getLevelInfoMap().put(type, info);
        });
    }


    public List<ImmutableThing> randomIdleDrops(long rid, int hangTime) {
        if (!promotionControlService.canRecordPromotionData(rid, thisPromotionType())) {
            return Collections.emptyList();
        }
        Promotion034ZhuShen promotionInfo = getPromotionInfo(rid);
        CPromotion034PveDrops cDrop = promotion034PveDropsSysCache.getByTurns(promotionInfo.getTurns());

        List<ImmutableThing> rewardList = promotion016DragonInfoService.randomDrop(promotionInfo, cDrop, hangTime);
        if (!rewardList.isEmpty()) {
            updatePromotion(promotionInfo);
        }
        return rewardList;
    }

    public List<ImmutableThing> randomQuickDrops(long rid, int hangTime) {
        if (!promotionControlService.canRecordPromotionData(rid, thisPromotionType())) {
            return Collections.emptyList();
        }
        Promotion034ZhuShen promotionInfo = getPromotionInfo(rid);
        CPromotion034PveDrops cDrop = promotion034PveDropsSysCache.getByTurns(promotionInfo.getTurns());
        return promotion016DragonInfoService.randomQuickDrop(promotionInfo, cDrop, hangTime);
    }

    @Override
    protected void onCreatingInfo(Promotion034ZhuShen promotion) {
        Role role = roleService.getOrThrow(promotion.getRid());
        promotion.setLastDropTime((int) (role.getCreateTime() / 1000));
    }
}
