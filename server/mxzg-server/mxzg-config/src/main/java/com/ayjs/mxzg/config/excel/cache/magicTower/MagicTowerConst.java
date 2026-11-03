package com.ayjs.mxzg.config.excel.cache.magicTower;

import com.ayjs.mxzg.common.excel.ExcelDictionaryCache;
import lombok.Getter;
import org.springframework.stereotype.Component;

import java.util.Map;

/**
 * @Author: CWJ
 * @Date: 2020/3/23
 **/
@Component
@Getter
public class MagicTowerConst extends ExcelDictionaryCache {

    /***
     * 每日免费次数
     */
    private int magicTowerDailyFreeTimes = 0;//120;
    /***
     * 开启天数
     */
    private int magicTowerOpenDay = 0;//120;

    @Override
    public void loadSpecialDictionary(Map<String, ? extends IDictionaryStruct> map) {
        magicTowerDailyFreeTimes = Integer.valueOf(map.get("magic_tower_daily_free_times").getValue());
        magicTowerOpenDay = Integer.valueOf(map.get("magic_tower_open_day").getValue());
    }

}
