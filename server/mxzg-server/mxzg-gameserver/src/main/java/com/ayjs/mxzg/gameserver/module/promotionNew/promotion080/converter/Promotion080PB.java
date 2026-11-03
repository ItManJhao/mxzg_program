package com.ayjs.mxzg.gameserver.module.promotionNew.promotion080.converter;

import com.ayjs.mxzg.config.excel.cache.promotion080.Promotion080MissionSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion080.CPromotion080Mission;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion080.domain.Promotion080;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion080.service.Promotion080Service;
import com.ayjs.mxzg.gameserver.module.promotionNew.struct.MissionInfo;
import com.ayjs.mxzg.protocol.Promotion070GMsg;
import com.ayjs.mxzg.protocol.Promotion080GMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Objects;

/**
 * @Author: CWJ
 * @Date: 2020/9/22
 **/
@Component
public class Promotion080PB {

    @Autowired
    private Promotion080Service promotion080Service;
    @Autowired
    private Promotion080MissionSysCache promotion080MissionSysCache;

    public Promotion080GMsg.GResHalloweenMissionGetDataInfo buildData(Promotion080 promotionInfo) {
        Promotion080GMsg.GResHalloweenMissionGetDataInfo.Builder builder = Promotion080GMsg.GResHalloweenMissionGetDataInfo.newBuilder();
        promotion080Service.getMissionConfigsByDay().forEach(config -> {
            MissionInfo missionInfo = promotionInfo.getMissionInfoMap().get(config.getIdx());
            if (Objects.nonNull(missionInfo)) {
                builder.addMission(builderMission(missionInfo));
            }
        });
        builder.addAllMissionBoxRewardRecord(promotionInfo.getMissionBoxRecord());
        builder.setOpenDay(promotion080Service.getOpenDay());
        return builder.build();
    }

    public Promotion070GMsg.PSMission builderMission(MissionInfo missionInfo) {
        Promotion070GMsg.PSMission.Builder builder = Promotion070GMsg.PSMission.newBuilder();
        builder.setIdx(missionInfo.getIdx());
        builder.setHadReward(missionInfo.isHadReward());

        CPromotion080Mission cPromotion080Mission = promotion080MissionSysCache.getById(missionInfo.getIdx());

        builder.setProcess(Math.min(cPromotion080Mission.getTarget().getTarget(), missionInfo.getProcess()));
        return builder.build();
    }


    public Promotion080GMsg.GResHalloweenMissionGetMission builderGetMission(MissionInfo missionInfo) {
        Promotion080GMsg.GResHalloweenMissionGetMission.Builder builder = Promotion080GMsg.GResHalloweenMissionGetMission.newBuilder();
        builder.setMissionInfo(builderMission(missionInfo));
        return builder.build();
    }


    public Promotion080GMsg.GResHalloweenMissionGetMissionBox buildGetMissionBox(int idx) {
        Promotion080GMsg.GResHalloweenMissionGetMissionBox.Builder builder = Promotion080GMsg.GResHalloweenMissionGetMissionBox.newBuilder();
        builder.setIdx(idx);
        return builder.build();
    }
}
