package com.ayjs.mxzg.gameserver.module.promotionNew.promotion092.service;

import com.ayjs.mxzg.gameserver.module.rank.constant.RankType;
import com.ayjs.mxzg.gameserver.module.rank.domain.Rank;
import com.ayjs.mxzg.gameserver.module.rank.service.AbstractRankService;
import com.ayjs.mxzg.message.module.promotion092.message.Promotion092HeroRankResMessage;
import com.ayjs.mxzg.message.module.promotion092.struct.Promotion092HeroData;
import com.ayjs.mxzg.protocol.Promotion092GMsg;
import com.ayjs.rpc.annotation.Remote;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.dispatcher.MessageHandler;
import lombok.extern.slf4j.Slf4j;
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
public class HeroScoreRankService extends AbstractRankService<Promotion092GMsg.PSHeroScoreRank> implements MessageHandler {

    private List<Promotion092HeroData> rankList = new ArrayList<>();
    private Map<Long, Promotion092HeroData> map = new ConcurrentHashMap<>();

//    @Autowired
//    private Promotion092Service promotion092Service;

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
    public Promotion092GMsg.PSHeroScoreRank builder(Rank rank) {
        Promotion092GMsg.PSHeroScoreRank.Builder builder = Promotion092GMsg.PSHeroScoreRank.newBuilder();
        builder.setRank(topN.getRank(rank.getRankId()));
        builder.setScore((int) rank.getRankValue());
        builder.setHeroType(map.get(rank.getRankId()).getHeroType());
        return builder.build();
    }

    @Override
    public Promotion092GMsg.PSHeroScoreRank builderForNotRank(long rankId) {
        return null;
    }

    @RemoteMethod
    public void replaceRank(Promotion092HeroRankResMessage message) {
        try {
            List<Promotion092HeroData> ranks = message.getRankDataList() == null ? new ArrayList<>() : message.getRankDataList();
            rankList = ranks;
            log.debug("献花排行榜英雄榜更新数据量:{}", ranks.size());
            if (rankList.size() != 0) {
                Map<Long, Promotion092HeroData> collect = ranks.stream().collect(Collectors.toMap(Promotion092HeroData::getRankId, Function.identity()));
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
        return RankType.PROMOTION_092_HERO_SCORE;
    }
}
