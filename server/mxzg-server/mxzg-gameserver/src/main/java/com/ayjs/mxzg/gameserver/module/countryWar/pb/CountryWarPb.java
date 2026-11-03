package com.ayjs.mxzg.gameserver.module.countryWar.pb;

import com.ayjs.mxzg.common.util.time.LocalDateTimeUtil;
import com.ayjs.mxzg.config.excel.entity.countrywar.CCountryWarFlagMission;
import com.ayjs.mxzg.config.excel.entity.countrywar.CCountryWarMission;
import com.ayjs.mxzg.gameserver.module.countryWar.domain.CountryWar;
import com.ayjs.mxzg.gameserver.module.countryWar.domain.CountryWarScoreMission;
import com.ayjs.mxzg.message.module.countryWar.dto.CountryWarLogInfo;
import com.ayjs.mxzg.protocol.CountryWarGMsg;
import com.ayjs.mxzg.protocol.ObjectGMsg;
import org.springframework.stereotype.Service;

/**
 * @Author: CWJ
 * @Date: 2021/4/23
 **/
@Service
public class CountryWarPb {

    public ObjectGMsg.PSTaskProgress builder(CountryWarScoreMission mission, CCountryWarMission config) {
        ObjectGMsg.PSTaskProgress.Builder taskBuilder = ObjectGMsg.PSTaskProgress.newBuilder();
        taskBuilder.setIdx(config.getIdx());
        Long count = mission.getMissionCount().getOrDefault(config.getIdx(), 0l);
        taskBuilder.setProgress(Math.min(count, config.getTarget().getTarget()));
        taskBuilder.setReward(mission.getMissionReward().getOrDefault(config.getIdx(), false));
        return taskBuilder.build();
    }

    public ObjectGMsg.PSTaskProgress builderFlag(CountryWar countryWar, CCountryWarFlagMission config) {
        ObjectGMsg.PSTaskProgress.Builder taskBuilder = ObjectGMsg.PSTaskProgress.newBuilder();
        taskBuilder.setIdx(config.getIdx());
        Long count = countryWar.getFlagMissionCount().getOrDefault(config.getIdx(), 0l);
        taskBuilder.setProgress(Math.min(count, config.getTarget().getTarget()));
        taskBuilder.setReward(countryWar.getFlagMissionReward().getOrDefault(config.getIdx(), false));
        return taskBuilder.build();
    }



}
