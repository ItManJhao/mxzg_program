package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CGoddessFashionSmelt;
import org.springframework.stereotype.Component;

/***
 * 皮肤熔炼配置
 */
@Component
public class GoddessFashionSmeltSysCache extends BaseExcelCache<CGoddessFashionSmelt> {

    @Override
    public String getFileName() {
        return "goddessfashionsmelt";
    }


}