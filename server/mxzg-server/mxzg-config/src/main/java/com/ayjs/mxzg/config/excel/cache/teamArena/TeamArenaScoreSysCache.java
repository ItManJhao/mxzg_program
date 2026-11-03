package com.ayjs.mxzg.config.excel.cache.teamArena;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.teamArena.CTeamArenaScore;
import lombok.Getter;
import org.springframework.stereotype.Component;

import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;


@Component
public class TeamArenaScoreSysCache extends BaseExcelCache<CTeamArenaScore> {

    @Getter
    private List<CTeamArenaScore> minusSortList;

    @Override
    protected void loadAfterReady() {
        minusSortList = getAll().stream().sorted(Comparator.comparingInt(CTeamArenaScore::getMinus)).collect(Collectors.toList());
    }

    @Override
    public String getFileName() {
        return "teamarenascore";
    }


}