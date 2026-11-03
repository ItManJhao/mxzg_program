package com.ayjs.mxzg.config.excel.cache.shenbin;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.shenbin.CShenBin;
import org.springframework.stereotype.Component;

import java.util.Map;

@Component
public class ShenBinSysCache extends BaseExcelCache<CShenBin> {
    
    private Map<Integer, CShenBin> shenBinMap;

    @Override
    public String getFileName() {
        return "crusadegroupshenbin";
    }


    @Override
    protected void loadAfterReady() {
        this.shenBinMap = fillOneLayerMap(CShenBin::getSb_id);
    }

    /**
     * 根据神兵id获取神兵
     *
     * @param sb_id
     * @return
     */
    public CShenBin getCShenBinTemplate(int sb_id) {
        return shenBinMap.get(sb_id);
    }
}
