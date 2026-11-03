package com.ayjs.mxzg.gameserver.module.promotionNew.promotion077.converter;

import com.ayjs.mxzg.config.excel.cache.promotion077.Promotion077MissionSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion077.CPromotion077Mission;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion077.domain.Promotion077;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion077.service.Promotion077Service;
import com.ayjs.mxzg.gameserver.module.promotionNew.struct.MissionInfo;
import com.ayjs.mxzg.protocol.Promotion070GMsg;
import com.ayjs.mxzg.protocol.Promotion077GMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Objects;

/**
 * @Author: CWJ
 * @Date: 2020/9/22
 **/
@Component
public class Promotion077PB {

    @Autowired
    private Promotion077Service promotion077Service;
    @Autowired
    private Promotion077MissionSysCache promotion077MissionSysCache;

    public Promotion077GMsg.GResMidMissionGetDataInfo buildData(Promotion077 promotionInfo) {
        Promotion077GMsg.GResMidMissionGetDataInfo.Builder builder = Promotion077GMsg.GResMidMissionGetDataInfo.newBuilder();
        promotion077Service.getMissionConfigsByDay().forEach(config -> {
            MissionInfo missionInfo = promotionInfo.getMissionInfoMap().get(config.getIdx());
            if (Objects.nonNull(missionInfo)) {
                builder.addMission(builderMission(missionInfo));
            }
        });
        builder.addAllMissionBoxRewardRecord(promotionInfo.getMissionBoxRecord());
        builder.setOpenDay(promotion077Service.getOpenDay());
        return builder.build();
    }

    public Promotion070GMsg.PSMission builderMission(MissionInfo missionInfo) {
        Promotion070GMsg.PSMission.Builder builder = Promotion070GMsg.PSMission.newBuilder();
        builder.setIdx(missionInfo.getIdx());
        builder.setHadReward(missionInfo.isHadReward());

        CPromotion077Mission cPromotion077Mission = promotion077MissionSysCache.getById(missionInfo.getIdx());

        builder.setProcess(Math.min(cPromotion077Mission.getTarget().getTarget(), missionInfo.getProcess()));
        return builder.build();
    }


    public Promotion077GMsg.GResMidMissionGetMission builderGetMission(MissionInfo missionInfo) {
        Promotion077GMsg.GResMidMissionGetMission.Builder builder = Promotion077GMsg.GResMidMissionGetMission.newBuilder();
        builder.setMissionInfo(builderMission(missionInfo));
        return builder.build();
    }


    public Promotion077GMsg.GResMidMissionGetMissionBox buildGetMissionBox(int idx) {
        Promotion077GMsg.GResMidMissionGetMissionBox.Builder builder = Promotion077GMsg.GResMidMissionGetMissionBox.newBuilder();
        builder.setIdx(idx);
        return builder.build();
    }
}
