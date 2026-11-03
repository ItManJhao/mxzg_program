package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CLotteryType;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;

@Component
public class LotteryTypeSysCache extends BaseExcelCache<CLotteryType> {

    private Map<Integer, List<CLotteryType>> typeMap;

    @Override
    public String getFileName() {
        return "lotterytype";
    }

    @Override
    protected void loadAfterReady() {
        this.typeMap = this.fillListMap(CLotteryType::getLottery_type);
    }

    public List<CLotteryType> getByType(int type) {
        return typeMap.get(type);
    }
}