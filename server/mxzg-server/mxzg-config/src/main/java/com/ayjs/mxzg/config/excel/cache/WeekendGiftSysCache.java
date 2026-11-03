package com.ayjs.mxzg.config.excel.cache;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CWeekendGift;

/**
 * @Author: CWJ
 * @Date: 2020/3/21
 **/
@Component
public class WeekendGiftSysCache extends BaseExcelCache<CWeekendGift> {
    @Override
    public String getFileName() {
        return "weekendgift";
    }

    public CWeekendGift getByDays(int days) {
        return getAll().stream().filter(config -> config.getDays() == days).findFirst().orElse(null);
    }
}
