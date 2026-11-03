package com.ayjs.mxzg.config.excel.cache.occupation;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.occupation.COccupation;
import org.springframework.stereotype.Component;

@Component
public class OccupationSysCache extends BaseExcelCache<COccupation> {

    @Override
    public String getFileName() {
        return "crusadegroupoccupation";
    }
}
