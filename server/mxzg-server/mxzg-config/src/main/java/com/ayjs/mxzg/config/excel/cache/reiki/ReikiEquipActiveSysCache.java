package com.ayjs.mxzg.config.excel.cache.reiki;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.reiki.CReikiEquipActive;
import org.springframework.stereotype.Component;

/**
 *
 * @author hyx
 */
@Component
public class ReikiEquipActiveSysCache extends BaseExcelCache<CReikiEquipActive> {

    @Override
    public String getFileName() {
        return "reikiequipactive";
    }
}
