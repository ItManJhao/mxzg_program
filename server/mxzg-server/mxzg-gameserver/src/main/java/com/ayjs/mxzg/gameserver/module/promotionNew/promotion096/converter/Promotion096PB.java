package com.ayjs.mxzg.gameserver.module.promotionNew.promotion096.converter;

import com.ayjs.mxzg.config.excel.cache.promotion096.Promotion096MissionSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion096.CPromotion096Mission;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion096.domain.Promotion096;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion096.service.Promotion096Service;
import com.ayjs.mxzg.gameserver.module.promotionNew.struct.MissionInfo;
import com.ayjs.mxzg.protocol.Promotion070GMsg;
import com.ayjs.mxzg.protocol.Promotion096GMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Objects;

/**
 * @Author: CWJ
 * @Date: 2020/9/22
 **/
@Component
public class Promotion096PB {

    @Autowired
    private Promotion096Service promotion096Service;
    @Autowired
    private Promotion096MissionSysCache promotion096MissionSysCache;

    public Promotion096GMsg.GResSpringOutingMissionGetDataInfo buildData(Promotion096 promotionInfo) {
        Promotion096GMsg.GResSpringOutingMissionGetDataInfo.Builder builder = Promotion096GMsg.GResSpringOutingMissionGetDataInfo.newBuilder();
        promotion096Service.getMissionConfigsByDay().forEach(config -> {
            MissionInfo missionInfo = promotionInfo.getMissionInfoMap().get(config.getIdx());
            if (Objects.nonNull(missionInfo)) {
                builder.addMission(builderMission(missionInfo));
            }
        });
        builder.addAllMissionBoxRewardRecord(promotionInfo.getMissionBoxRecord());
        builder.setOpenDay(promotion096Service.getOpenDay());
        return builder.build();
    }

    public Promotion070GMsg.PSMission builderMission(MissionInfo missionInfo) {
        Promotion070GMsg.PSMission.Builder builder = Promotion070GMsg.PSMission.newBuilder();
        builder.setIdx(missionInfo.getIdx());
        builder.setHadReward(missionInfo.isHadReward());

        CPromotion096Mission cPromotion096Mission = promotion096MissionSysCache.getById(missionInfo.getIdx());

        builder.setProcess(Math.min(cPromotion096Mission.getTarget().getTarget(), missionInfo.getProcess()));
        return builder.build();
    }

    public Promotion096GMsg.GResSpringOutingMissionGetMission builderGetMission(MissionInfo missionInfo) {
        Promotion096GMsg.GResSpringOutingMissionGetMission.Builder builder = Promotion096GMsg.GResSpringOutingMissionGetMission.newBuilder();
        builder.setMissionInfo(builderMission(missionInfo));
        return builder.build();
    }

    public Promotion096GMsg.GResSpringOutingMissionGetMissionBox buildGetMissionBox(int idx) {
        Promotion096GMsg.GResSpringOutingMissionGetMissionBox.Builder builder = Promotion096GMsg.GResSpringOutingMissionGetMissionBox.newBuilder();
        builder.setIdx(idx);
        return builder.build();
    }
}
