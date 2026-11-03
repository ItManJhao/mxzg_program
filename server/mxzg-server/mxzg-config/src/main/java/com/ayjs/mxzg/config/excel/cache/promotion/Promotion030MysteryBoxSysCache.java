package com.ayjs.mxzg.config.excel.cache.promotion;


import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion030MysteryBox;

@Component
public class Promotion030MysteryBoxSysCache extends BaseExcelCache<CPromotion030MysteryBox> implements ILoopingPromotionCache {

    private Map<Integer, List<CPromotion030MysteryBox>> configMap;

    private int maxTurns;

    @Override
    public void loadAfterReady() {
        configMap = this.fillListMap(CPromotion030MysteryBox::getTurns);
        for(Integer turns : configMap.keySet()) {
			if(turns > maxTurns) {
				maxTurns = turns;
			}
		}
    }

    public List<CPromotion030MysteryBox> getConfigsByTurn(int turns) {
        return configMap.get(turns);
    }

    @Override
    public String getFileName() {
        return "promotionmysterybox";
    }

	@Override
	public int getMaxTurns() {
		return maxTurns;
	}

}