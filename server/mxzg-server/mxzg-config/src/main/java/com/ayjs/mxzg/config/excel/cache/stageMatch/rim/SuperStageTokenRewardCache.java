package com.ayjs.mxzg.config.excel.cache.stageMatch.rim;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.stageMatch.rim.CSuperStageTokenReward;
import org.springframework.stereotype.Component;

/**
 * @Author: CWJ
 * @Date: 2020/6/17
 **/
@Component
public class SuperStageTokenRewardCache extends BaseExcelCache<CSuperStageTokenReward> {
    @Override
    public String getFileName() {
        return "superstagetokenreward";
    }
}
