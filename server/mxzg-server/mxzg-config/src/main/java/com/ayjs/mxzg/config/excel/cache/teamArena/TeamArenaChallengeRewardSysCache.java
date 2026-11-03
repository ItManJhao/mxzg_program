package com.ayjs.mxzg.config.excel.cache.teamArena;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.teamArena.CTeamArenaChallengeReward;
import org.springframework.stereotype.Component;


@Component
public class TeamArenaChallengeRewardSysCache extends BaseExcelCache<CTeamArenaChallengeReward> {

    @Override
    public String getFileName() {
        return "teamarenachallengereward";
    }


}