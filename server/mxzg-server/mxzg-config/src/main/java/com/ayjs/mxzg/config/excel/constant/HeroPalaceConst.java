/**
 *
 */
package com.ayjs.mxzg.config.excel.constant;

import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.ExcelDictionaryCache;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.google.common.collect.ImmutableList;

/**
 *
 */
@Component
public class HeroPalaceConst extends ExcelDictionaryCache {

    /***
     * 每日免费次数
     */
    public static ImmutableList<ImmutableThing> heroPalaceLikeReward;//120;

    @Override
    public void loadSpecialDictionary(Map<String, ? extends IDictionaryStruct> map) {
        heroPalaceLikeReward = ImmutableThingUtil.fromJson(map.get("hero_palace_like_reward").getValue());
    }

}
