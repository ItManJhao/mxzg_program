package com.ayjs.mxzg.gameserver.module.monthCard.observer;

import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import org.springframework.beans.factory.annotation.Autowired;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion008CardSysCache;
import com.ayjs.mxzg.gameserver.module.monthCard.domain.MonthCard;
import com.ayjs.mxzg.gameserver.module.monthCard.event.MonthCardActiveEvent;
import com.ayjs.mxzg.gameserver.module.monthCard.serice.MonthCardService;
import com.ayjs.mxzg.gameserver.module.recharge.event.RechargeEvent;

/**
 * @Author: CWJ
 * @Date: 2019/10/16
 **/
@Observer
public class MonthCardObserver {

    @Autowired
    MonthCardService monthCardService;
    @Autowired
    Promotion008CardSysCache promotion008CardSysCache;
    @Autowired
    private EventBus eventBus;

    /***
     * 激活月卡
     * @param event
     */
    @Subscribe
    public void recharge(RechargeEvent event) {
        int now = TimeDateUtil.getCurrentTimeInt();
        promotion008CardSysCache.getAll().forEach(config -> {
            MonthCard monthCard = monthCardService.load(event.getRid(), config.getIdx());
            if (monthCard.getStartTime() == 0) {//过期后,重新添加重置金额
                monthCard.setRechargeCount(monthCard.getRechargeCount() + event.getMoney());
                if (monthCard.getRechargeCount() >= config.getTotal_charge()) {
                    monthCard.setStartTime(DateTimeUtil.theDayBreak(now));
                    monthCard.setEndTime(monthCard.getStartTime() + config.getDay() * TimeDateUtil.ONEDAYINT);
                    eventBus.post(MonthCardActiveEvent.of(event.getRid(), config.getType()));
                }
                monthCardService.update(monthCard);
            }
        });
    }
}
