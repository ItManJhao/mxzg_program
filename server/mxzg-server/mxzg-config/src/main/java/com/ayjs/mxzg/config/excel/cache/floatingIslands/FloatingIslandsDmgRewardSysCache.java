package com.ayjs.mxzg.config.excel.cache.floatingIslands;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.floatingIslands.CFloatingIslandsDmgReward;
import org.springframework.stereotype.Repository;

/**
 * @Author: CWJ
 * @Date: 2020/6/30
 **/
@Repository
public class FloatingIslandsDmgRewardSysCache extends BaseExcelCache<CFloatingIslandsDmgReward> {
    @Override
    public String getFileName() {
        return "floatingislandsdmgreward";
    }

}
