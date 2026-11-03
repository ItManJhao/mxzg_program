package com.ayjs.mxzg.config.excel.cache.floatingIslands;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.floatingIslands.CFloatingIslandsTime;
import org.springframework.stereotype.Repository;

/**
 * @Author: CWJ
 * @Date: 2020/6/30
 **/
@Repository
public class FloatingIslandsTimeSysCache extends BaseExcelCache<CFloatingIslandsTime> {
    @Override
    public String getFileName() {
        return "floatingislandstime";
    }

    @Override
    protected void loadAfterReady() {
        //验证时间配置方式
        getAll().forEach(CFloatingIslandsTime::getIntervalTime);
    }
}
