package com.ayjs.mxzg.gameserver.module.promotionNew.observer;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.config.excel.entity.promotion070.CPromotion070Mission;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.promotionNew.converter.Promotion070Converter;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion070;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion070Service;
import com.ayjs.mxzg.gameserver.module.promotionNew.struct.MissionInfo;
import com.ayjs.mxzg.gameserver.module.targetCounter.event.RoleTriggerTargetEvent;
import com.ayjs.mxzg.protocol.Promotion070GMsg;
import com.google.common.collect.Lists;
import org.springframework.beans.factory.annotation.Autowired;

import java.time.LocalDate;
import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2020/8/7
 **/
@Observer
public class Promotion070Observer {

    @Autowired
    private Promotion070Service promotion070Service;
    @Autowired
    private ContextManager contextManager;

    @Subscribe
    public void listen(RoleTriggerTargetEvent event) {
        List<CPromotion070Mission> configList = promotion070Service.getMissionConfigByTarget(event.getTargetStruct());
        if (CollectionUtil.isEmpty(configList)) {
            return;
        }

        List<CPromotion070Mission> updateList = Lists.newArrayList();
        Promotion070 promotionInfo = promotion070Service.getPromotionInfo(event.getRid());
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

            promotion070Service.updatePromotion(promotionInfo);
        });

        if (CollectionUtil.isEmpty(updateList)) {
            return;
        }

        Promotion070GMsg.GResUpdateProcess.Builder builder = Promotion070GMsg.GResUpdateProcess.newBuilder();
        updateList.forEach(config -> {
            MissionInfo missionInfo = promotionInfo.getMissionInfoMap().computeIfAbsent(config.getIdx(), key -> MissionInfo.valueOf(config.getIdx()));
            builder.addMission(Promotion070Converter.builderMission(missionInfo));
        });

        contextManager.write(event.getRid(), CmdCode._75007, builder.build());

    }
}
