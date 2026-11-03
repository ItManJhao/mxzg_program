package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.config.excel.entity.CDailyMissionReward;
import org.springframework.stereotype.Component;

import java.util.Optional;

/**
 * 日常副本奖励
 */
@Component
public class DailyMissionRewardSysCache extends BaseExcelCache<CDailyMissionReward> {

    @Override
    public String getFileName() {
        return "dailymissionreward";
    }

    public CDailyMissionReward getDailyMissionReward(int missionType, int missionId) {
        Optional<CDailyMissionReward> missionRewardOpt = getAll().stream()
                .filter(dailyMission -> dailyMission.getMission_type() == missionType
                        && dailyMission.getMission() == missionId).findFirst();
        ConfigAsserts.isTrue(missionRewardOpt.isPresent(),
                () -> "CDailyMissionReward is null missionType :" + missionType + " missionId:" + missionId);
        return missionRewardOpt.get();
    }
}
