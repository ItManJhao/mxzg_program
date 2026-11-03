package com.ayjs.mxzg.config.excel.cache.crusadegroup;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.crusadegroup.CCrusadeGroupBirthplace;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

/**
 * 讨伐团出生点
 */
@Slf4j
@Component
public class CrusadeGroupBirthplaceSysCache extends BaseExcelCache<CCrusadeGroupBirthplace> {

    @Override
    public String getFileName() {
        return "crusadegroupbirthplace";
    }


}
