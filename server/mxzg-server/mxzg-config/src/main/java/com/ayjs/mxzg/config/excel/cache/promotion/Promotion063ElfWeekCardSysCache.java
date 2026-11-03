package com.ayjs.mxzg.config.excel.cache.promotion;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion063ElfWeekCard;
import org.springframework.stereotype.Component;

/**
 * 精灵周卡
 *
 * @author hyx
 */
@Component
public class Promotion063ElfWeekCardSysCache extends BaseExcelCache<CPromotion063ElfWeekCard> implements ILoopingPromotionCache {

    private int maxTurns;

    @Override
    protected void loadAfterReady() {
        for (CPromotion063ElfWeekCard config : this.getAll()) {
            if (maxTurns < config.getTurns()) {
                maxTurns = config.getTurns();
            }
        }
    }

    @Override
    public String getFileName() {
        return "promotionelfweekcard";
    }

    @Override
    public int getMaxTurns() {
        return maxTurns;
    }

}
