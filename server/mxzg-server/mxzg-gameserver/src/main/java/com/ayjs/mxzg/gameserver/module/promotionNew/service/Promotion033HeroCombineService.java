package com.ayjs.mxzg.gameserver.module.promotionNew.service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion033CombineSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion033Combine;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroStarUpEvent;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.Promotion033HeroCombineDao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion033HeroCombine;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

/**
 * 合成觉醒
 *
 * @Author: CWJ
 * @Date: 2019/10/23
 **/
@Service
@Observer
public class Promotion033HeroCombineService extends BasePromotionService<Promotion033HeroCombine> {

    @Autowired
    private Promotion033HeroCombineDao promotion033HeroCombineDao;
    @Autowired
    private PromotionControlService promotionControlService;
    @Autowired
    private Promotion033CombineSysCache promotion033CombineSysCache;

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.HE_CHENG_JUE_XING;
    }

    @Override
    public IRepository<Promotion033HeroCombine> getRepository() {
        return promotion033HeroCombineDao;
    }

    @Override
    protected void resetOnNewTurns(Promotion033HeroCombine promotion, PromotionControl control) {
        promotion.getRewardRecord().clear();
        promotion.getCountRecord().clear();
    }

    @Subscribe
    public void combineHero(HeroStarUpEvent event) {
        if (!promotionControlService.isPromotionRunning(thisPromotionType()))
            return;
        List<CPromotion033Combine> list = promotion033CombineSysCache.getAll().stream().filter(config -> config.getStar() == event.getHero().getStar() && config.getTurns()
                == promotionControlService.getControl(thisPromotionType()).getTurns()).collect(Collectors.toList());
        Promotion033HeroCombine heroCombine = getPromotionInfo(event.getHero().getRid());
        if (list.isEmpty()) {
            return;
        }
        list.forEach(config -> {
            int count = heroCombine.getCountRecord().getOrDefault(config.getIdx(), 0);
            if (count < config.getReward_limit()) {
                heroCombine.getCountRecord().put(config.getIdx(), count + 1);
                updatePromotion(heroCombine);
            }
        });
    }
}
