package com.ayjs.mxzg.gameserver.module.promotionNew.promotion097.converter;

import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion097.domain.Promotion097;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion097.service.Promotion097Service;
import com.ayjs.mxzg.protocol.Promotion097GMsg.LaborDayLuckDrawData;
import com.ayjs.mxzg.protocol.Promotion097GMsg.GResLaborDayLuckDrawChoice;
import com.ayjs.mxzg.protocol.Promotion097GMsg.GResLaborDayLuckDraw;
import com.ayjs.mxzg.protocol.Promotion097GMsg.GResLaborDayLuckDrawGetDataInfo;
import com.google.common.collect.ImmutableList;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.*;

@Component
public class Promotion097PB {

    @Autowired
    private Promotion097Service promotion097Service;

    public GResLaborDayLuckDrawGetDataInfo buildDataInfo(Promotion097 promotion097) {
        GResLaborDayLuckDrawGetDataInfo.Builder proto = GResLaborDayLuckDrawGetDataInfo.newBuilder();
        int curRound = promotion097.getCurRound();
        Set<Integer> curRoundRewardSet = promotion097.getRewardRecordMap().get(curRound);
        List<LaborDayLuckDrawData> rewardsList = buildChoiceRewardList(promotion097);
        // 数据组装
        proto.setTimes(promotion097.getTimes());
        proto.setResetTimes(promotion097.getLeftResetTime());
        proto.addAllRewardRecord(new ArrayList<>(curRoundRewardSet));
        proto.addAllRewards(rewardsList);
        proto.setCurRound(curRound);
        return proto.build();
    }

    public GResLaborDayLuckDraw buildLuckDrawInfo(Promotion097 promotion097, ImmutableThing reward, int position) {
        int curRound = promotion097.getCurRound();
        Map<Integer, Set<Integer>> recordMap = promotion097.getRewardRecordMap();
        Set<Integer> curRoundRewardSet = recordMap.get(curRound);
        LaborDayLuckDrawData.Builder data = LaborDayLuckDrawData.newBuilder();
        data.setNum(reward.getNum());
        data.setId(reward.getThingId());
        data.setPosition(position);

        GResLaborDayLuckDraw.Builder proto = GResLaborDayLuckDraw.newBuilder();
        proto.addAllRewardRecord(new ArrayList<>(curRoundRewardSet));
        proto.setReward(data.build());
        return proto.build();
    }

    public GResLaborDayLuckDrawChoice buildLuckDrawChoiceInfo(Promotion097 promotion097, int position) {
        List<LaborDayLuckDrawData> rewardList = buildChoiceRewardList(promotion097);
        GResLaborDayLuckDrawChoice.Builder proto = GResLaborDayLuckDrawChoice.newBuilder();
        proto.addAllRewards(rewardList);
        proto.setPosition(position);
        return proto.build();
    }

    private List<LaborDayLuckDrawData> buildChoiceRewardList(Promotion097 promotion097) {
        int curRound = promotion097.getCurRound();
        List<LaborDayLuckDrawData> rewardsList = new ArrayList<>();
        Map<Integer, Integer> choiceRewardMap = promotion097.getChoiceRewardMap();
        for (Map.Entry<Integer, Integer> entry : choiceRewardMap.entrySet()) {
            LaborDayLuckDrawData.Builder itemInfo = LaborDayLuckDrawData.newBuilder();
            // 拿到这一轮这个位置上的奖励配置
            ImmutableList<ImmutableThing> rewards = promotion097Service.getDataByTurnsAndPos(curRound, entry.getKey()).getRewardThings();
            // 根据玩家所选的奖励id去配置表拿数量
            for (ImmutableThing reward : rewards) {
                if (reward.getThingId() == entry.getValue()) {
                    itemInfo.setId(reward.getThingId());
                    itemInfo.setNum(reward.getNum());
                    itemInfo.setPosition(entry.getKey());
                }
            }
            rewardsList.add(itemInfo.build());
        }
        return rewardsList;
    }
}
