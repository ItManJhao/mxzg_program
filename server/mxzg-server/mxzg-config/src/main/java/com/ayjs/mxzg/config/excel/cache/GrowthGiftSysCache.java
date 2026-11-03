package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CGrowthGift;
import org.springframework.stereotype.Component;

@Component
public class GrowthGiftSysCache extends BaseExcelCache<CGrowthGift> {
    @Override
    public String getFileName() {
        return "growthgift";
    }

    public CGrowthGift getGrowthGift(long recharge){
        int idx = 0;
        for(CGrowthGift cModel : getAll()){
            if(cModel.getNeed_recharge() <= recharge && idx < cModel.getIdx()){
                idx = cModel.getIdx();
            }
        }
        return getOrThrow(idx);
    }
}
