package com.ayjs.mxzg.largecross.module.stagematch.preliminaries.service;

import com.ayjs.mxzg.common.lifecycle.Lifecycle;
import com.ayjs.mxzg.common.lifecycle.LifecycleInfo;
import com.ayjs.mxzg.common.util.RandomUtil;
import com.ayjs.mxzg.config.excel.cache.TopMatchFirstMatchSysCache;
import com.ayjs.mxzg.config.excel.constant.PreliminariesConst;
import com.ayjs.mxzg.config.excel.entity.CTopMatchFirstMatch;
import com.ayjs.mxzg.largecross.module.stagematch.battle.manager.OpponentGroup;
import com.ayjs.mxzg.largecross.module.stagematch.battle.manager.OpponentGroupHolder;
import com.ayjs.mxzg.largecross.module.stagematch.preliminaries.dao.PreliminariesLadderDao;
import com.ayjs.mxzg.largecross.module.stagematch.preliminaries.domain.PreliminariesLadder;
import com.ayjs.mxzg.message.module.stagematch.dto.RankDto;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 跨服天梯
 */
@Slf4j
@Service
public class PreliminariesService implements Lifecycle {

    @Autowired
    private PreliminariesLadderDao preliminariesLadderDao;
    @Autowired
    private TopMatchFirstMatchSysCache topMatchFirstMatchSysCache;
    @Autowired
    private OpponentGroupHolder opponentGroupHolder;


    @Override
    public LifecycleInfo getInfo() {
        return LifecycleInfo.valueOf("PRELIMINARIES_SERVICE");
    }


    /**
     * 匹配或者刷新对手
     *
     * @param groupId
     * @param rid
     */
    public List<RankDto> match(int groupId, long rid) {
        PreliminariesLadder preliminariesLadder = preliminariesLadderDao.get(rid);

        OpponentGroup group = opponentGroupHolder.getGroup(groupId);
        if(group == null){
            return Collections.emptyList();
        }
        List<RankDto> ranks = group.getPreliminariesRanking(PreliminariesConst.PRELIMINARIES_RANKS_NUMBER);
        int rank = preliminariesLadder == null ? PreliminariesConst.PRELIMINARIES_RANKS_NUMBER : preliminariesLadder.getRank();
        rank = rank == 0 ? PreliminariesConst.PRELIMINARIES_RANKS_NUMBER : rank;
        rank = Math.min(rank, ranks.size() - 1);
        List<RankDto> result = new ArrayList<>();

        if (rank <= PreliminariesConst.PRELIMINARIES_RANKS_TOP_B) {
            // 1-4名
            result = ranks.stream().limit(PreliminariesConst.OPPONENT_NUMBER + 1).filter(c -> c.getRid() != rid).collect(Collectors.toList());
        } else if (rank > PreliminariesConst.PRELIMINARIES_RANKS_TOP_B && rank <= PreliminariesConst.PRELIMINARIES_RANKS_TOP_A) {
            // 前4到10名
            List<RankDto> tempList = ranks.stream().limit(rank + PreliminariesConst.TOPMATCH_MATCH_SEPARATE_RATIO)
                    .filter(c -> c.getRid() != rid).collect(Collectors.toList());
            result = RandomUtil.randomList(tempList, PreliminariesConst.OPPONENT_NUMBER)
                    .stream().sorted(Comparator.comparingInt(RankDto::getRank)).collect(Collectors.toList());
        } else {
            // 10名以后
            int beforeRank = 0;
            List<Integer> matchRankList = new ArrayList<>();
            int position = 1;
            log.debug("match groupId:{}, rid:{},rank:{}", groupId, rid, rank);
            // 防止死循环
            for (int i = 1; i <= 100; i++) {
                int defenderRank = Math.min(PreliminariesConst.PRELIMINARIES_RANKS_NUMBER - 1, randomDefenderRank(rank, position, beforeRank));
                beforeRank = defenderRank;// 记录上次随机到的数字，传入下次匹配
                // 过滤自己
                if (defenderRank == rank - 1) {
                    // 避免最后匹配到自己一直循环
                    if (rank > 990) {
                        defenderRank = rank - RandomUtil.rand(2, 20);// 默认给最近几个玩家的信息
                    } else {
                        continue;
                    }
                }
                if (defenderRank <= 0 || defenderRank > PreliminariesConst.PRELIMINARIES_RANKS_NUMBER) {
                    continue;
                }
                long matchRid = ranks.get(defenderRank).getRid();
                // 匹配到自己，或者已经在匹配列表
                if (matchRid == rid || matchRankList.contains(matchRid)) {
                    continue;
                }
                matchRankList.add(defenderRank);
                position++;
                if (position > PreliminariesConst.OPPONENT_NUMBER || matchRankList.size() >= PreliminariesConst.OPPONENT_NUMBER) {
                    break;
                }
            }
            List<RankDto> dataList = group.getPinnacleRankBy(matchRankList);
            result.addAll(dataList);
        }
        log.debug("match rank:{}, resultIndexList:{}", rank, result.stream().map(RankDto::getRank).toArray());

        return result;
    }

    /**
     * 随机防守者
     */
    public int randomDefenderRank(int rank, int position, int beforeRank) {
        CTopMatchFirstMatch ladderPosition = topMatchFirstMatchSysCache.getOrThrow(position);
        return (int) Math.max(beforeRank + 1,
                Math.ceil(10000.0d * rank / RandomUtil.rand(ladderPosition.getRatio_low(), ladderPosition.getRatio_up() + 1)));
    }

    /**
     * 获取分组对象
     * @param groupId
     * @return
     */
    public OpponentGroup getCrossLadder(int groupId) {
        return opponentGroupHolder.getGroup(groupId);
    }

}
