package com.ayjs.mxzg.gameserver.module.limitBuy.service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.config.excel.cache.PromotionLimitedSetLevelSysCache;
import com.ayjs.mxzg.config.excel.entity.CPromotionLimitedSetLevel;
import com.ayjs.mxzg.gameserver.module.limitBuy.domain.LimitProduction;
import com.ayjs.mxzg.gameserver.module.recharge.constant.BuyGemType;
import com.ayjs.mxzg.gameserver.module.role.event.RoleLvUpEvent;
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
public class RoleLevelLimitProductionService extends LimitProductionService {

    @Autowired
    protected PromotionLimitedSetLevelSysCache promotionLimitedSetLevelSysCache;

    @Subscribe
    public void roleLvUp(RoleLvUpEvent event) {
        long rid = event.getRid();

        if (!isOpen(rid)) {
            return;
        }

        int now = DateTimeUtil.currentSecond();
        List<LimitProduction> list = new ArrayList<>();
        //找出等级区间所在物品
        for (int level = event.getOldLv() + 1; level <= event.getNewLv(); level++) {
            CPromotionLimitedSetLevel config = promotionLimitedSetLevelSysCache.getByLevel(level);
            if (config != null) {
                LimitProduction entity = updateCount(rid, now, config.getIdx(), config.getLast_time());
                list.add(entity);
                sendData(event.getRid());
            }
        }
    }

    @Override
    public BuyGemType buyGemType() {
        return BuyGemType.ROLE_LEVEL_GIFT;
    }

}
