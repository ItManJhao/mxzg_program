package com.ayjs.mxzg.gameserver.module.promotionNew.promotion080.observer;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.config.excel.entity.promotion080.CPromotion080Mission;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion080.converter.Promotion080PB;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion080.domain.Promotion080;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion080.service.Promotion080Service;
import com.ayjs.mxzg.gameserver.module.promotionNew.struct.MissionInfo;
import com.ayjs.mxzg.gameserver.module.targetCounter.event.RoleTriggerTargetEvent;
import com.ayjs.mxzg.protocol.Promotion080GMsg;
import com.google.common.collect.Lists;
import org.springframework.beans.factory.annotation.Autowired;

import java.time.LocalDate;
import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2020/9/23
 **/
@Observer
public class Promotion080Observer {

    @Autowired
    private Promotion080Service promotion080Service;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private Promotion080PB promotion080PB;

    @Subscribe
    public void listen(RoleTriggerTargetEvent event) {
        List<CPromotion080Mission> configList = promotion080Service.getMissionConfigByTarget(event.getTargetStruct());
        if (CollectionUtil.isEmpty(configList)) {
            return;
        }

        List<CPromotion080Mission> updateList = Lists.newArrayList();
        Promotion080 promotionInfo = promotion080Service.getPromotionInfo(event.getRid());
        configList.forEach(config -> {
            if (LocalDate.now().isEqual(promotionInfo.getLoginRecord())) {
                promotionInfo.setLoginRecord(LocalDate.now());
            }

            MissionInfo missionInfo = promotionInfo.getMissionInfoMap().computeIfAbsent(config.getIdx(), key -> MissionInfo.valueOf(config.getIdx()));
            if (missionInfo.getProcess() < config.getTarget().getTarget()) {
                updateList.add(config);
            }

            if (event.getAddOrSet() == RoleTriggerTargetEvent.MethodName.ADD) {
                missionInfo.setProcess(missionInfo.getProcess() + event.getTriggerCount());
            } else {
                missionInfo.setProcess(event.getTriggerCount());
            }

            promotion080Service.updatePromotion(promotionInfo);
        });

        if (CollectionUtil.isEmpty(updateList)) {
            return;
        }

        Promotion080GMsg.GResHalloweenMissionUpdateProcess.Builder builder = Promotion080GMsg.GResHalloweenMissionUpdateProcess.newBuilder();
        updateList.forEach(config -> {
            MissionInfo missionInfo = promotionInfo.getMissionInfoMap().computeIfAbsent(config.getIdx(), key -> MissionInfo.valueOf(config.getIdx()));
            builder.addMission(promotion080PB.builderMission(missionInfo));
        });

        contextManager.write(event.getRid(), CmdCode._75943, builder.build());

    }


}
