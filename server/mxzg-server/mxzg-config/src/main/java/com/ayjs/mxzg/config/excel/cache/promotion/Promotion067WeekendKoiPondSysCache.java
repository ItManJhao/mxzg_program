package com.ayjs.mxzg.config.excel.cache.promotion;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion067WeekendKoiPond;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;

/**
 * @author hyx
 */
@Component
public class Promotion067WeekendKoiPondSysCache extends BaseExcelCache<CPromotion067WeekendKoiPond> {

    private Map<Integer, List<CPromotion067WeekendKoiPond>> map;

    @Override
    protected void loadAfterReady() {
        this.map = this.fillListMap(CPromotion067WeekendKoiPond::getPond_type);
    }

    @Override
    public String getFileName() {
        return "promotionweekendkoipond";
    }

    public List<CPromotion067WeekendKoiPond> getPond(int pondType) {
        List<CPromotion067WeekendKoiPond> list = map.get(pondType);
        ConfigAsserts.notNull(list, () -> String.format("周末锦鲤promotino067WeekendKoiPong奖池数据不存在奖池类型{%s}", pondType));
        return list;
    }

}
