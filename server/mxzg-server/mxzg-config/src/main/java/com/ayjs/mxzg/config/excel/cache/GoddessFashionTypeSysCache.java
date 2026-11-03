package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CGoddessFashionType;
import org.springframework.stereotype.Component;

/***
 * 羁绊皮肤
 */
@Component
public class GoddessFashionTypeSysCache extends BaseExcelCache<CGoddessFashionType> {

    @Override
    public String getFileName() {
        return "goddessfashiontype";
    }

    @Override
    protected void loadAfterReady() {
        super.loadAfterReady();
    }
}