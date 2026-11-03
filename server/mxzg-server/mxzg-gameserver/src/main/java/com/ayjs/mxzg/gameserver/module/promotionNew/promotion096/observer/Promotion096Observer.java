package com.ayjs.mxzg.gameserver.module.promotionNew.promotion096.observer;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.config.excel.entity.promotion096.CPromotion096Mission;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion096.converter.Promotion096PB;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion096.domain.Promotion096;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion096.service.Promotion096Service;
import com.ayjs.mxzg.gameserver.module.promotionNew.struct.MissionInfo;
import com.ayjs.mxzg.gameserver.module.targetCounter.event.RoleTriggerTargetEvent;
import com.ayjs.mxzg.protocol.Promotion096GMsg;
import com.google.common.collect.Lists;
import org.springframework.beans.factory.annotation.Autowired;

import java.time.LocalDate;
import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2020/9/23
 **/
@Observer
public class Promotion096Observer {

    @Autowired
    private Promotion096Service promotion096Service;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private Promotion096PB promotion096PB;

    @Subscribe
    public void listen(RoleTriggerTargetEvent event) {
        List<CPromotion096Mission> configList = promotion096Service.getMissionConfigByTarget(event.getTargetStruct());
        if (CollectionUtil.isEmpty(configList)) {
            return;
        }

        List<CPromotion096Mission> updateList = Lists.newArrayList();
        Promotion096 promotionInfo = promotion096Service.getPromotionInfo(event.getRid());
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

            promotion096Service.updatePromotion(promotionInfo);
        });

        if (CollectionUtil.isEmpty(updateList)) {
            return;
        }

        Promotion096GMsg.GResSpringOutingMissionUpdateProcess.Builder builder = Promotion096GMsg.GResSpringOutingMissionUpdateProcess.newBuilder();
        updateList.forEach(config -> {
            MissionInfo missionInfo = promotionInfo.getMissionInfoMap().computeIfAbsent(config.getIdx(), key -> MissionInfo.valueOf(config.getIdx()));
            builder.addMission(promotion096PB.builderMission(missionInfo));
        });

        contextManager.write(event.getRid(), CmdCode._76303, builder.build());

    }


}
