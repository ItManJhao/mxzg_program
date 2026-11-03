package com.ayjs.mxzg.config.excel.cache;

import java.util.Comparator;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CLadderFightTimes;

import lombok.Getter;

/**
 * @Author: CWJ
 * @Date: 2020/1/3
 **/
@Component
public class LadderFightTimesSysCache extends BaseExcelCache<CLadderFightTimes> {

    @Getter
    private int maxTimes;

    @Override
    protected void loadAfterReady() {
        maxTimes = getAll().stream().max(Comparator.comparingInt(CLadderFightTimes::getBuy_times)).get().getBuy_times();
    }

    @Override
    public String getFileName() {
        return "serverladderfighttimes";
    }
}
