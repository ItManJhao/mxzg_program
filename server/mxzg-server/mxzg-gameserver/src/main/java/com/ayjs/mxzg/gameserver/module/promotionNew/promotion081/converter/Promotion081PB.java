package com.ayjs.mxzg.gameserver.module.promotionNew.promotion081.converter;

import com.ayjs.mxzg.config.excel.cache.promotion081.Promotion081MissionSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion081.CPromotion081Mission;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion081.domain.Promotion081;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion081.service.Promotion081Service;
import com.ayjs.mxzg.gameserver.module.promotionNew.struct.MissionInfo;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.protocol.Promotion070GMsg;
import com.ayjs.mxzg.protocol.Promotion081GMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * @Author: CWJ
 * @Date: 2020/9/22
 **/
@Component
public class Promotion081PB {

    @Autowired
    private Promotion081Service promotion081Service;
    @Autowired
    private Promotion081MissionSysCache promotion081MissionSysCache;

    public Promotion081GMsg.GResBlackFiveMissionGetDataInfo buildData(Promotion081 promotionInfo) {
        Promotion081GMsg.GResBlackFiveMissionGetDataInfo.Builder builder = Promotion081GMsg.GResBlackFiveMissionGetDataInfo.newBuilder();
//        promotion081MissionSysCache.getAll().forEach(config -> {
//            MissionInfo missionInfo = promotionInfo.getMissionInfoMap().get(config.getIdx());
//            if (Objects.nonNull(missionInfo)) {
//                builder.addMission(Promotion070Converter.builderMission(missionInfo));
//            }
//        });

        promotionInfo.getMissionInfoMap().forEach((key, value) -> {
            builder.addMission(builderMission(value));
        });
        builder.addAllMissionBoxRewardRecord(promotionInfo.getMissionBoxRecord());
        builder.setMissionRewardCount(promotionInfo.getMissionRewardCount());
        promotionInfo.getBuyRecord().forEach((key, value) -> {
            builder.addBuy(PbUtil.builderMap(key, value));
        });
        return builder.build();
    }

    public Promotion070GMsg.PSMission builderMission(MissionInfo missionInfo) {
        Promotion070GMsg.PSMission.Builder builder = Promotion070GMsg.PSMission.newBuilder();
        builder.setIdx(missionInfo.getIdx());
        builder.setHadReward(missionInfo.isHadReward());

        CPromotion081Mission promotion081Mission = promotion081MissionSysCache.getById(missionInfo.getIdx());

        builder.setProcess(Math.min(promotion081Mission.getTarget().getTarget(), missionInfo.getProcess()));
        return builder.build();
    }


    public Promotion081GMsg.GResBlackFiveMissionGetMission builderGetMission(MissionInfo missionInfo, int count) {
        Promotion081GMsg.GResBlackFiveMissionGetMission.Builder builder = Promotion081GMsg.GResBlackFiveMissionGetMission.newBuilder();
        builder.setMissionInfo(builderMission(missionInfo));
        builder.setMissionRewardCount(count);
        return builder.build();
    }


    public Promotion081GMsg.GResBlackFiveMissionGetMissionBox buildGetMissionBox(int idx) {
        Promotion081GMsg.GResBlackFiveMissionGetMissionBox.Builder builder = Promotion081GMsg.GResBlackFiveMissionGetMissionBox.newBuilder();
        builder.setIdx(idx);
        return builder.build();
    }

    public Promotion081GMsg.GResBlackFiveMissionGiftBuy buildMissionGiftBuy(long rid, int idx) {
        Promotion081 promotionInfo = promotion081Service.getPromotionInfo(rid);
        Promotion081GMsg.GResBlackFiveMissionGiftBuy.Builder builder = Promotion081GMsg.GResBlackFiveMissionGiftBuy.newBuilder();
        builder.setBuy(PbUtil.builderMap(idx, promotionInfo.getBuyRecord().getOrDefault(idx, 0)));
        return builder.build();
    }
}
