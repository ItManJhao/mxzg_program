package com.ayjs.mxzg.gameserver.module.promotionNew.service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion031PvpWinsSysCache;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.Promotion031ArenaDao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion031Arena;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.pvp.event.PvpEndEvent;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * @Author: CWJ
 * @Date: 2019/10/24
 **/
@Service
@Observer
public class Promotion031ArenaService extends BasePromotionService<Promotion031Arena> {

    @Autowired
    private Promotion031ArenaDao promotion031ArenaDao;
    @Autowired
    private Promotion031PvpWinsSysCache promotion031PvpWinsSysCache;

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.JING_JI_ZHI_DIAN;
    }

    @Override
    public IRepository<Promotion031Arena> getRepository() {
        return promotion031ArenaDao;
    }

    @Override
    protected void resetOnNewTurns(Promotion031Arena promotion, PromotionControl control) {
        promotion.setWinCount(0);
        promotion.getRewardRecord().clear();
    }

    @Subscribe
    public void arenaVictory(PvpEndEvent event) {
        if (!promotionControlService.canRecordPromotionData(event.getRid(), thisPromotionType())) {
            return;
        }
        //家立说无论输赢都加1
        /*
        if(!event.isWin()) {
        	return;
        }*/
        Promotion031Arena promotionInfo = getPromotionInfo(event.getRid());
        promotionInfo.setWinCount(promotionInfo.getWinCount() + 1);
        updatePromotion(promotionInfo);
    }
}
