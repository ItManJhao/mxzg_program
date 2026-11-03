package com.ayjs.mxzg.cross.module.ladder.timer;

import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.cross.module.crossparam.constant.CrossParamType;
import com.ayjs.mxzg.cross.module.crossparam.service.CrossParamService;
import com.ayjs.mxzg.cross.module.ladder.service.CrossLadderService;
import com.ayjs.mxzg.message.module.ladder.domain.CrossLadderDateTime;
import com.ayjs.mxzg.template.scheduler.service.AbstractCronTask;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class CrossLadderDateTimeTimer extends AbstractCronTask {

    @Autowired
    private CrossLadderService crossLadderService;
    @Autowired
    private SystemSysCache systemSysCache;
    @Autowired
    private CrossParamService crossParamService;

    @Override
    public Object identity() {
        return "CrossLadderDateTimeTimer";
    }

    @Override
    public String expression() {
        return "1 0 0 * * ?";//每天01秒修改本周开始结束时间
    }

    @Override
    public void run() {
        CrossLadderDateTime crossLadderDateTime = crossLadderService.getCrossLadderDateTime();
        Integer[] crossServerLadderOpenTime = systemSysCache.getCrossServerLadderOpenTime();
        int weekZeroTime = TimeDateUtil.getWeekZeroMondayAsFirstDayInt();
        int startTimeSecond = weekZeroTime + crossServerLadderOpenTime[0];
        int endTimeSecond = weekZeroTime + crossServerLadderOpenTime[1];
        crossLadderDateTime.setTheWeekStartDateTime(startTimeSecond);
        crossLadderDateTime.setTheWeekEndDateTime(endTimeSecond);

        crossParamService.save(CrossParamType.LADDER_DATE_TIME, () -> crossLadderDateTime);
    }
}
