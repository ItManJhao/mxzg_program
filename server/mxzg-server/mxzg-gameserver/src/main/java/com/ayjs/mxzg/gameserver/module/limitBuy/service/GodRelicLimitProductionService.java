package com.ayjs.mxzg.gameserver.module.limitBuy.service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.PromotionLimitedSetGodRelicSysCache;
import com.ayjs.mxzg.config.excel.entity.CPromotionLimitedSetGodRelic;
import com.ayjs.mxzg.gameserver.module.godRelic.event.GodRelicPassEvent;
import com.ayjs.mxzg.gameserver.module.limitBuy.domain.LimitProduction;
import com.ayjs.mxzg.gameserver.module.recharge.constant.BuyGemType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2019/10/30
 **/
@Service
@Observer
public class GodRelicLimitProductionService extends LimitProductionService {

    @Autowired
    protected PromotionLimitedSetGodRelicSysCache promotionLimitedSetGodRelicSysCache;

    @Subscribe
    public void passChapter(GodRelicPassEvent event) {
        long rid = event.getRid();
        if (!isOpen(rid)) {
            return;
        }

        int now = DateTimeUtil.currentSecond();
        CPromotionLimitedSetGodRelic config = promotionLimitedSetGodRelicSysCache.getByGodRelic(event.getIdx());
        if (config != null) {
            LimitProduction entity = load(rid, config.getIdx());
            if (entity.getBuyCount() + entity.getCount() >= config.getLimit_num()) {
                return;
            }
            if (entity.getExpireTime() > now) {
                entity.setCount(entity.getCount() + 1);
            } else {
                entity.setCount(1);
            }
            entity.setExpireTime(now + config.getLast_time());
            limitProductionDao.update(entity);
            sendData(event.getRid());
        }
    }

    @Override
    protected LimitProduction load(long rid, int idx) {

        LimitProduction entity = get(rid, idx);
        if (entity == null) {
            entity = new LimitProduction();
            entity.setRid(rid);
            entity.setBuyGemIdx(idx);
            entity.setBuyTime(LocalDate.now());
            limitProductionDao.add(entity);
        } else {
            if (TimeDateUtil.getCurrentTimeInt() > entity.getExpireTime()) {
                entity.setCount(0);
                entity.setBuyCount(entity.getBuyCount() + 1);
                limitProductionDao.update(entity);
            }

        }
        return entity;

    }

    @Override
    public BuyGemType buyGemType() {
        return BuyGemType.GOD_RELIC;
    }

}
