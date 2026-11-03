package com.ayjs.mxzg.config.excel.cache.reiki;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.reiki.CReikiEquipSuit;
import org.springframework.stereotype.Component;

/**
 * @author hyx
 */
@Component
public class ReikiEquipSuitSysCache extends BaseExcelCache<CReikiEquipSuit> {

    @Override
    public String getFileName() {
        return "reikiequipsuit";
    }
}
