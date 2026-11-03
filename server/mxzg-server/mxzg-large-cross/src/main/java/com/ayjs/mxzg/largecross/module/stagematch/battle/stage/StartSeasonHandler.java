package com.ayjs.mxzg.largecross.module.stagematch.battle.stage;

import com.ayjs.mxzg.config.excel.cache.SuperStageCycleSysCache;
import com.ayjs.mxzg.config.excel.cache.SuperStageSysCache;
import com.ayjs.mxzg.config.excel.entity.CSuperStage;
import com.ayjs.mxzg.config.excel.entity.CSuperStageCycle;
import com.ayjs.mxzg.config.struct.StageType;
import com.ayjs.mxzg.largecross.module.stagematch.battle.dao.CrossStageMatchDao;
import com.ayjs.mxzg.largecross.module.stagematch.battle.dao.OpponentDao;
import com.ayjs.mxzg.largecross.module.stagematch.battle.domain.CrossStageMatch;
import com.ayjs.mxzg.largecross.module.stagematch.battle.domain.Opponent;
import com.ayjs.mxzg.largecross.module.stagematch.battle.manager.OpponentGroupHolder;
import com.ayjs.mxzg.largecross.servergroup.MessageHelper;
import com.ayjs.mxzg.message.module.stagematch.OpenNewSeasonMessage;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

@Slf4j
@Component
public class StartSeasonHandler implements StageHandler {

    @Autowired
    private MessageHelper messageHelper;
    @Autowired
    private OpponentDao opponentDao;
    @Autowired
    private CrossStageMatchDao crossStageMatchDao;
    @Autowired
    private SuperStageCycleSysCache stageMatchCycleSysCache;
    @Autowired
    private SuperStageSysCache stageStageSysCache;
    @Autowired
    private OpponentGroupHolder opponentGroupHolder;

    @Override
    public StageType getType() {
        return StageType.START_SEASON;
    }

    @Override
    public void handle(CSuperStageCycle cycle) {
        log.info("开始清理对手信息");
        opponentGroupHolder.reset();

        List<Opponent> opponents= opponentDao.listAll();
        for (Opponent opponent : opponents) {
            try {
                CSuperStage superStage = stageStageSysCache.getById(opponent.getStageId());
                opponent.seasonReset(superStage.getInherit_stage());
                opponentDao.update(opponent);
                opponentGroupHolder.addOpponent(opponent);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        log.info("对手信息全表初始化完毕");
        CSuperStageCycle endCycle = stageMatchCycleSysCache.getCycleBy(cycle.getSeason(), StageType.SETTLEMENT.ordinal());
        CrossStageMatch crossStageMatch = crossStageMatchDao.get();
        crossStageMatch.openNewSeason(cycle, endCycle);
        crossStageMatchDao.update(crossStageMatch);
        OpenNewSeasonMessage message = OpenNewSeasonMessage.createOf(crossStageMatch.getSerialNumber(), crossStageMatch.getSeason(),
                crossStageMatch.getStartTime(), crossStageMatch.getEndTime());
        messageHelper.pushToAll(message);
    }
}
