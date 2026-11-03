package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CSuperStageRank;
import org.springframework.stereotype.Component;

/**
 * 段位赛等级表
 */
@Component
public class SuperStageRankSysCache extends BaseExcelCache<CSuperStageRank> {

    @Override
    public String getFileName() {
        return "superstagerank";
    }

}
