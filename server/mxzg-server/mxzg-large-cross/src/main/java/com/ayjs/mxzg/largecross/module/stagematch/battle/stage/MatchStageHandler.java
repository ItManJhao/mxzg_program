package com.ayjs.mxzg.largecross.module.stagematch.battle.stage;

import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.SuperStageCycleSysCache;
import com.ayjs.mxzg.config.excel.entity.CSuperStageCycle;
import com.ayjs.mxzg.config.struct.StageType;
import com.ayjs.mxzg.largecross.module.stagematch.battle.dao.CrossStageMatchDao;
import com.ayjs.mxzg.largecross.module.stagematch.battle.domain.CrossStageMatch;
import com.ayjs.mxzg.largecross.servergroup.MessageHelper;
import com.ayjs.mxzg.message.module.stagematch.StartMatchingMessage;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * 开启匹配阶段
 */
@Slf4j
@Component
public class MatchStageHandler implements StageHandler {

    @Autowired
    private MessageHelper messageHelper;
    @Autowired
    private CrossStageMatchDao crossStageMatchDao;
    @Autowired
    private SuperStageCycleSysCache superStageCycleSysCache;

    @Override
    public StageType getType() {
        return StageType.MATCH;
    }

    @Override
    public void handle(CSuperStageCycle cycle) {
        CrossStageMatch crossStageMatch = crossStageMatchDao.get();
        CSuperStageCycle finishStage = superStageCycleSysCache.getLastCycle(cycle.getSeason(), StageType.FINISH.ordinal());
        crossStageMatch.openNewSeason(cycle, finishStage);
        crossStageMatchDao.update(crossStageMatch);

        messageHelper.pushToAll(StartMatchingMessage.createOf(TimeDateUtil.getCurrentTimeInt()));
    }
}
