package com.ayjs.mxzg.config.excel.cache.teamArena;


import com.ayjs.mxzg.common.excel.ExcelDictionaryCache;

import java.util.Map;


//@Component
//@Getter
public class TeamArenaRedConst extends ExcelDictionaryCache {

    /**邀请小红点*/
    private int invite_red = 1013800;
    /**申请小红点*/
    private int apply_red = 1014100;
    private int challenge_red = 1015800;
    private int reward_red = 1014300;

    @Override
    protected void loadSpecialDictionary(Map<String, ? extends IDictionaryStruct> map) {
        invite_red = parseInt(map, "invite_red");
        apply_red = parseInt(map, "apply_red");
        challenge_red = parseInt(map, "challenge_red");
        reward_red = parseInt(map, "reward_red");
    }
}