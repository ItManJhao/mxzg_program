package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.config.excel.entity.CWishPoolNeed;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.Map;

@Component
public class WishpoolneedSysCache extends BaseExcelCache<CWishPoolNeed> {

    private Map<Integer, Map<Integer, CWishPoolNeed>> poolNeedMap = new HashMap<>();

    @Override
    public String getFileName() {
        return "wishpoolneed";
    }


    @Override
    protected void loadAfterReady() {
        Map<Integer, Map<Integer, CWishPoolNeed>> poolNeedMapTemp = new HashMap<>();
        for (CWishPoolNeed wishPoolNeed : getAll()) {
            Map<Integer, CWishPoolNeed> timesMap = poolNeedMapTemp.computeIfAbsent(wishPoolNeed.getWishpool_type(), k -> new HashMap<>());
            timesMap.put(wishPoolNeed.getPlay_time(), wishPoolNeed);
        }
        poolNeedMap = poolNeedMapTemp;
    }

    public CWishPoolNeed getWishPoolNeedByTypeAndTime(int type, int times) {
        Map<Integer, CWishPoolNeed> wishPoolNeedMap = poolNeedMap.get(type);
        ConfigAsserts.notNull(wishPoolNeedMap,
                () -> String.format("CWishPoolNeed配置数据不存在type:{%s},times:{%s}", type, times));
        CWishPoolNeed wishPoolNeed = wishPoolNeedMap.get(times);
        ConfigAsserts.notNull(wishPoolNeed,
                () -> String.format("CWishPoolNeed配置数据不存在type:{%s},times:{%s}", type, times));
        return wishPoolNeed;
    }
}