package com.ayjs.mxzg.gameserver.module.limitBuy.service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.config.excel.cache.PromotionLimitedSetPlaneWarSysCache;
import com.ayjs.mxzg.config.excel.entity.CPromotionLimitedSetPlaneWar;
import com.ayjs.mxzg.gameserver.module.limitBuy.domain.LimitProduction;
import com.ayjs.mxzg.gameserver.module.planewar.event.PlaneWarPassEvent;
import com.ayjs.mxzg.gameserver.module.recharge.constant.BuyGemType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2019/10/30
 **/
@Service
@Observer
public class PlaneWarLimitProductionService extends LimitProductionService {

    @Autowired
    protected PromotionLimitedSetPlaneWarSysCache promotionLimitedSetPlaneWarSysCache;

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void passChapter(PlaneWarPassEvent event) {
        long rid = event.getRid();

        if (!isOpen(rid)) {
            return;
        }

        int now = DateTimeUtil.currentSecond();
        List<LimitProduction> list = new ArrayList<>();
        CPromotionLimitedSetPlaneWar config = promotionLimitedSetPlaneWarSysCache.getByElemAndLv(event.getElement(), event.getLevel());
        if (config != null) {
            LimitProduction entity = updateCount(rid, now, config.getIdx(), config.getLimit_time());
            list.add(entity);
            sendData(event.getRid());
        }
    }

    @Override
    public BuyGemType buyGemType() {
        return BuyGemType.PLANE_WAR_LIMIT;
    }

}
