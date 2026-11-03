/**
 *
 */
package com.ayjs.mxzg.config.excel.constant;

import com.ayjs.mxzg.common.excel.ExcelDictionaryCache;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.google.common.collect.ImmutableList;
import lombok.Getter;
import org.springframework.stereotype.Component;

import java.util.Map;

/**
 *
 */
@Getter
@Component
public class HeroEvolveConst extends ExcelDictionaryCache {
    /**
     * 进化所需星际
     */
    private int heroEvolveNeedStar = 10;

    /***
     * 进化回退消耗
     * @param map
     */
    private ImmutableList<ImmutableThing> evolveBackCost;


    @Override
    public void loadSpecialDictionary(Map<String, ? extends IDictionaryStruct> map) {
        heroEvolveNeedStar = Integer.valueOf(map.get("heroevo_need_herostar").getValue());
        evolveBackCost = ImmutableThingUtil.fromJson(map.get("heroevo_back_cost").getValue());
    }

}
