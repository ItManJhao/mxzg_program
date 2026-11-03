package com.ayjs.mxzg.config.excel.cache.promotion;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion064DragonBoatCard;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

/**
 * 龙舟翻牌配置表
 *
 * @author hyx
 */
@Component
public class Promotion064DragonBoatCardSysCache extends BaseExcelCache<CPromotion064DragonBoatCard> {

    private int maxTurns;

    @Override
    protected void loadAfterReady() {
        for (CPromotion064DragonBoatCard cPromotion064DragonBoatCard : getAll()) {
            if (cPromotion064DragonBoatCard.getTurns() > maxTurns) {
                maxTurns = cPromotion064DragonBoatCard.getTurns();
            }
        }
    }

    @Override
    public String getFileName() {
        return "promotiondragonboatcard";
    }

    public List<CPromotion064DragonBoatCard> getTurnsList(int turns) {
        List<CPromotion064DragonBoatCard> list = getAll().stream().filter(config -> config.getTurns() == turns &&
                config.getType() == 2).collect(Collectors.toList());
        return list;
    }

    public int getMaxTurns() {
        return maxTurns;
    }
}
