package com.ayjs.mxzg.gameserver.module.promotionNew.converter;

import com.ayjs.mxzg.common.base.SpringProxy;
import com.ayjs.mxzg.config.excel.cache.promotion070.Promotion070MissionSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion070.CPromotion070Mission;
import com.ayjs.mxzg.gameserver.module.promotionNew.struct.MissionInfo;
import com.ayjs.mxzg.protocol.Promotion070GMsg;

import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2020/8/10
 **/
public class Promotion070Converter {

    public static Promotion070GMsg.PSSelectInfo builderSelectInfo(int idx, List<Integer> rewardIds) {
        Promotion070GMsg.PSSelectInfo.Builder builder = Promotion070GMsg.PSSelectInfo.newBuilder();
        builder.setIdx(idx);
        builder.addAllRewardId(rewardIds);
        return builder.build();
    }

    public static Promotion070GMsg.PSMission builderMission(MissionInfo missionInfo) {
        Promotion070GMsg.PSMission.Builder builder = Promotion070GMsg.PSMission.newBuilder();
        builder.setIdx(missionInfo.getIdx());
        builder.setHadReward(missionInfo.isHadReward());

        Promotion070MissionSysCache bean = SpringProxy.getBean(Promotion070MissionSysCache.class);
        CPromotion070Mission cPromotion070Mission = bean.getById(missionInfo.getIdx());

        builder.setProcess(Math.min(cPromotion070Mission.getTarget().getTarget(), missionInfo.getProcess()));
        return builder.build();
    }
}
