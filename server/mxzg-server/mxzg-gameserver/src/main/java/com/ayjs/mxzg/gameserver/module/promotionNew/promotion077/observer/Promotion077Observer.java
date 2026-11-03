package com.ayjs.mxzg.gameserver.module.promotionNew.promotion077.observer;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.config.excel.entity.promotion077.CPromotion077Mission;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion077.converter.Promotion077PB;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion077.domain.Promotion077;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion077.service.Promotion077Service;
import com.ayjs.mxzg.gameserver.module.promotionNew.struct.MissionInfo;
import com.ayjs.mxzg.gameserver.module.targetCounter.event.RoleTriggerTargetEvent;
import com.ayjs.mxzg.protocol.Promotion077GMsg;
import com.google.common.collect.Lists;
import org.springframework.beans.factory.annotation.Autowired;

import java.time.LocalDate;
import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2020/9/23
 **/
@Observer
public class Promotion077Observer {

    @Autowired
    private Promotion077Service promotion077Service;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private Promotion077PB promotion077PB;

    @Subscribe
    public void listen(RoleTriggerTargetEvent event) {
        List<CPromotion077Mission> configList = promotion077Service.getMissionConfigByTarget(event.getTargetStruct());
        if (CollectionUtil.isEmpty(configList)) {
            return;
        }

        List<CPromotion077Mission> updateList = Lists.newArrayList();
        Promotion077 promotionInfo = promotion077Service.getPromotionInfo(event.getRid());
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

            promotion077Service.updatePromotion(promotionInfo);
        });

        if (CollectionUtil.isEmpty(updateList)) {
            return;
        }

        Promotion077GMsg.GResMidMissionUpdateProcess.Builder builder = Promotion077GMsg.GResMidMissionUpdateProcess.newBuilder();
        updateList.forEach(config -> {
            MissionInfo missionInfo = promotionInfo.getMissionInfoMap().computeIfAbsent(config.getIdx(), key -> MissionInfo.valueOf(config.getIdx()));
            builder.addMission(promotion077PB.builderMission(missionInfo));
        });

        contextManager.write(event.getRid(), CmdCode._75843, builder.build());

    }


}
