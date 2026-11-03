package com.ayjs.mxzg.config.excel.cache.promotion;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion034Pve;
import com.ayjs.mxzg.config.struct.MonsterTeamCheck;
import com.google.common.collect.ImmutableList;
import org.springframework.stereotype.Component;

import java.util.Comparator;
import java.util.List;
import java.util.Map;

/**
 * 诸神之战模型
 *
 * @Author: CWJ
 * @Date: 2019/10/18
 **/
@Component
public class Promotion034PveSysCache extends BaseExcelCache<CPromotion034Pve> implements ILoopingPromotionCache, MonsterTeamCheck {

    private Map<Integer, List<CPromotion034Pve>> map;

    private int maxTurns;

    @Override
    public void loadAfterReady() {
        map = fillListMap(CPromotion034Pve::getTurns);
        maxTurns = this.getAll().stream().max(Comparator.comparingInt(CPromotion034Pve::getTurns)).get().getTurns();
    }

    @Override
    public String getFileName() {
        return "promotionpve";
    }

    public List<CPromotion034Pve> getConfigsByTurn(int turns) {
        return map.get(turns);
    }

    @Override
    public int getMaxTurns() {
        return maxTurns;
    }

    @Override
    public List<List<CPromotion034Pve>> getAllTeams() {
        return ImmutableList.copyOf(map.values());
    }
}
