package com.ayjs.mxzg.config.excel.cache.teamArena;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.teamArena.CTeamArena;
import org.springframework.stereotype.Component;


@Component
public class TeamArenaSysCache extends BaseExcelCache<CTeamArena> {

    @Override
    public String getFileName() {
        return "teamarena";
    }


}