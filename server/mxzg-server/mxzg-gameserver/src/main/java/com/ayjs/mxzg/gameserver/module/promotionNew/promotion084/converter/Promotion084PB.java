package com.ayjs.mxzg.gameserver.module.promotionNew.promotion084.converter;

import com.ayjs.mxzg.gameserver.module.promotionNew.promotion084.domain.Promotion084;
import com.ayjs.mxzg.protocol.Promotion084GMsg;
import org.springframework.stereotype.Component;

/**
 * @Author: CWJ
 * @Date: 2020/9/22
 **/
@Component
public class Promotion084PB {

    public Promotion084GMsg.GResThreeDay buildData(Promotion084 promotionInfo) {
        Promotion084GMsg.GResThreeDay.Builder builder = Promotion084GMsg.GResThreeDay.newBuilder();
        promotionInfo.getRechargeInfo().forEach((day, recharge) -> {
            builder.addRechargeInfo(builderRechargeInfo(day, recharge));
        });
        builder.addAllRewardRecord(promotionInfo.getRewardRecord());
        builder.setCurrDay(promotionInfo.getCurrDay());

        return builder.build();
    }

    public Promotion084GMsg.PSThreeDayRechargeInfo builderRechargeInfo(int day, long recharge) {
        Promotion084GMsg.PSThreeDayRechargeInfo.Builder builder = Promotion084GMsg.PSThreeDayRechargeInfo.newBuilder();
        builder.setDay(day);
        builder.setRecharge(recharge);
        return builder.build();
    }

    public Promotion084GMsg.GResThreeDayGet buildGet(int rewardIdx) {
        Promotion084GMsg.GResThreeDayGet.Builder builder = Promotion084GMsg.GResThreeDayGet.newBuilder();
        builder.setIdx(rewardIdx);
        return builder.build();
    }

    public Promotion084GMsg.GResThreeDayUpdateRecharge buildUpdateRecharge(Promotion084 promotionInfo) {
        Promotion084GMsg.GResThreeDayUpdateRecharge.Builder builder = Promotion084GMsg.GResThreeDayUpdateRecharge.newBuilder();
        builder.setRechargeInfo(builderRechargeInfo(promotionInfo.getCurrDay(),
                promotionInfo.getRechargeInfo().getOrDefault(promotionInfo.getCurrDay(), 0l)));
        return builder.build();
    }


}
