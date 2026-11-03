package com.ayjs.mxzg.config.excel.cache.planewar;

import com.ayjs.mxzg.common.excel.ExcelDictionaryCache;
import lombok.Getter;
import org.springframework.stereotype.Component;

import java.util.Map;

/**
 * @Author: CWJ
 * @Date: 2020/9/15
 **/
@Component
public class PlaneWarConst extends ExcelDictionaryCache {
    @Getter
    private int maxBuyCount = 2;
    @Getter
    private int freeChallengeCount = 10;

    @Override
    protected void loadSpecialDictionary(Map<String, ? extends IDictionaryStruct> map) {
        maxBuyCount = parseInt(map, "plane_war_max_buy_count");
        freeChallengeCount = parseInt(map, "plane_war_free_challenge_count");
    }
}
