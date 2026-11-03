package com.ayjs.mxzg.config.excel.cache.promotion093;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion093.CPromotion093Grid;
import lombok.Getter;
import org.springframework.stereotype.Component;

/**
 * @Author: CWJ
 * @Date: 2021/3/22
 **/
@Component
public class Promotion093GridSysCache extends BaseExcelCache<CPromotion093Grid> {

    @Getter
    private int max;
    @Getter
    private int start;

    @Override
    protected void loadAfterReady() {
        max = getAll().stream().mapToInt(CPromotion093Grid::getIdx).max().getAsInt();
        start = getAll().stream().mapToInt(CPromotion093Grid::getIdx).min().getAsInt();
    }

    public CPromotion093Grid getByPoint(int point) {
        return getById(Math.min(max, point));
    }

    @Override
    public String getFileName() {
        return "promotion093grid";
    }
}
