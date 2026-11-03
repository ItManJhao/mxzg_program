package com.ayjs.mxzg.config.excel.cache.shenbin;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.shenbin.CShenBinResolve;
import org.springframework.stereotype.Component;

@Component
public class ShenBinResolveSysCache extends BaseExcelCache<CShenBinResolve> {

    @Override
    public String getFileName() {
        return "crusadegroupshenbinresolve";
    }

}
