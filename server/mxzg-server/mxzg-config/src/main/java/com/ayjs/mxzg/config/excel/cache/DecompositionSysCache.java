package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CDecompositionItem;
import org.springframework.stereotype.Component;

@Component
public class DecompositionSysCache extends BaseExcelCache<CDecompositionItem> {

    @Override
    public String getFileName() {
        return "decompositionitem";
    }
}
