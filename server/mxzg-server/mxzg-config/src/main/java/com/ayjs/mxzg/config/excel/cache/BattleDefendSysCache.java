package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CBattleDefend;
import org.springframework.stereotype.Component;

/**
 * 防御系数
 */
@Component
public class BattleDefendSysCache extends BaseExcelCache<CBattleDefend> {

    @Override
    public String getFileName() {
        return "battledefend";
    }
}
