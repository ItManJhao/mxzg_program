package com.ayjs.mxzg.config.excel.cache;

import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CProphecyGuarantee;

/**
 * 先知随机保底机制
 */
@Component
public class ProphecyGuaranteeSysCache extends BaseExcelCache<CProphecyGuarantee> {

    private Map<Integer, CProphecyGuarantee> prophecyGuaranteeMap;

    @Override
    public String getFileName() {
        return "prophecyguarantee";
    }

    @Override
    protected void loadAfterReady() {
        this.prophecyGuaranteeMap = this.fillOneLayerMap(CProphecyGuarantee::getType);
    }

    public CProphecyGuarantee getCProphecyGuarantee(int type) {
        return prophecyGuaranteeMap.get(type);
    }
}
