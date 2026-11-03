package com.ayjs.mxzg.gameserver.module.promotionNew.promotion081.observer;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.config.excel.entity.promotion081.CPromotion081Mission;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion081.converter.Promotion081PB;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion081.domain.Promotion081;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion081.service.Promotion081Service;
import com.ayjs.mxzg.gameserver.module.promotionNew.struct.MissionInfo;
import com.ayjs.mxzg.gameserver.module.targetCounter.event.RoleTriggerTargetEvent;
import com.ayjs.mxzg.protocol.Promotion081GMsg;
import com.google.common.collect.Lists;
import org.springframework.beans.factory.annotation.Autowired;

import java.time.LocalDate;
import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2020/9/23
 **/
@Observer
public class Promotion081Observer {

    @Autowired
    private Promotion081Service promotion081Service;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private Promotion081PB promotion081PB;

    @Subscribe
    public void listen(RoleTriggerTargetEvent event) {
        List<CPromotion081Mission> configList = promotion081Service.getMissionConfigByTarget(event.getTargetStruct());
        if (CollectionUtil.isEmpty(configList)) {
            return;
        }

        List<CPromotion081Mission> updateList = Lists.newArrayList();
        Promotion081 promotionInfo = promotion081Service.getPromotionInfo(event.getRid());
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

            promotion081Service.updatePromotion(promotionInfo);
        });

        if (CollectionUtil.isEmpty(updateList)) {
            return;
        }

        Promotion081GMsg.GResBlackFiveMissionUpdateProcess.Builder builder = Promotion081GMsg.GResBlackFiveMissionUpdateProcess.newBuilder();
        updateList.forEach(config -> {
            MissionInfo missionInfo = promotionInfo.getMissionInfoMap().computeIfAbsent(config.getIdx(), key -> MissionInfo.valueOf(config.getIdx()));
            builder.addMission(promotion081PB.builderMission(missionInfo));
        });

        contextManager.write(event.getRid(), CmdCode._76003, builder.build());

    }


}
