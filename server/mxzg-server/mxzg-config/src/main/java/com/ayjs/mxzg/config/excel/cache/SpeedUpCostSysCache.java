package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CSpeedUpCost;
import lombok.Getter;
import org.springframework.stereotype.Component;

@Component
public class SpeedUpCostSysCache extends BaseExcelCache<CSpeedUpCost> {

    @Getter
    private int maxTimes = 0;

    @Override
    public String getFileName() {
        return "speedupcost";
    }

    @Override
    protected void loadAfterReady() {
        maxTimes = getAll().stream().map(CSpeedUpCost::getTimes).max(Integer::compareTo).orElse(0);
    }
}