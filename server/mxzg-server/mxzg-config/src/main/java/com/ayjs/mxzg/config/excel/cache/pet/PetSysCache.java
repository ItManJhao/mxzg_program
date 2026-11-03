package com.ayjs.mxzg.config.excel.cache.pet;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.pet.CPet;
import org.springframework.stereotype.Component;

/**
 * @author hyx
 */
@Component
public class PetSysCache extends BaseExcelCache<CPet> {

    @Override
    public String getFileName() {
        return "pet";
    }
}
