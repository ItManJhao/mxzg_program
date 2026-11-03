package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CTopMatchFirstPlayReward;
import org.springframework.stereotype.Component;

/**
 * 段位赛挑战奖励
 */
@Component
public class TopMatchFirstPlayRewardSysCache extends BaseExcelCache<CTopMatchFirstPlayReward> {

    @Override
    public String getFileName() {
        return "topmatchfirstplayreward";
    }
}
