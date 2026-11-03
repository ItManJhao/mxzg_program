package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CHeroSpace;
import lombok.Getter;
import org.springframework.stereotype.Component;

import java.util.Comparator;
import java.util.Optional;

@Component
public class HeroSpaceSysCache extends BaseExcelCache<CHeroSpace> {
    /**
     * 最大购买次数
     */
    @Getter
    private int maxTimes;

    @Override
    public String getFileName() {
        return "herospace";
    }

    @Override
    protected void loadAfterReady() {
        Optional<CHeroSpace> max = getAll().stream().max(Comparator.comparing(CHeroSpace::getTimes));
        if (max.isPresent()) {
            maxTimes = max.get().getTimes();
        }
    }
}
