package com.ayjs.mxzg.gameserver.module.promotionNew.promotion092.service;

import com.ayjs.mxzg.gameserver.module.promotionNew.promotion092.domain.Promotion092;
import com.ayjs.mxzg.gameserver.module.rank.constant.RankType;
import com.ayjs.mxzg.gameserver.module.rank.domain.Rank;
import com.ayjs.mxzg.gameserver.module.rank.service.AbstractRankService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.message.module.promotion092.message.Promotion092CountRankResMessage;
import com.ayjs.mxzg.message.module.promotion092.struct.Promotion092Data;
import com.ayjs.mxzg.protocol.Promotion092GMsg;
import com.ayjs.rpc.annotation.Remote;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.dispatcher.MessageHandler;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2021/2/24
 **/
@Service
@Slf4j
@Remote
public class DeliverCountRankService extends AbstractRankService<Promotion092GMsg.PSDeliverCountRank> implements MessageHandler {

    private List<Promotion092Data> rankList = new ArrayList<>();
    private Map<Long, Promotion092Data> map = new ConcurrentHashMap<>();

    @Autowired
    private RoleService roleService;
    @Autowired
    private Promotion092Service promotion092Service;

    @Override
    protected List<Rank> startLoadRank() {
        List<Rank> list = new ArrayList<>();
        map.values().forEach(hadesRoleData -> {
            Rank rank = new Rank();
            rank.setRankId(hadesRoleData.getRankId());
            rank.setRankValue(hadesRoleData.getRankValue());
            rank.setRankTime(hadesRoleData.getRankTime());
            list.add(rank);
        });
        return list;
    }

    @Override
    public Promotion092GMsg.PSDeliverCountRank builder(Rank rank) {
        Promotion092GMsg.PSDeliverCountRank.Builder builder = Promotion092GMsg.PSDeliverCountRank.newBuilder();
        Promotion092Data role = map.get(rank.getRankId());
        builder.setRank(topN.getRank(rank.getRankId()));
        builder.setServerId(role.getRoleSimpleMessage().getServerId());
        builder.setCount((int) rank.getRankValue());
        builder.setHeadId(role.getRoleSimpleMessage().getHeadId());
        builder.setName(role.getRoleSimpleMessage().getRoleName());
        builder.setLevel(role.getRoleSimpleMessage().getLevel());
        builder.setPlayerId(role.getRoleSimpleMessage().getRid());
        return builder.build();
    }

    @Override
    public Promotion092GMsg.PSDeliverCountRank builderForNotRank(long rankId) {
        Promotion092GMsg.PSDeliverCountRank.Builder builder = Promotion092GMsg.PSDeliverCountRank.newBuilder();
        Role role = roleService.getOrThrow(rankId);
        builder.setRank(-1);
        builder.setServerId(role.getServerId());
        Promotion092 promotion = promotion092Service.getPromotionInfo(rankId);
        builder.setCount(promotion.getCount());
        builder.setHeadId(role.getHeadId());
        builder.setName(role.getNick());
        builder.setLevel(role.getLevel());
        builder.setPlayerId(role.getId());
        return builder.build();
    }

    //    @Subscribe(async = Subscribe.AsyncType.Async)
//    private void listen(DeliverFlowerEvent event) {
//        Rank rank = new Rank();
//        Promotion092 promotion = promotion092Service.getPromotionInfo(event.getRid());
//        rank.setRankId(promotion.getRid());
//        rank.setRankValue(promotion.getCount());
//        rank.setRankTime(promotion.getRankTime().getSecond());
//        topN.add(rank);
//    }
    @RemoteMethod
    public void replaceRank(Promotion092CountRankResMessage message) {
        try {
            List<Promotion092Data> ranks = message.getRankDataList() == null ? new ArrayList<>() : message.getRankDataList();
            rankList = ranks;
            log.debug("献花排行榜英雄榜更新数据量:{}", ranks.size());
            if (rankList.size() != 0) {
                Map<Long, Promotion092Data> collect = ranks.stream().collect(Collectors.toMap(Promotion092Data::getRankId, Function.identity()));
                map = collect;
            } else {
                map.clear();
            }
            start();
        } catch (Exception e) {
            log.error("重载排行榜异常", e);
        }
    }

    @Override
    public RankType getRankType() {
        return RankType.PROMOTION_092_COUNT;
    }
}
