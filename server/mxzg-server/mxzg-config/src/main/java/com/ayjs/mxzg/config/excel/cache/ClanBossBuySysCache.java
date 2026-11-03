package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CClanBossBuy;
import org.springframework.stereotype.Component;

@Component
public class ClanBossBuySysCache extends BaseExcelCache<CClanBossBuy> {

    @Override
    public String getFileName() {
        return "clanbossbuy";
    }
}
