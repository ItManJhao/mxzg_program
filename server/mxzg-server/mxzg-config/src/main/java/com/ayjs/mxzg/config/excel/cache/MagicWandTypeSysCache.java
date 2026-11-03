package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CMagicWandType;
import org.springframework.stereotype.Component;

@Component
public class MagicWandTypeSysCache extends BaseExcelCache<CMagicWandType> {
    @Override
    public String getFileName() {
        return "magicwandtype";
    }
}
