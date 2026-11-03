package com.ayjs.mxzg.gameserver.module.promotionNew.promotion078.converter;

import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion078.domain.Promotion078;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion078.service.Promotion078Service;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.protocol.Promotion078GMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2020/9/22
 **/
@Component
public class Promotion078PB {

    @Autowired
    private Promotion078Service promotion078Service;

    public Promotion078GMsg.GResHalloweenLotteryGetDataInfo buildData(Promotion078 promotionInfo) {
        Promotion078GMsg.GResHalloweenLotteryGetDataInfo.Builder builder = Promotion078GMsg.GResHalloweenLotteryGetDataInfo.newBuilder();

        //只有一条记录
        promotionInfo.getSelectInfo().forEach((key, value) -> {
            builder.setSelectInfo(PbUtil.builderMap(key, value));
        });

        builder.setLotteryCount(promotionInfo.getLotteryCount());
        builder.addAllLotteryReward(promotionInfo.getLotteryCountRecord());
        builder.setLotteryBestRemainingCount(promotion078Service.getBestConfig().getMax_count() - promotionInfo.getLotteryTurnCount());
        builder.setLastLotteryId(promotionInfo.getLastLotteryIdx());
        return builder.build();
    }

    public Promotion078GMsg.GResHalloweenLotterySelect buildSelect(int rewardIdx, int rewardIndex) {
        Promotion078GMsg.GResHalloweenLotterySelect.Builder builder = Promotion078GMsg.GResHalloweenLotterySelect.newBuilder();
        builder.setSelectInfo(PbUtil.builderMap(rewardIdx, rewardIndex));
        return builder.build();
    }

    public Promotion078GMsg.GResHalloweenLotteryLottery buildLottery(Promotion078 promotionInfo, List<ImmutableThing> reward, int idx) {
        Promotion078GMsg.GResHalloweenLotteryLottery.Builder builder = Promotion078GMsg.GResHalloweenLotteryLottery.newBuilder();
        builder.addAllReward(PbUtil.buildReward(reward));
        builder.setLotteryBestRemainingCount(promotion078Service.getBestConfig().getMax_count() - promotionInfo.getLotteryTurnCount());
        builder.setIdx(idx);
        builder.setLotteryCount(promotionInfo.getLotteryCount());
        return builder.build();
    }

    public Promotion078GMsg.GResHalloweenLotteryGetLotteryCountReward buildGetLotteryCount(int idx) {
        Promotion078GMsg.GResHalloweenLotteryGetLotteryCountReward.Builder builder = Promotion078GMsg.GResHalloweenLotteryGetLotteryCountReward.newBuilder();
        builder.setIdx(idx);
        return builder.build();
    }

}
