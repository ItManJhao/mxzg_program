package com.ayjs.mxzg.gameserver.module.weekendGift.service;

import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.WeekendGiftSysCache;
import com.ayjs.mxzg.config.excel.entity.CWeekendGift;
import com.ayjs.mxzg.gameserver.module.server.service.ServerParamService;
import com.ayjs.mxzg.gameserver.module.weekendGift.dao.WeekendGiftDao;
import com.ayjs.mxzg.gameserver.module.weekendGift.domain.WeekendGift;
import com.ayjs.mxzg.gameserver.module.weekendGift.struct.WeekendGiftRewardStatus;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;


/**
 * @Author: CWJ
 * @Date: 2020/3/21
 **/
@Component
public class WeekendGiftService {

    @Autowired
    private WeekendGiftSysCache weekendGiftSysCache;

    @Autowired
    private WeekendGiftDao weekendGiftDao;

    @Autowired
    private ServerParamService serverParamService;

    public WeekendGift load(long rid) {
        WeekendGift weekendGift = weekendGiftDao.get(rid);
        int now = TimeDateUtil.getCurrentTimeInt();
        if (weekendGift == null) {
            weekendGift = new WeekendGift();
            weekendGift.setRid(rid);
            resetNew(weekendGift);
            weekendGiftDao.add(weekendGift);
        } else if (now > weekendGift.getEndTime()) {
            resetNew(weekendGift);
            update(weekendGift);
        }
        //获取当前第几天
        if (now > weekendGift.getStartTime()) {
            int currDays = TimeDateUtil.intervalDays(now, weekendGift.getStartTime());
            CWeekendGift config = weekendGiftSysCache.getByDays(currDays);
            if (config != null && WeekendGiftRewardStatus.NOT.getValue() == weekendGift.getRewardStatus().get(currDays)) {
                weekendGift.getRewardStatus().put(config.getDays(), WeekendGiftRewardStatus.CAN.getValue());
                weekendGiftDao.update(weekendGift);
            }
        }
        return weekendGift;
    }

    private void resetNew(WeekendGift weekendGift) {
        weekendGift.setStartTime(getStartTime());
        weekendGift.setEndTime(weekendGift.getStartTime() + getDuration());
        for (CWeekendGift cWeekendGift : weekendGiftSysCache.getAll()) {
            weekendGift.getRewardStatus().put(cWeekendGift.getDays(), WeekendGiftRewardStatus.NOT.getValue());
        }
    }

    public void update(WeekendGift weekendGift) {
        weekendGiftDao.update(weekendGift);
    }

    private int getStartTime() {
        int serverStartTime = serverParamService.getServerStartTime();
        //本周六时间
        int saturdayZero = TimeDateUtil.getWeekZeroTimeInt() + TimeDateUtil.ONEDAYINT * 5;
        if (saturdayZero < serverStartTime) { //开服时间在周六，周天的时候，本周不开，下周开
            return saturdayZero + TimeDateUtil.ONEDAYINT * 7;
        } else if (TimeDateUtil.getDayOfWeek() == 1 || TimeDateUtil.getDayOfWeek() == 7) {
            int lastSaturdayZero = saturdayZero - TimeDateUtil.ONEDAYINT * 7;
            if (lastSaturdayZero < serverStartTime) {
                return saturdayZero;
            } else {
                return lastSaturdayZero;
            }
        }
        return saturdayZero;
    }

    private int getDuration() {
        return 3 * TimeDateUtil.ONEDAYINT;
    }
}
