package com.ayjs.mxzg.config.excel.cache.teamArena;


import com.ayjs.mxzg.common.excel.ExcelDictionaryCache;
import lombok.Getter;
import org.springframework.stereotype.Component;

import java.util.Map;


@Component
@Getter
public class TeamArenaConst extends ExcelDictionaryCache {

    private int teamArenaInitialTimes;
    private int teamArenaTimesMax;
    private int teamArenaTimesGetTime;

    @Override
    protected void loadSpecialDictionary(Map<String, ? extends IDictionaryStruct> map) {
        teamArenaInitialTimes = parseInt(map, "team_arena_initial_times");
        teamArenaTimesMax = parseInt(map, "team_arena_times_max");
        teamArenaTimesGetTime = parseInt(map, "team_arena_times_get_time");
    }
}