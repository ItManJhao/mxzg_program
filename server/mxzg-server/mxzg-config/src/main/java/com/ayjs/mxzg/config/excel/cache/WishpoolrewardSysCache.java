package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.config.excel.entity.CWishpoolreward;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;

@Component
public class WishpoolrewardSysCache extends BaseExcelCache<CWishpoolreward> {

    private Map<IndexKey, List<CWishpoolreward>> configMap = new HashMap<>();

    @Override
    public String getFileName() {
        return "wishpoolreward";
    }

    @Override
    protected void loadAfterReady() {
        Map<IndexKey, List<CWishpoolreward>> configMapTemp = new HashMap<>();
        for (CWishpoolreward wishpoolreward : getAll()) {
            List<CWishpoolreward> wishpoolrewardList2 = configMapTemp.computeIfAbsent(buildKey(wishpoolreward), key -> new ArrayList<>());
            wishpoolrewardList2.add(wishpoolreward);
        }
        configMap = configMapTemp;
    }

    public List<CWishpoolreward> getConfigByTypeAndLv(int type, int lv) {
        Optional<IndexKey> optional = configMap.keySet().stream().filter(indexKey -> type == indexKey.type && lv >= indexKey.minLv && lv <= indexKey.maxLv).findFirst();
        Asserts.isTrue(optional.isPresent(), String.format("该类型{%s}与该等级(%s)的配置集合不存在!", type, lv));
        return configMap.get(optional.get());
    }

    public IndexKey buildKey(CWishpoolreward config) {
        IndexKey key = new IndexKey();
        key.type = config.getWishpool_type();
        key.maxLv = config.getMax_lv();
        key.minLv = config.getMin_lv();
        return key;
    }

    private class IndexKey {
        private int type;
        private int maxLv;
        private int minLv;

        @Override
        public boolean equals(Object o) {
            if (this == o) return true;
            if (o == null || getClass() != o.getClass()) return false;
            IndexKey indexKey = (IndexKey) o;
            return type == indexKey.type &&
                    maxLv == indexKey.maxLv &&
                    minLv == indexKey.minLv;
        }

        @Override
        public int hashCode() {
            return Objects.hash(type, maxLv, minLv);
        }

    }

}
