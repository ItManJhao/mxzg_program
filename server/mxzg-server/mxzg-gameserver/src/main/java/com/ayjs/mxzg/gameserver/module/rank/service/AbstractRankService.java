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
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2019/10/16
 **/
@Slf4j
public abstract class AbstractRankService<T> implements IRankService<T>, Lifecycle {

    protected TopN<Long, Rank> topN;

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
        Rank threshold = new Rank();
        threshold.setRankTime(-1);

        List<Rank> ranks = startLoadRank();
        ranks = ranks.stream().sorted(comparator).limit(getRankType().getRankCount()).collect(Collectors.toList());
        TopN<Long, Rank> topN_ = TopN.orderedBy(comparator).threshold(threshold).maximumSize(getRankType().getRankCount()).build();
        ranks.forEach(rank -> topN_.add(rank));
        topN = topN_;
        log.debug("rank:{}, size:{}", this.getClass().getSimpleName(), topN.size());
    }

    /**
     * 起服重组数据
     *
     * @return
     */
    protected abstract List<Rank> startLoadRank();


    @Override
    public List<T> showRanks(int count) {
        List<Rank> rankList = topN.top(count);
        List<T> result = new ArrayList<>();
        rankList.forEach(rank -> {
            result.add(builder(rank));
        });
        return result;
    }

    @Override
    public T selfRank(long rankId) {
        Rank rank = topN.get(rankId);
        if (rank == null) {
            return builderForNotRank(rankId);
        } else {
            return builder(rank);
        }
    }

    /**
     * 构建上榜对象
     *
     * @param rank
     * @return
     */
    public abstract T builder(Rank rank);

    /***
     * 构建未上榜对象
     * @param rankId
     * @return
     */
    public abstract T builderForNotRank(long rankId);

    @Override
    public Rank getRankEntity(int rank) {
        return topN.get(rank);
    }

    @Override
    public int getRank(long rankId) {
        return topN.getRank(rankId);
    }

    @Override
    public void clear() {
        topN.clear();
    }

    public List<Rank> topN(int n) {
        return topN.top(n);
    }
}
