package com.ayjs.mxzg.config.excel.cache.promotion;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotionItemRetrieve;
import org.springframework.stereotype.Component;

/**
 * 活动道具回收
 * @author hyx
 */
@Component
public class PromotionItemRetrieveSysCache extends BaseExcelCache<CPromotionItemRetrieve> {

    @Override
    public String getFileName() {
        return "promotionitemretrieve";
    }
}
