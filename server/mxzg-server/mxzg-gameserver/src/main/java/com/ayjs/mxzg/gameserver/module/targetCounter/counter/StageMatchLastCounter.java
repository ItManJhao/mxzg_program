package com.ayjs.mxzg.gameserver.module.targetCounter.counter;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.config.struct.TargetStruct;
import com.ayjs.mxzg.config.struct.TargetType;
import com.ayjs.mxzg.gameserver.module.stagematch.rim.domain.StageSeasonDetail;
import com.ayjs.mxzg.gameserver.module.stagematch.rim.service.StageMatchRimService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

/**
 * 上个赛季段位计数器
 *
 * @Author: CWJ
 * @Date: 2020/7/21
 **/
@Service
public class StageMatchLastCounter implements Counter {
    @Autowired
    private StageMatchRimService stageMatchRimService;

    @Override
    public TargetType thisType() {
        return TargetType.STAGE_MATCH_LAST;
    }

    @Override
    public int count(long rid, TargetStruct targetStruct) {
        int seasonId = stageMatchRimService.getSeasonId();
        if (seasonId <= 1) {
            return 0;
        }
        List<StageSeasonDetail> seasonDetails = stageMatchRimService.listAllSeason(rid).stream().filter(seasonDetail ->
                seasonDetail.getSeasonId() != seasonId && seasonDetail.getSeasonId() != StageMatchRimService.TOTAL_SEASON_ID)
                .collect(Collectors.toList());
        if (CollectionUtil.isEmpty(seasonDetails)) {
            return 0;
        }
        return seasonDetails.stream().mapToInt(StageSeasonDetail::getStageId).max().getAsInt() >= targetStruct.getCondition() ? 1 : 0;
    }

    @Override
    public long taskCount(long rid, TargetStruct targetStruct) {
        return count(rid, targetStruct);
    }
}
