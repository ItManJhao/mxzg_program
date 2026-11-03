package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CClergyPrivilege;
import org.springframework.stereotype.Component;

/**
 * 神职特权
 * @author hyx
 */
@Component
public class ClergyPrivilegeSysCache extends BaseExcelCache<CClergyPrivilege> {

    @Override
    public String getFileName() {
        return "clergyprivilege";
    }
}
