package com.ayjs.mxzg.config.excel.cache;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CDreamLandFirstReward;

/**
 * @Author: CWJ
 * @Date: 2019/12/11
 **/
@Component
public class DreamlandFirstRewardSysCache extends BaseExcelCache<CDreamLandFirstReward> {

    @Override
    public String getFileName() {
        return "infinitefirstreward";
    }
}
