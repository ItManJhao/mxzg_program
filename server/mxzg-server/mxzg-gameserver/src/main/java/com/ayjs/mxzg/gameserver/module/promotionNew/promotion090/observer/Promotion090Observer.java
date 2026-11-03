package com.ayjs.mxzg.gameserver.module.promotionNew.promotion090.observer;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.config.excel.entity.promotion090.CPromotion090TrafficPermit;
import com.ayjs.mxzg.config.struct.TargetType;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion090.domain.Promotion090TrafficPermit;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion090.service.Promotion090TrafficPermitService;
import com.ayjs.mxzg.gameserver.module.targetCounter.event.RoleTriggerTargetEvent;
import org.springframework.beans.factory.annotation.Autowired;

import java.time.LocalDate;
import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2021/1/11
 **/
@Observer
public class Promotion090Observer {

    @Autowired
    private Promotion090TrafficPermitService promotion090TrafficPermitService;


    @Subscribe
    public void listen(RoleTriggerTargetEvent event) {
        long rid = event.getRid();
        List<CPromotion090TrafficPermit> configList = promotion090TrafficPermitService.getMissionConfigByTarget(event.getTargetStruct());
        if (CollectionUtil.isEmpty(configList)) {
            return;
        }
        if (!promotion090TrafficPermitService.isOpen()) {
            return;
        }

        Promotion090TrafficPermit promotionInfo = promotion090TrafficPermitService.getPromotionInfo(event.getRid());

        boolean loginTrigger = false;
        if (event.getTargetStruct().getType() == TargetType.LOGIN && !LocalDate.now().isEqual(promotionInfo.getLoginRecord())) {
            promotionInfo.setLoginRecord(LocalDate.now());
            promotion090TrafficPermitService.updatePromotion(promotionInfo);
            loginTrigger = true;
        }

        for (CPromotion090TrafficPermit config : configList) {
            if (config.getMission().getType() == TargetType.LOGIN && !loginTrigger) {
                continue;
            }
            promotion090TrafficPermitService.updatePromotionTask(rid, config, (int) event.getTriggerCount(),
                    event.getAddOrSet() == RoleTriggerTargetEvent.MethodName.ADD ? 0 : 1);
        }
    }

}
