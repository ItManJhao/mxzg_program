package com.ayjs.mxzg.config.excel.cache.astrolabe;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.astrolabe.CAstrolabeElement;
import org.springframework.stereotype.Component;

/**
 * 星盘
 *
 * @Author: CWJ
 * @Date: 2020/4/28
 **/
@Component
public class AstrolabeElementSysCache extends BaseExcelCache<CAstrolabeElement> {

    @Override
    public String getFileName() {
        return "astrolabeelement";
    }
}
