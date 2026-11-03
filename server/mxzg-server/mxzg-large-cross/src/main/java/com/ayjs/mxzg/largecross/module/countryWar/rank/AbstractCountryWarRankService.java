package com.ayjs.mxzg.largecross.module.countryWar.rank;

import com.ayjs.mxzg.common.lifecycle.Lifecycle;
import com.ayjs.mxzg.common.lifecycle.LifecycleInfo;
import com.ayjs.mxzg.common.lifecycle.Ordinal;
import com.ayjs.mxzg.common.lifecycle.Priority;
import com.ayjs.mxzg.common.top.TopN;
import com.ayjs.mxzg.largecross.module.countryWar.dao.CountryWarTimeDao;
import com.ayjs.mxzg.largecross.servergroup.MessageHelper;
import com.ayjs.mxzg.message.module.floatingIslands.struct.RankData;
import com.ayjs.mxzg.message.module.rank.dto.CrossRankType;
import com.ayjs.mxzg.protocol.CountryWarGMsg;
import lombok.Getter;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2021/4/20
 **/
@Slf4j
public abstract class AbstractCountryWarRankService implements Lifecycle {

    @Autowired
    protected MessageHelper messageHelper;
    @Autowired
    private CountryWarTimeDao countryWarTimeDao;

    // <跨服分组ID，排名数据>
    @Getter
    protected Map<Integer, TopN<Long, RankData>> groupTopN = new ConcurrentHashMap<>();

    protected Map<Integer, Boolean> topHadChange = new ConcurrentHashMap<>();

    protected boolean resetIng = false;
    // 重组过程中记录下改变对象，重组完成之后再加入
    protected Map<Integer, List<RankData>> resetIngChange = new ConcurrentHashMap<>();

    protected Comparator<RankData> comparator = (o1, o2) -> {
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

    /****
     * 低于CountryWarCityService启动
     * @return
     */
    @Override
    public LifecycleInfo getInfo() {
        return LifecycleInfo.valueOf(Priority.MEDIUM, Ordinal._20, "CROSS_RANK" + this.getClass().getSimpleName());
    }

    public void start() throws Exception {
        Map<Integer, List<RankData>> integerListMap = startLoadRank();
        groupTopN.clear();
        log.info(getRankType() + "重组：" + integerListMap);
        integerListMap.forEach((groupId, crossRanks) -> {
            crossRanks = crossRanks.stream().sorted(comparator).limit(getRankType().getRankCount() + 1)
                    .collect(Collectors.toList());
            crossRanks.forEach(rank -> getGroupTopN(groupId).add(rank));
            log.info(getRankType() + "重组：" + groupId + "，排行数据：" + getGroupTopN(groupId).size());
        });
    }

    protected TopN<Long, RankData> getGroupTopN(int groupId) {
        TopN<Long, RankData> topN = groupTopN.get(groupId);
        if (topN == null) {
            RankData threshold = new RankData();
            threshold.setRankValue(0);
            threshold.setRankTime(Integer.MIN_VALUE);
            topN = TopN.orderedBy(comparator).threshold(threshold).maximumSize(getRankType().getRankCount()).build();
            groupTopN.putIfAbsent(groupId, topN);
            topN = groupTopN.get(groupId);
        }
        topHadChange.put(groupId, true);
        return topN;
    }

    public abstract CrossRankType getRankType();

    /**
     * 起服重组数据<服务器分组ID，该分组内的排名数据>
     *
     * @return
     */
    protected abstract Map<Integer, List<RankData>> startLoadRank();

    public void addRank(RankData rank, int groupId) {
        if (resetIng) {
            List<RankData> list = resetIngChange.computeIfAbsent(groupId, k -> new ArrayList<>());
            list.add(rank);
        } else {
            getGroupTopN(groupId).add(rank);
        }
    }

    public void resetRankList() {
        try {
            resetIng = true;
            start();
            resetIng = false;
            resetIngChange.forEach((groupId, list) -> {
                list.forEach(rank -> {
                    getGroupTopN(groupId).add(rank);
                });
            });
        } catch (Exception e) {
            log.error("跨服重组后，排行榜重组失败", e);
        }
    }


    private TopN<Long, RankData> getTopNByServerId(int serverId) {
        Integer groupId = countryWarTimeDao.getSingle().getServer2Group().get(serverId);
        if (groupId == null) {
            return null;
        }
        TopN<Long, RankData> topN = groupTopN.get(groupId);
        if (topN == null) {
            return null;
        }
        return topN;
    }

    public List<RankData> showRanks(int groupId, int count) {
        TopN<Long, RankData> topN = getGroupTopN(groupId);
        if (topN == null) {
            return Collections.emptyList();
        }
        List<RankData> rankList = topN.top(count);
        return rankList;
    }


    /**
     * 清空排名数据
     */
    public void clear() {
        groupTopN.clear();
    }

    public abstract List<CountryWarGMsg.PSCountryWarRank> getAll(int group);

    public abstract CountryWarGMsg.PSCountryWarRank getOne(int group, long rankId);


}
