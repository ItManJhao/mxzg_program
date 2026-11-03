package com.ayjs.mxzg.gameserver.module.promotionNew.promotion085.converter;

import com.ayjs.mxzg.config.excel.cache.promotion085.Promotion085MissionSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion085.CPromotion085Mission;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion085.domain.Promotion085;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion085.service.Promotion085Service;
import com.ayjs.mxzg.gameserver.module.promotionNew.struct.MissionInfo;
import com.ayjs.mxzg.protocol.Promotion070GMsg;
import com.ayjs.mxzg.protocol.Promotion085GMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Objects;

/**
 * @Author: CWJ
 * @Date: 2020/9/22
 **/
@Component
public class Promotion085PB {

    @Autowired
    private Promotion085Service promotion085Service;
    @Autowired
    private Promotion085MissionSysCache promotion085MissionSysCache;

    public Promotion085GMsg.GResChristmasMissionGetDataInfo buildData(Promotion085 promotionInfo) {
        Promotion085GMsg.GResChristmasMissionGetDataInfo.Builder builder = Promotion085GMsg.GResChristmasMissionGetDataInfo.newBuilder();
        promotion085Service.getMissionConfigsByDay().forEach(config -> {
            MissionInfo missionInfo = promotionInfo.getMissionInfoMap().get(config.getIdx());
            if (Objects.nonNull(missionInfo)) {
                builder.addMission(builderMission(missionInfo));
            }
        });
        builder.addAllMissionBoxRewardRecord(promotionInfo.getMissionBoxRecord());
        builder.setOpenDay(promotion085Service.getOpenDay());
        return builder.build();
    }

    public Promotion070GMsg.PSMission builderMission(MissionInfo missionInfo) {
        Promotion070GMsg.PSMission.Builder builder = Promotion070GMsg.PSMission.newBuilder();
        builder.setIdx(missionInfo.getIdx());
        builder.setHadReward(missionInfo.isHadReward());

        CPromotion085Mission cPromotion085Mission = promotion085MissionSysCache.getById(missionInfo.getIdx());

        builder.setProcess(Math.min(cPromotion085Mission.getTarget().getTarget(), missionInfo.getProcess()));
        return builder.build();
    }


    public Promotion085GMsg.GResChristmasMissionGetMission builderGetMission(MissionInfo missionInfo) {
        Promotion085GMsg.GResChristmasMissionGetMission.Builder builder = Promotion085GMsg.GResChristmasMissionGetMission.newBuilder();
        builder.setMissionInfo(builderMission(missionInfo));
        return builder.build();
    }


    public Promotion085GMsg.GResChristmasMissionGetMissionBox buildGetMissionBox(int idx) {
        Promotion085GMsg.GResChristmasMissionGetMissionBox.Builder builder = Promotion085GMsg.GResChristmasMissionGetMissionBox.newBuilder();
        builder.setIdx(idx);
        return builder.build();
    }
}
