package com.ayjs.mxzg.gameserver.module.promotionNew.promotion083.converter;

import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion083.domain.Promotion083;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion083.service.Promotion083Service;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.protocol.Promotion083GMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2020/9/22
 **/
@Component
public class Promotion083PB {

    @Autowired
    private Promotion083Service promotion083Service;

    public Promotion083GMsg.GResBlackFiveLotteryGetDataInfo buildData(Promotion083 promotionInfo) {
        Promotion083GMsg.GResBlackFiveLotteryGetDataInfo.Builder builder = Promotion083GMsg.GResBlackFiveLotteryGetDataInfo.newBuilder();

        //只有一条记录
        promotionInfo.getSelectInfo().forEach((key, value) -> {
            builder.setSelectInfo(PbUtil.builderMap(key, value));
        });

        builder.setLotteryCount(promotionInfo.getLotteryCount());
        builder.addAllLotteryReward(promotionInfo.getLotteryCountRecord());
        builder.setLotteryBestRemainingCount(promotion083Service.getBestConfig().getMax_count() - promotionInfo.getLotteryTurnCount());
        builder.setLastLotteryId(promotionInfo.getLastLotteryIdx());
        return builder.build();
    }

    public Promotion083GMsg.GResBlackFiveLotterySelect buildSelect(int rewardIdx, int rewardIndex) {
        Promotion083GMsg.GResBlackFiveLotterySelect.Builder builder = Promotion083GMsg.GResBlackFiveLotterySelect.newBuilder();
        builder.setSelectInfo(PbUtil.builderMap(rewardIdx, rewardIndex));
        return builder.build();
    }

    public Promotion083GMsg.GResBlackFiveLotteryLottery buildLottery(Promotion083 promotionInfo, List<ImmutableThing> reward, int idx) {
        Promotion083GMsg.GResBlackFiveLotteryLottery.Builder builder = Promotion083GMsg.GResBlackFiveLotteryLottery.newBuilder();
        builder.addAllReward(PbUtil.buildReward(reward));
        builder.setLotteryBestRemainingCount(promotion083Service.getBestConfig().getMax_count() - promotionInfo.getLotteryTurnCount());
        builder.setIdx(idx);
        builder.setLotteryCount(promotionInfo.getLotteryCount());
        return builder.build();
    }

    public Promotion083GMsg.GResBlackFiveLotteryGetLotteryCountReward buildGetLotteryCount(int idx) {
        Promotion083GMsg.GResBlackFiveLotteryGetLotteryCountReward.Builder builder = Promotion083GMsg.GResBlackFiveLotteryGetLotteryCountReward.newBuilder();
        builder.setIdx(idx);
        return builder.build();
    }

}
