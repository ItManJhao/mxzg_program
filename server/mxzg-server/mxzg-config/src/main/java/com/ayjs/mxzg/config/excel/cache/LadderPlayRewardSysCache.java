package com.ayjs.mxzg.config.excel.cache;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CLadderPlayReward;

/**
 * @Author: CWJ
 * @Date: 2020/1/3
 **/
@Component
public class LadderPlayRewardSysCache extends BaseExcelCache<CLadderPlayReward> {

    @Override
    public String getFileName() {
        return "serverladderplayreward";
    }
}
