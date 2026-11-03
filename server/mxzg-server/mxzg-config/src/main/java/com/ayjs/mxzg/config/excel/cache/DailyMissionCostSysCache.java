package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.config.excel.entity.CDailyMissionCost;
import org.springframework.stereotype.Component;

import java.util.Optional;

/**
 * 日常副本消耗
 */
@Component
public class DailyMissionCostSysCache extends BaseExcelCache<CDailyMissionCost> {

    @Override
    public String getFileName() {
        return "dailymissioncost";
    }

    public CDailyMissionCost getConfig(int missionType, int battleNum) {
        Optional<CDailyMissionCost> missionRewardOpt = getAll().stream()
                .filter(dailyMission -> dailyMission.getMission_type() == missionType
                        && dailyMission.getBattle_num() == battleNum).findFirst();
        ConfigAsserts.isTrue(missionRewardOpt.isPresent(),
                () -> "CDailyMissionReward is null missionType :" + missionType + " missionId:" + battleNum);
        return missionRewardOpt.get();
    }
}
