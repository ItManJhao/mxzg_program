package com.ayjs.mxzg.gameserver.module.promotionNew.promotion074.converter;

import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion074.domain.Promotion074;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion074.service.Promotion074Service;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.protocol.Promotion074GMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2020/9/22
 **/
@Component
public class Promotion074PB {

    @Autowired
    private Promotion074Service promotion074Service;

    public Promotion074GMsg.GResMidLotteryGetDataInfo buildData(Promotion074 promotionInfo) {
        Promotion074GMsg.GResMidLotteryGetDataInfo.Builder builder = Promotion074GMsg.GResMidLotteryGetDataInfo.newBuilder();

        //只有一条记录
        promotionInfo.getSelectInfo().forEach((key, value) -> {
            builder.setSelectInfo(PbUtil.builderMap(key, value));
        });

        builder.setLotteryCount(promotionInfo.getLotteryCount());
        builder.addAllLotteryReward(promotionInfo.getLotteryCountRecord());
        builder.setLotteryBestRemainingCount(promotion074Service.getBestConfig().getMax_count() - promotionInfo.getLotteryTurnCount());
        return builder.build();
    }

    public Promotion074GMsg.GResMidLotterySelect buildSelect(int rewardIdx, int rewardIndex) {
        Promotion074GMsg.GResMidLotterySelect.Builder builder = Promotion074GMsg.GResMidLotterySelect.newBuilder();
        builder.setSelectInfo(PbUtil.builderMap(rewardIdx, rewardIndex));
        return builder.build();
    }

    public Promotion074GMsg.GResMidLotteryLottery buildLottery(Promotion074 promotionInfo, List<ImmutableThing> reward, int idx) {
        Promotion074GMsg.GResMidLotteryLottery.Builder builder = Promotion074GMsg.GResMidLotteryLottery.newBuilder();
        builder.addAllReward(PbUtil.buildReward(reward));
        builder.setLotteryBestRemainingCount(promotion074Service.getBestConfig().getMax_count() - promotionInfo.getLotteryTurnCount());
        builder.setIdx(idx);
        builder.setLotteryCount(promotionInfo.getLotteryCount());
        return builder.build();
    }

    public Promotion074GMsg.GResMidLotteryGetLotteryCountReward buildGetLotteryCount(int idx) {
        Promotion074GMsg.GResMidLotteryGetLotteryCountReward.Builder builder = Promotion074GMsg.GResMidLotteryGetLotteryCountReward.newBuilder();
        builder.setIdx(idx);
        return builder.build();
    }

}
