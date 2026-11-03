package com.ayjs.mxzg.config.excel.cache.teamArena;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.teamArena.CTeamArenaRankReward;
import org.springframework.stereotype.Component;


@Component
public class TeamArenaRankRewardSysCache extends BaseExcelCache<CTeamArenaRankReward> {

    @Override
    public String getFileName() {
        return "teamarenarankreward";
    }


    public CTeamArenaRankReward getByRank(int rank) {
      return  getAll().stream().filter(config->config.getRank_low()<=rank&&config.getRank_up()>=rank).findFirst().orElse(null);
    }
}