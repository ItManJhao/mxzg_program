package com.ayjs.mxzg.config.excel.cache.astrolabe;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.astrolabe.CAstrolabe;
import org.springframework.stereotype.Component;

/**
 * 星盘
 *
 * @Author: CWJ
 * @Date: 2020/4/28
 **/
@Component
public class AstrolabeSysCache extends BaseExcelCache<CAstrolabe> {

    @Override
    public String getFileName() {
        return "astrolabe";
    }
}
