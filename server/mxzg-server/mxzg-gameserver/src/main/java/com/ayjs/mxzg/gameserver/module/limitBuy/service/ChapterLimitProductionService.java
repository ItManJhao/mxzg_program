package com.ayjs.mxzg.gameserver.module.limitBuy.service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.config.excel.cache.PromotionLimitedSetChapterSysCache;
import com.ayjs.mxzg.config.excel.entity.CPromotionLimitedSetChapter;
import com.ayjs.mxzg.gameserver.module.battle.event.ChapterPassEvent;
import com.ayjs.mxzg.gameserver.module.limitBuy.domain.LimitProduction;
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
public class ChapterLimitProductionService extends LimitProductionService {

    @Autowired
    protected PromotionLimitedSetChapterSysCache promotionLimitedSetChapterSysCache;

    @Subscribe
    public void passChapter(ChapterPassEvent event) {
        long rid = event.getRid();

        if (!isOpen(rid)) {
            return;
        }

        int now = DateTimeUtil.currentSecond();
        List<LimitProduction> list = new ArrayList<>();
        CPromotionLimitedSetChapter config = promotionLimitedSetChapterSysCache.getByLevel(event.getMissionId());
        if (config != null) {
            LimitProduction entity = updateCount(rid, now, config.getIdx(), config.getLast_time());
            list.add(entity);
            sendData(event.getRid());
        }
    }

    @Override
    public BuyGemType buyGemType() {
        return BuyGemType.CHAPTER_GIFT;
    }

}
