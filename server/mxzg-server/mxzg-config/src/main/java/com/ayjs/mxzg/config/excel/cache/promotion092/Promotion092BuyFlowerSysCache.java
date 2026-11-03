package com.ayjs.mxzg.config.excel.cache.promotion092;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion092.CPromotion092BuyFlower;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Author: CWJ
 * @Date: 2020/12/14
 **/
@Component
public class Promotion092BuyFlowerSysCache extends BaseExcelCache<CPromotion092BuyFlower> {

    @Override
    protected void loadAfterReady() {
        getAll().sort(Comparator.comparingInt(CPromotion092BuyFlower::getCount_min));
    }

    @Override
    public String getFileName() {
        return "promotion092buyflower";
    }

    public Map<CPromotion092BuyFlower, Integer> getByCount(int countMin, int countMax) {
        return getByCount(getAll(), countMin, countMax);
    }

    public Map<CPromotion092BuyFlower, Integer> getByCount(List<CPromotion092BuyFlower> configs, int countMin, int countMax) {
        Map<CPromotion092BuyFlower, Integer> res = new HashMap<>();
        for (CPromotion092BuyFlower config : configs) {
            if (config.getCount_min() > countMax || countMax - countMin == 0) {
                break;
            }
            if (config.getCount_max() > countMin) {
                res.put(config, Math.min(config.getCount_max() - countMin, countMax - countMin));
                countMin += res.get(config);
            }
        }
        return res;
    }

    public static void main(String[] args) {
        Promotion092BuyFlowerSysCache cache = new Promotion092BuyFlowerSysCache();
        List<CPromotion092BuyFlower> all = new ArrayList<>();
        CPromotion092BuyFlower c = new CPromotion092BuyFlower();
        c.setIdx(1);
        c.setCount_min(0);
        c.setCount_max(30);
        all.add(c);
        CPromotion092BuyFlower c1 = new CPromotion092BuyFlower();
        c1.setIdx(2);
        c1.setCount_min(30);
        c1.setCount_max(60);
        all.add(c1);
        CPromotion092BuyFlower c2 = new CPromotion092BuyFlower();
        c2.setIdx(3);
        c2.setCount_min(60);
        c2.setCount_max(100);
        all.add(c2);

        Map<CPromotion092BuyFlower, Integer> result = cache.getByCount(all, 30, 61);
        result.forEach((key, value) -> System.out.println(key.getIdx() + "-" + value));

    }
}
