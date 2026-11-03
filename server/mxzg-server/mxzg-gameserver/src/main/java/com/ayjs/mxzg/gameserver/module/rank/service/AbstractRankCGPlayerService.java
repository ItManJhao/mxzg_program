package com.ayjs.mxzg.gameserver.module.rank.service;

import com.ayjs.mxzg.common.lifecycle.Lifecycle;
import com.ayjs.mxzg.common.lifecycle.LifecycleInfo;
import com.ayjs.mxzg.common.lifecycle.Ordinal;
import com.ayjs.mxzg.common.lifecycle.Priority;
import com.ayjs.mxzg.common.top.TopN;
import com.ayjs.mxzg.gameserver.module.rank.domain.Rank;
import lombok.extern.slf4j.Slf4j;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;

/**
 * 讨伐团跨服玩家排行数据
 **/
@Slf4j
public abstract class AbstractRankCGPlayerService<T> implements IRankCGPlayerService<T>, Lifecycle {

    //讨伐团内部排行榜
    protected Map<Integer, TopN<Long, Rank>> groupTopN = new ConcurrentHashMap<>();

    protected Comparator<Rank> comparator = new Comparator<Rank>() {
        @Override
        public int compare(Rank o1, Rank o2) {
            int result = Long.compare(o2.getRankValue(), o1.getRankValue());
            if (result != 0)
                return result;
            result = Integer.compare(o1.getRankTime(), o2.getRankTime());
            if (result != 0) {
                return result;
            }
            return Long.compare(o1.getRankId(), o2.getRankId());
        }
    };

    @Override
    public LifecycleInfo getInfo() {
        return LifecycleInfo.valueOf(Priority.MEDIUM, Ordinal._1, String.format("RANK_%s", this.getClass().getSimpleName()));
    }

    @Override
    public void start() throws Exception {
        Map<Integer, List<Rank>> integerListMap = startLoadRank();
        groupTopN.clear();
        log.info(getRankType() + "重组：" + integerListMap);
        integerListMap.forEach((cgId, ranks) -> {
            ranks = ranks.stream().sorted(comparator).limit(getRankType().getRankCount())
                    .collect(Collectors.toList());
            ranks.forEach(rank -> getGroupTopN(cgId).add(rank));
            log.info(getRankType() + "重组：" + cgId);
        });
    }

    protected TopN<Long, Rank> getGroupTopN(int cgId) {
        TopN<Long, Rank> topN = groupTopN.get(cgId);
        if (topN == null) {
            Rank threshold = new Rank();
            threshold.setRankTime(-1);
            topN = TopN.orderedBy(comparator).threshold(threshold).maximumSize(getRankType().getRankCount()).build();
            groupTopN.putIfAbsent(cgId, topN);
            topN = groupTopN.get(cgId);
        }
        return topN;
    }

    /**
     * 起服重组数据
     *
     * @return
     */
    protected abstract Map<Integer, List<Rank>> startLoadRank();


    @Override
    public List<T> showRanks(int cgId, int count) {
        TopN<Long, Rank> topN = getGroupTopN(cgId);
        List<Rank> rankList = topN.top(count);
        List<T> result = new ArrayList<>();
        rankList.forEach(rank -> {
            result.add(builder(cgId, rank));
        });
        return result;
    }

    @Override
    public T selfRank(int cgId, long rankId) {
        TopN<Long, Rank> topN = getGroupTopN(cgId);
        Rank rank = topN.get(rankId);
        if (rank == null) {
            return builderForNotRank(cgId, rankId);
        } else {
            return builder(cgId, rank);
        }
    }

    /**
     * 构建上榜对象
     *
     * @param rank
     * @return
     */
    public abstract T builder(int cgId, Rank rank);

    /***
     * 构建未上榜对象
     * @param rankId
     * @return
     */
    public abstract T builderForNotRank(int cgId, long rankId);

    @Override
    public Rank getRankEntity(int cgId, int rank) {
        TopN<Long, Rank> topN = getGroupTopN(cgId);
        return topN.get(rank);
    }

    @Override
    public int getRank(int cgId, long rankId) {
        TopN<Long, Rank> topN = getGroupTopN(cgId);
        return topN.getRank(rankId);
    }

    @Override
    public void clear() {
        groupTopN.clear();
    }
}
