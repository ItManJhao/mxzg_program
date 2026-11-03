package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CBattleType;
import org.springframework.stereotype.Component;

/**
 * 战斗类型
 */
@Component
public class BattleTypeSysCache extends BaseExcelCache<CBattleType> {
    @Override
    public String getFileName() {
        return "battletype";
    }
}
