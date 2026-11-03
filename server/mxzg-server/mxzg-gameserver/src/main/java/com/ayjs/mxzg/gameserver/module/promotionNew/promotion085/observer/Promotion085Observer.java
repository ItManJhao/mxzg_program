package com.ayjs.mxzg.gameserver.module.promotionNew.promotion085.observer;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.config.excel.entity.promotion085.CPromotion085Mission;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion085.converter.Promotion085PB;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion085.domain.Promotion085;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion085.service.Promotion085Service;
import com.ayjs.mxzg.gameserver.module.promotionNew.struct.MissionInfo;
import com.ayjs.mxzg.gameserver.module.targetCounter.event.RoleTriggerTargetEvent;
import com.ayjs.mxzg.protocol.Promotion085GMsg;
import com.google.common.collect.Lists;
import org.springframework.beans.factory.annotation.Autowired;

import java.time.LocalDate;
import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2020/9/23
 **/
@Observer
public class Promotion085Observer {

    @Autowired
    private Promotion085Service promotion085Service;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private Promotion085PB promotion085PB;

    @Subscribe
    public void listen(RoleTriggerTargetEvent event) {
        List<CPromotion085Mission> configList = promotion085Service.getMissionConfigByTarget(event.getTargetStruct());
        if (CollectionUtil.isEmpty(configList)) {
            return;
        }

        List<CPromotion085Mission> updateList = Lists.newArrayList();
        Promotion085 promotionInfo = promotion085Service.getPromotionInfo(event.getRid());
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

            promotion085Service.updatePromotion(promotionInfo);
        });

        if (CollectionUtil.isEmpty(updateList)) {
            return;
        }

        Promotion085GMsg.GResChristmasMissionUpdateProcess.Builder builder = Promotion085GMsg.GResChristmasMissionUpdateProcess.newBuilder();
        updateList.forEach(config -> {
            MissionInfo missionInfo = promotionInfo.getMissionInfoMap().computeIfAbsent(config.getIdx(), key -> MissionInfo.valueOf(config.getIdx()));
            builder.addMission(promotion085PB.builderMission(missionInfo));
        });

        contextManager.write(event.getRid(), CmdCode._76083, builder.build());

    }


}
