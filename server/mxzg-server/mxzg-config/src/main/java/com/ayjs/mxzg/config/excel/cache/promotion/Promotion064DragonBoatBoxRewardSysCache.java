package com.ayjs.mxzg.config.excel.cache.promotion;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion064DragonBoatBoxReward;
import org.springframework.stereotype.Component;

/**
 * 龙舟
 * @author hyx
 */
@Component
public class Promotion064DragonBoatBoxRewardSysCache extends BaseExcelCache<CPromotion064DragonBoatBoxReward> {

    @Override
    public String getFileName() {
        return "promotiondragonboatboxreward";
    }
}
