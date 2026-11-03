package com.ayjs.mxzg.config.excel.cache.tweakCube;

import com.ayjs.mxzg.common.excel.ExcelDictionaryCache;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.google.common.collect.ImmutableList;
import lombok.Getter;
import org.springframework.stereotype.Component;

import java.util.Map;

/**
 * @Author: CWJ
 * @Date: 2020/9/8
 **/
@Component
public class TweakCubeConst extends ExcelDictionaryCache {

    @Getter
    private int tweakCubeTrenchRemoveCD = 60;
    @Getter
    private int tweakCubeRankHeroNum = 6;
    @Getter
    private ImmutableList<ImmutableThing> tweakCubeClearCdCost;

    @Override
    protected void loadSpecialDictionary(Map<String, ? extends IDictionaryStruct> map) {
        //槽位cd
        tweakCubeTrenchRemoveCD = parseInt(map, "tweak_cube_trench_cd");
        //供奉英雄数量
        tweakCubeRankHeroNum = parseInt(map, "tweak_cube_rank_hero_num");

        //供奉英雄数量
        tweakCubeClearCdCost = ImmutableThingUtil.fromJson(map.get("tweak_cube_clear_cd_cost").getValue());
    }
}
