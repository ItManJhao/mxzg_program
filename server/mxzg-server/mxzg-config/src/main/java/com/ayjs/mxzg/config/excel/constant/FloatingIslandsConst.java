package com.ayjs.mxzg.config.excel.constant;

import com.ayjs.mxzg.common.excel.ExcelDictionaryCache;
import com.ayjs.mxzg.common.excel.ExcelDictionaryField;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.google.common.collect.ImmutableList;
import lombok.Getter;
import org.springframework.stereotype.Component;

import java.util.Map;

/**
 * @Author: CWJ
 * @Date: 2020/6/30
 **/
@Component
@Getter
public class FloatingIslandsConst extends ExcelDictionaryCache {

    private String battleName = 75407 + "";

    /**
     * 默认可挑战次数
     */
    @ExcelDictionaryField("floating_islands_init_challenge_count")
    private int floatingIslandsInitChallengeCount = 4;//12000;

    /**
     * 默认可挑战次数
     */
    @ExcelDictionaryField("floating_islands_challenge_reward")
    private ImmutableList<ImmutableThing> floatingIslandsChallengeReward;//12000;

    private int showCount = 50;

    @Override
    protected void loadSpecialDictionary(Map<String, ? extends IDictionaryStruct> map) {
        floatingIslandsChallengeReward = ImmutableThingUtil.fromJson(map.get("floating_islands_challenge_reward").getValue());
        floatingIslandsInitChallengeCount = parseInt(map, "floating_islands_init_challenge_count");
    }
}
