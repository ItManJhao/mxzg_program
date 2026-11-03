package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CHeroAwaken;
import org.springframework.stereotype.Component;

@Component
public class HeroAwakenSysCache extends BaseExcelCache<CHeroAwaken> {

    @Override
    public String getFileName() {
        return "heroawaken";
    }

}