package com.ayjs.mxzg.gameserver.log.weekendkoi.observer;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.gameserver.log.weekendkoi.domain.WeekendKoiLog;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion067WeekendKoiSysInfo;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.event.WeekendKoiEvent;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion067WeekendKoiService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.template.log.LogEntityFactory;
import com.ayjs.mxzg.template.log.LogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Observer
@Service
public class WeekendKoiLogObserver {

    @Autowired
    private LogService logService;
    @Autowired
    private LogEntityFactory logEntityFactory;
    @Autowired
    private PromotionControlService promotionControlService;
    @Autowired
    private Promotion067WeekendKoiService promotion067WeekendKoiService;

    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    public void listen(WeekendKoiEvent event) {
        WeekendKoiLog log = logEntityFactory.create(WeekendKoiLog.class);
        log.setKoiRid(event.getRid());
        PromotionControl promotionControl = promotionControlService.getControl(PromotionType.ZHOU_MO_JIN_LI);
        log.setStartTime(promotionControl.getStartTime());
        log.setTurns(promotionControl.getTurns());
        log.setTime(DateTimeUtil.currentSecond());
        Promotion067WeekendKoiSysInfo sysInfo = promotion067WeekendKoiService.getPromotionSysInfo();
        log.setPhase(sysInfo.getPhase());
        logService.addLog(log);
    }

}
