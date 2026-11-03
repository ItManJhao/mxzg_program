package com.ayjs.mxzg.largecross.module.promotion092.service;

import com.ayjs.mxzg.common.lifecycle.Lifecycle;
import com.ayjs.mxzg.common.lifecycle.LifecycleInfo;
import com.ayjs.mxzg.common.lifecycle.Ordinal;
import com.ayjs.mxzg.common.lifecycle.Priority;
import com.ayjs.mxzg.common.top.TopN;
import com.ayjs.mxzg.largecross.module.rank.service.ICrossRankService;
import com.ayjs.mxzg.largecross.servergroup.MessageHelper;
import com.ayjs.mxzg.largecross.servergroup.dao.CrossServerGroupDao;
import com.ayjs.mxzg.message.center.dto.CrossGroup;
import com.ayjs.mxzg.message.module.floatingIslands.struct.RankData;
import com.ayjs.mxzg.message.module.rank.dto.CrossRankType;
import lombok.Getter;
import lombok.extern.slf4j.Slf4j;
import org.apache.poi.ss.formula.functions.T;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2021/3/11
 **/
@Slf4j
public abstract class Promotion092RankService implements ICrossRankService<T>, Lifecycle {

    @Autowired
    protected MessageHelper messageHelper;
    @Autowired
    protected CrossServerGroupDao crossServerGroupDao;

    //<time,<group,rank>>
    @Getter
    protected Map<Integer, Map<Integer, TopN<Long, RankData>>> timeRankMap = new ConcurrentHashMap<>();
    // 重组过程中记录下改变对象，重组完成之后再加入
    protected Map<Integer, Map<Integer, List<RankData>>> resetIngChange = new ConcurrentHashMap<>();

    protected boolean resetIng = false;


    private Comparator<RankData> comparator = (o1, o2) -> {
        int result = Long.compare(o2.getRankValue(), o1.getRankValue());
        if (result != 0)
            return result;
        result = Integer.compare(o1.getRankTime(), o2.getRankTime());
        if (result != 0) {
            return result;
        }
        result = Long.compare(o2.getFighting(), o1.getFighting());
        if (result != 0) {
            return result;
        }
        return Long.compare(o1.getRankId(), o2.getRankId());
    };

    @Override
    public LifecycleInfo getInfo() {
        return LifecycleInfo.valueOf(Priority.MEDIUM, Ordinal._1, "CROSS_RANK" + this.getClass().getSimpleName());
    }

    public void start() {
        Map<Integer, Map<Integer, List<RankData>>> timeMap = startLoadRank();
        timeRankMap.clear();
        log.info(getRankType() + "重组：" + timeMap);
        timeMap.forEach((time, map) -> {
            map.forEach((groupId, crossRanks) -> {
                crossRanks = crossRanks.stream().sorted(comparator).limit(getRankType().getRankCount())
                        .collect(Collectors.toList());
                crossRanks.forEach(rank -> getGroupTopN(groupId, time).add(rank));
                log.info(getRankType() + "重组：" + groupId + "，排行数据：" + getGroupTopN(groupId, time).size());
            });
        });

    }

    protected TopN<Long, RankData> getGroupTopN(int groupId, int startTime) {
        Map<Integer, TopN<Long, RankData>> groupTopN = timeRankMap.computeIfAbsent(startTime, key -> new ConcurrentHashMap<>());
        TopN<Long, RankData> topN = groupTopN.computeIfAbsent(groupId, key -> {
            RankData threshold = new RankData();
            threshold.setRankTime(-1);
            return TopN.orderedBy(comparator).threshold(threshold).maximumSize(getRankType().getRankCount()).build();
        });
        return topN;
    }

    /***
     * 不存在组时，返回-1
     * @param serverId
     * @return
     */
    public int getGroupId(int serverId) {
        CrossGroup group = crossServerGroupDao.get().getGroupByServerId(serverId);
        return group != null ? group.getGroupId() : -1;
    }

    public abstract CrossRankType getRankType();

    /**
     * 起服重组数据<服务器分组ID，该分组内的排名数据>
     *
     * @return
     */
    protected abstract Map<Integer, Map<Integer, List<RankData>>> startLoadRank();

    public void addRank(RankData rank, int groupId, int startTime) {
        if (resetIng) {
            List<RankData> list = resetIngChange.computeIfAbsent(startTime, HashMap::new).computeIfAbsent(groupId, ArrayList::new);
            list.add(rank);
        } else {
            getGroupTopN(groupId, startTime).add(rank);
        }
    }

    public void resetRankList() {
        try {
            resetIng = true;
            start();
            resetIng = false;
            resetIngChange.forEach((time, map) -> {
                map.forEach((groupId, crossRanks) -> {
                    crossRanks.forEach(rank -> {
                        getGroupTopN(groupId, time).add(rank);
                    });
                });
            });
        } catch (Exception e) {
            log.error("跨服重组后，排行榜重组失败", e);
        }
    }

    public List<RankData> topN(int serverId, int n, int time) {
        return getGroupTopN(getGroupId(serverId), time).top(1);
    }

    @Override
    public RankData getRank(int serverGroup, int rank) {
        return null;
    }

    @Override
    public void pullToAllGame() {

    }

    /**
     * 清空排名数据
     */
    public void clear() {
        timeRankMap.clear();
    }

}
