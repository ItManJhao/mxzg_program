package com.ayjs.mxzg.largecross.module.promotion092.service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.largecross.module.promotion092.dao.Promotion092Dao;
import com.ayjs.mxzg.largecross.module.promotion092.dao.Promotion092StartTimeDao;
import com.ayjs.mxzg.largecross.module.promotion092.domain.Promotion092;
import com.ayjs.mxzg.largecross.module.promotion092.domain.Promotion092StartTime;
import com.ayjs.mxzg.largecross.module.promotion092.event.DeliverFlowerEvent;
import com.ayjs.mxzg.largecross.servergroup.SessionManager;
import com.ayjs.mxzg.largecross.servergroup.event.CrossRegroupEvent;
import com.ayjs.mxzg.message.center.dto.CrossGroup;
import com.ayjs.mxzg.message.module.floatingIslands.struct.RankData;
import com.ayjs.mxzg.message.module.promotion092.message.Promotion092CountRankResMessage;
import com.ayjs.mxzg.message.module.promotion092.struct.Promotion092Data;
import com.ayjs.mxzg.message.module.rank.dto.CrossRankType;
import com.ayjs.mxzg.message.module.role.dao.CrossRoleRedisDao;
import com.ayjs.mxzg.message.module.role.domain.CrossRole;
import com.ayjs.mxzg.message.module.teamArena.domain.RoleSimpleMessage;
import com.ayjs.rpc.server.Connection;
import com.ayjs.rpc.server.ConnectionManager;
import lombok.extern.slf4j.Slf4j;
import org.apache.poi.ss.formula.functions.T;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2021/3/11
 **/
@Service
@Observer
@Slf4j
public class Promotion092CountRankService extends Promotion092RankService {

    @Autowired
    private Promotion092Dao promotion092Dao;
    @Autowired
    private Promotion092StartTimeDao promotion092StartTimeDao;
    @Autowired
    private CrossRoleRedisDao crossRoleRedisDao;
    @Autowired
    private SessionManager sessionManager;
    @Autowired
    private ConnectionManager connectionManager;

    @Override
    public CrossRankType getRankType() {
        return CrossRankType.PROMOTION_092_COUNT;
    }

    @Override
    protected Map<Integer, Map<Integer, List<RankData>>> startLoadRank() {
        List<Promotion092> promotion092s = promotion092Dao.listAll();
        Map<Integer, Map<Integer, List<RankData>>> res = new HashMap<>();
        for (Promotion092 promotion092 : promotion092s) {
            Promotion092StartTime startTime = promotion092StartTimeDao.get(promotion092.getServerId());
            if (startTime.getStatus() == 0 && promotion092.getStartTime() == startTime.getTime()) {
                RankData rankData = new RankData();
                rankData.setRankId(promotion092.getRid());
                rankData.setRankValue(promotion092.getCount());
                rankData.setRankTime(promotion092.getRankTime().getSecond());
                Map<Integer, List<RankData>> rankDataMap = res.computeIfAbsent(startTime.getTime(), key -> new HashMap<>());
                rankDataMap.computeIfAbsent(getGroupId(startTime.getServerId()), key -> new ArrayList<>()).add(rankData);
            }
        }
        return res;
    }

    @Subscribe(async = Subscribe.AsyncType.Sync)
    private void listen(DeliverFlowerEvent event) {
        Promotion092 promotion = promotion092Dao.get(event.getRid());
        Promotion092StartTime startTime = promotion092StartTimeDao.get(promotion.getServerId());
        RankData rank = new RankData();
        rank.setRankId(promotion.getRid());
        rank.setRankValue(promotion.getCount());
        rank.setRankTime(promotion.getRankTime().getSecond());
        addRank(rank, getGroupId(promotion.getServerId()), startTime.getTime());
        Integer clientId = sessionManager.getClientId(promotion.getServerId());
        connectionManager.send(clientId, builderRankUpdateMessage(getGroupTopN(getGroupId(promotion.getServerId()),
                startTime.getTime()).top(getRankType().getRankCount())));
    }

    @Override
    public List<T> getAll(int serverGroup) {
        return null;
    }

    @Override
    public void pullToAllGame() {

    }

    @Override
    public void pullToGame(int serverId, Connection connection) {
        Promotion092StartTime startTime = promotion092StartTimeDao.get(serverId);
        if (startTime == null) {
            log.info("服务器未开启活动");
            connection.send(builderRankUpdateMessage(Collections.emptyList()));
            return;
        }

        CrossGroup group = crossServerGroupDao.get().getGroupByServerId(serverId);
        if (group != null) {
            connection.send(builderRankUpdateMessage(getGroupTopN(group.getGroupId(),
                    startTime.getTime()).top(getRankType().getRankCount())));
        }
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(CrossRegroupEvent event) {
        resetRankList();
        pullToAllGame();
    }

    private Promotion092CountRankResMessage builderRankUpdateMessage(List<RankData> ranks) {
        List<Promotion092Data> result = builderList(ranks);
        return Promotion092CountRankResMessage.of(result);
    }

    public List<Promotion092Data> builderList(List<RankData> ranks) {
        List<Promotion092Data> result = new ArrayList<>();
        List<Long> collect = ranks.stream().mapToLong(RankData::getRankId).boxed().collect(Collectors.toList());
        Map<Long, CrossRole> crossRoles = crossRoleRedisDao.get(collect).stream().collect(Collectors.toMap(CrossRole::getId, Function.identity()));
        int rank = 1;
        for (RankData rankData : ranks) {
            Promotion092Data promotion092Data = new Promotion092Data();
            promotion092Data.setRank(rank);
            promotion092Data.setRankId(rankData.getRankId());
            promotion092Data.setRankValue((int) rankData.getRankValue());

            RoleSimpleMessage simpleMessage = new RoleSimpleMessage();
            CrossRole crossRole = crossRoles.get(rankData.getRankId());
            if (crossRole != null) {
                simpleMessage.setLevel(crossRole.getLevel());
                simpleMessage.setHeadId(crossRole.getHeadId());
                simpleMessage.setBorderId(crossRole.getBorderId());
                simpleMessage.setImage(crossRole.getImageId());
                simpleMessage.setRoleName(crossRole.getNick());
                simpleMessage.setServerId(crossRole.getServerId());
                simpleMessage.setClanName(crossRole.getClanName());
                simpleMessage.setRid(crossRole.getId());
                simpleMessage.setFighting(crossRole.getFighting());
            }
            promotion092Data.setRoleSimpleMessage(simpleMessage);

            result.add(promotion092Data);
            rank++;
        }
        return result;
    }
}
