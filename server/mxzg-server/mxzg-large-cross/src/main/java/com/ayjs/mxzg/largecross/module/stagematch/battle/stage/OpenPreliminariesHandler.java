package com.ayjs.mxzg.largecross.module.stagematch.battle.stage;

import com.ayjs.mxzg.config.excel.constant.PreliminariesConst;
import com.ayjs.mxzg.config.excel.entity.CSuperStageCycle;
import com.ayjs.mxzg.config.struct.StageType;
import com.ayjs.mxzg.largecross.module.stagematch.battle.dao.OpponentDao;
import com.ayjs.mxzg.largecross.module.stagematch.battle.domain.Opponent;
import com.ayjs.mxzg.largecross.module.stagematch.battle.manager.OpponentGroup;
import com.ayjs.mxzg.largecross.module.stagematch.battle.manager.OpponentGroupHolder;
import com.ayjs.mxzg.largecross.module.stagematch.preliminaries.dao.PreliminariesLadderDao;
import com.ayjs.mxzg.largecross.module.stagematch.preliminaries.domain.PreliminariesLadder;
import com.ayjs.mxzg.largecross.servergroup.MessageHelper;
import com.ayjs.mxzg.message.module.stagematch.dto.RankDto;
import com.ayjs.mxzg.message.module.stagematch.preliminaries.PreliminariesOpenMessage;
import com.google.common.collect.ArrayListMultimap;
import com.google.common.collect.Multimap;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.List;

@Slf4j
@Component
public class OpenPreliminariesHandler implements StageHandler {

    @Autowired
    private PreliminariesLadderDao preliminariesLadderDao;
    @Autowired
    private OpponentDao opponentDao;
    @Autowired
    private OpponentGroupHolder opponentGroupHolder;
    @Autowired
    private MessageHelper messageHelper;

    @Override
    public StageType getType() {
        return StageType.PRELIMINARIES;
    }

    @Override
    public void handle(CSuperStageCycle cycle) {
        log.info("段位赛预赛开始");
        List<Opponent> all = opponentDao.listAll();
        Multimap<Integer, Opponent> groupOpponent = ArrayListMultimap.create();
        log.info("开始根据分组排名:{}", all.size());
        for (Opponent opponent : all) {
            OpponentGroup group = opponentGroupHolder.getGroupBy(opponent.getServerId());
            if(group != null){
                groupOpponent.put(group.getGroupId(), opponent);
            }
        }

        log.info("开始删除天梯全表数据");
        preliminariesLadderDao.truncateAll();

        log.info("开始执行分组排名");

        Collection<OpponentGroup> allGroup = opponentGroupHolder.getGroups();
        for (OpponentGroup group : allGroup) {
            List<Opponent> opponents = (List<Opponent>)groupOpponent.get(group.getGroupId());
            Collections.sort(opponents);
            int rankSize = Math.min(opponents.size(), PreliminariesConst.PRELIMINARIES_RANKS_NUMBER);
            List<RankDto> ranking = new ArrayList<>();
            for (int i = 1; i <= rankSize; i++) {
                Opponent opponent = opponents.get(i - 1);
                if(opponent.getMaxStageId() >= PreliminariesConst.PRELIMINARY_QUALIFICATION_STAGE_ID ||
                opponent.getStageId() >= PreliminariesConst.PRELIMINARY_QUALIFICATION_STAGE_ID){
                    PreliminariesLadder preliminariesLadder = preliminariesLadderDao.getOrCreate(opponent.getRid());
                    preliminariesLadder.setRank(i);
                    preliminariesLadderDao.update(preliminariesLadder);
                    ranking.add(RankDto.createOf(i, opponent.getRid(), opponent.getStageId(), opponent.getHeadId(), opponent.getBorderId(), opponent.getImage_id(),
                            opponent.getName(), opponent.getFighting(), opponent.getLevel(), opponent.getServerId(), preliminariesLadder.getLikes()));
                }
            }
            group.addPinnacleRanking(ranking);
        }
        log.info("巅峰赛预赛初始化完毕");

        messageHelper.pushToAll(PreliminariesOpenMessage.getInstance());
    }
}
