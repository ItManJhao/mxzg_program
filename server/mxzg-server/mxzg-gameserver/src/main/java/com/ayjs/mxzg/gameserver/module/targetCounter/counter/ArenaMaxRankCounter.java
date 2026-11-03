package com.ayjs.mxzg.gameserver.module.targetCounter.counter;

import com.ayjs.mxzg.config.struct.TargetStruct;
import com.ayjs.mxzg.config.struct.TargetType;
import com.ayjs.mxzg.gameserver.module.rank.service.impl.ArenaRankService;
import com.ayjs.mxzg.gameserver.module.targetCounter.dao.TaskTargetCountDao;
import com.ayjs.mxzg.gameserver.module.targetCounter.domain.TaskTargetCount;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

/**
 * @Author: CWJ
 * @Date: 2019/11/14
 **/
@Controller
public class ArenaMaxRankCounter implements Counter {

    @Autowired
    ArenaRankService arenaRankService;
    @Autowired
    TaskTargetCountDao taskTargetCountDao;

    @Override
    public TargetType thisType() {
        return TargetType.ARENA_MAX_RANK;
    }

    @Override
    public int count(long rid, TargetStruct targetStruct) {
        int rank = arenaRankService.getRank(rid);
        if (rank == 0) {
            return 0;
        }
        if (rank <= targetStruct.getCondition())
            return 1;
        return 0;
    }

    @Override
    public long taskCount(long rid, TargetStruct targetStruct) {
        TaskTargetCount entity = taskTargetCountDao.getEntityByType(rid, targetStruct.getType().getValue()).stream().findFirst().orElse(null);
        if (entity == null || entity.getCount() == 0) {
            return 0;
        }
        return targetStruct.getCondition() < entity.getCount() ? 0 : 1;
    }
}
