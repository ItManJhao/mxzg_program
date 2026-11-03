package com.ayjs.mxzg.config.excel.cache.floatingIslands;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.floatingIslands.CFloatingIslandsBuyConsume;
import lombok.Getter;
import org.springframework.stereotype.Repository;

/**
 * @Author: CWJ
 * @Date: 2020/6/30
 **/
@Repository
public class FloatingIslandsBuyConsumeSysCache extends BaseExcelCache<CFloatingIslandsBuyConsume> {

    @Getter
    private int maxCount;

    @Override
    protected void loadAfterReady() {
        maxCount = getAll().stream().mapToInt(CFloatingIslandsBuyConsume::getIdx).max().getAsInt();
    }

    @Override
    public String getFileName() {
        return "floatingislandsbuyconsume";
    }
}
