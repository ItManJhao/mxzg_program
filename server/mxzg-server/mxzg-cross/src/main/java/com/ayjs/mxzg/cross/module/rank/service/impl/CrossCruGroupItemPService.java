package com.ayjs.mxzg.cross.module.rank.service.impl;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.top.TopN;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.cross.module.crossrole.dao.CrossRoleDao;
import com.ayjs.mxzg.cross.module.crossservice.dao.CrossServerGroupDao;
import com.ayjs.mxzg.cross.module.crossservice.domain.CrossServerGroup;
import com.ayjs.mxzg.cross.module.crossservice.event.CrossRegroupEvent;
import com.ayjs.mxzg.cross.module.crusadegroup.group.dao.CrossCrusadeGroupDao;
import com.ayjs.mxzg.cross.module.crusadegroup.group.domain.CrossCrusadeGroup;
import com.ayjs.mxzg.cross.module.crusadegroup.group.event.ShenBinItemPChangeEvent;
import com.ayjs.mxzg.cross.module.crusadegroup.group.manager.CrusadeGroupDataManager;
import com.ayjs.mxzg.cross.module.crusadegroup.map.dao.CrossCrusadersDao;
import com.ayjs.mxzg.cross.module.crusadegroup.map.domain.CrossCrusaders;
import com.ayjs.mxzg.cross.module.rank.service.AbstractCrossRankService;
import com.ayjs.mxzg.message.center.dto.CrossGroup;
import com.ayjs.mxzg.message.module.floatingIslands.struct.RankData;
import com.ayjs.mxzg.message.module.rank.ResCrossCGItemPRankMessage;
import com.ayjs.mxzg.message.module.rank.dto.CrossCruGroupItemP;
import com.ayjs.mxzg.message.module.rank.dto.CrossRankType;
import com.ayjs.mxzg.message.module.role.domain.CrossRole;
import com.ayjs.rpc.server.Connection;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;

/**
 * 讨伐团玩家神兵精华 排行
 **/
@Observer
@Service
@Slf4j
public class CrossCruGroupItemPService extends AbstractCrossRankService<CrossCruGroupItemP> {
    //根据讨伐团分组排行******************************
    @Autowired
    private CrossCrusadersDao crossCrusadersDao;
    @Autowired
    private CrossRoleDao crossRoleDao;
    @Autowired
    private CrossCrusadeGroupDao crossCrusadeGroupDao;
    @Autowired
    private CrossServerGroupDao crossServerGroupDao;
    @Autowired
    private CrusadeGroupDataManager crusadeGroupDataManager;

    @Override
    public CrossRankType getRankType() {
        return CrossRankType.CRUGROUP_ITEMP;
    }

    @Override
    protected Map<Integer, List<RankData>> startLoadRank() {
        Map<Integer, List<RankData>> map = new HashMap<>();
        List<CrossCrusadeGroup> list = crossCrusadeGroupDao.listAll();//拿到所有讨伐团
        for (CrossCrusadeGroup crossCrusadeGroup : list) {
            Set<Long> roleSet = crossCrusadeGroup.getMembers();
            int cruGroupId = crossCrusadeGroup.getId();
            for (long rid : roleSet) {
                CrossCrusaders crossCrusaders = crossCrusadersDao.getOrCreate(rid);
                List<RankData> crossRanks = map.computeIfAbsent(cruGroupId, key -> new ArrayList<>());
                RankData crossRank = new RankData();
                crossRank.setRankId(crossCrusaders.getRid());
                crossRank.setRankTime(crossCrusaders.getShenBinUpdateTime());
                crossRank.setRankValue(crossCrusaders.getShenBin());
                crossRanks.add(crossRank);
            }
        }
        return map;
    }

    @Override
    public List<CrossCruGroupItemP> getAll(int serverGroup) {
        //根据讨伐团id获取团内排行
        TopN<Long, RankData> topN = groupTopN.get(serverGroup);
        if (topN == null) {
            return new ArrayList<>();
        }
        List<RankData> top = topN.top(getRankType().getRankCount());
        List<CrossCruGroupItemP> crossCruGroupItemPS = new ArrayList<>();
        top.forEach(crossRank -> {
            CrossRole crossRole = crossRoleDao.get(crossRank.getRankId());
            CrossCruGroupItemP crossCruGroupItemP = new CrossCruGroupItemP();
            crossCruGroupItemP.setRankId(crossRank.getRankId());
            crossCruGroupItemP.setRank(topN.getRank(crossRank.getRankId()));
            crossCruGroupItemP.setRoleName(crossRole.getNick());
            crossCruGroupItemP.setBorderId(crossRole.getBorderId());
            crossCruGroupItemP.setHeadId(crossRole.getHeadId());
            crossCruGroupItemP.setShenBinJh(crossRank.getRankValue());
            crossCruGroupItemP.setCruGroupId(serverGroup);
            crossCruGroupItemP.setRankTime(crossRank.getRankTime());
            crossCruGroupItemP.setServerId(crossRole.getServerId());
            crossCruGroupItemPS.add(crossCruGroupItemP);
        });
        return crossCruGroupItemPS;
    }

    //获取所以讨伐团的团内排行
    public Map<Integer, List<CrossCruGroupItemP>> getAllRank() {
        Map<Integer, List<CrossCruGroupItemP>> map = new HashMap<>();
        for (Map.Entry<Integer, TopN<Long, RankData>> entry : groupTopN.entrySet()) {
            int cgId = entry.getKey();
            map.put(cgId, getAll(cgId));
        }
        return map;
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(ShenBinItemPChangeEvent event) {
        RankData rank = new RankData();
        rank.setRankValue(event.getNowNum());
        rank.setRankId(event.getRid());
        rank.setRankTime(TimeDateUtil.getCurrentTimeInt());

        CrossCrusadeGroup group = crusadeGroupDataManager.getGroupBy(event.getServerId());//获取讨伐团id
        if (group != null) {
            addRank(rank, group.getId());
        }
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(CrossRegroupEvent event) {
        resetRankList();
    }

    @Override
    public void pullToAllGame() {
        if (resetIng)
            return;
        Map<Integer, List<CrossCruGroupItemP>> map = new HashMap<>();
        for (Map.Entry<Integer, TopN<Long, RankData>> entry : groupTopN.entrySet()) {
            int cgId = entry.getKey();
            if (topHadChange.getOrDefault(cgId, true)) {
                topHadChange.put(cgId, false);
                map.put(cgId, getAll(cgId));
            }
        }
        if (map.isEmpty()) {
            return;
        }
        CrossServerGroup crossServerGroup = crossServerGroupDao.get();
        Set<Integer> set = new HashSet<>(crossServerGroup.getGroups().keySet());
        set.forEach(groupId -> {
            messageHelper.pushToGroupMessage(groupId, ResCrossCGItemPRankMessage.createOf(map));
        });
    }

    @Override
    public void pullToGame(int serverId, Connection connection) {
        if (resetIng)
            return;
        CrossServerGroup crossServerGroup = crossServerGroupDao.get();
        CrossGroup group = crossServerGroup.getGroupByServerId(serverId);
        if (group == null) {
            return;
        }
        Map<Integer, List<CrossCruGroupItemP>> map = getAllRank();
        connection.send(ResCrossCGItemPRankMessage.createOf(map));
    }

    /**
     * 重写该方法，主要是区分当前排行为全服务排行
     *
     * @param cgId
     * @return
     */
    @Override
    public TopN<Long, RankData> getTopNByServerId(int cgId) {
        TopN<Long, RankData> topN = groupTopN.get(cgId);
        if (topN == null) {
            return null;
        }
        return topN;
    }

}
