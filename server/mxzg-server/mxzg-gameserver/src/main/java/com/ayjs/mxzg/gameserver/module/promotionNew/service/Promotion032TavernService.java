package com.ayjs.mxzg.gameserver.module.promotionNew.service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.config.excel.cache.TavernSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion032TavernSysCache;
import com.ayjs.mxzg.config.excel.entity.CTavern;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion032Tavern;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.Promotion032TavernDao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion032Tavern;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.event.Promotion032TavernRewardEvent;
import com.ayjs.mxzg.gameserver.module.task.event.TavernTaskRewardEvent;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2019/10/23
 **/
@Service
@Observer
@Slf4j
public class Promotion032TavernService extends BasePromotionService<Promotion032Tavern> {
    @Autowired
    private Promotion032TavernDao promotion032TavernDao;
    @Autowired
    private TavernSysCache tavernSysCache;
    @Autowired
    private Promotion032TavernSysCache promotion032TavernSysCache;
    @Autowired
    private PromotionControlService promotionControlService;
    @Autowired
    private EventBus eventbus;

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.JIU_GUAN_DA_BIAO;
    }

    @Override
    public IRepository<Promotion032Tavern> getRepository() {
        return promotion032TavernDao;
    }

    @Override
    protected void resetOnNewTurns(Promotion032Tavern promotion, PromotionControl control) {
        promotion.getCountMap().clear();
        promotion.getRewardMap().clear();
    }

    @Subscribe
    public void tavernTaskReward(TavernTaskRewardEvent event) {

        if (!promotionControlService.canRecordPromotionData(event.getRid(), thisPromotionType())) {
            return;
        }
        Promotion032Tavern promotion032Tavern = getPromotionInfo(event.getRid());
        event.getTaskIds().forEach(idx -> {
            CTavern taskConfig = tavernSysCache.getOrThrow(idx);
            List<CPromotion032Tavern> configs = promotion032TavernSysCache.getAll().stream().filter(config -> taskConfig.getStar() == config.getStar() && config.getTurns()
                    == promotionControlService.getControl(thisPromotionType()).getTurns()).collect(Collectors.toList());
            if (configs.isEmpty()) {
                return;
            }
            configs.forEach(config -> {
                int count = promotion032Tavern.getCountMap().getOrDefault(config.getIdx(), 0);
                if (count < config.getNum()) {
                    promotion032Tavern.getCountMap().put(config.getIdx(), count + 1);
                }
            });
        });
        updatePromotion(promotion032Tavern);
    }

    /***
     * 酒馆达标领奖事件
     * @param event
     */
    @Subscribe
    public void tavernReward(Promotion032TavernRewardEvent event) {
        if (!promotionControlService.canRecordPromotionData(event.getRid(), thisPromotionType())) {
            return;
        }

        List<CPromotion032Tavern> configs = promotion032TavernSysCache.getAll().stream().filter(config -> config.getStar() == 0 && config.getTurns()
                == promotionControlService.getControl(thisPromotionType()).getTurns()).collect(Collectors.toList());
        if (configs.isEmpty())
            return;

        Promotion032Tavern promotion032Tavern = getPromotionInfo(event.getRid());

        //完成了所有非0的其他任务，星级未0的时候代表完成了其他所有任务
        if (promotion032Tavern.getRewardMap().size() == promotion032TavernSysCache.getAll().size() - 1) {
            int count = promotion032Tavern.getCountMap().getOrDefault(configs.get(0).getIdx(), 0);
            promotion032Tavern.getCountMap().put(configs.get(0).getIdx(), count + 1);
            updatePromotion(promotion032Tavern);
        }

    }
}
