package com.ayjs.mxzg.cross.module.ladder.timer;

import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.cross.module.MessageHelper;
import com.ayjs.mxzg.cross.module.crossparam.service.CrossParamService;
import com.ayjs.mxzg.cross.module.crossservice.service.CrossServerGroupService;
import com.ayjs.mxzg.cross.module.ladder.service.CrossLadderService;
import com.ayjs.mxzg.message.module.ladder.domain.CrossLadderDateTime;
import com.ayjs.mxzg.template.scheduler.service.AbstractCronTask;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * 天梯定时器
 */
@Slf4j
@Component
public class CrossLadderTimer extends AbstractCronTask {

    @Autowired
    private CrossLadderService crossLadderService;
    @Autowired
    private CrossServerGroupService crossServerGroupService;
    @Autowired
    private MessageHelper messageHelper;
    @Autowired
    private SystemSysCache systemSysCache;
    @Autowired
    private CrossParamService crossParamService;

    @Override
    public Object identity() {
        return "CrossLadderTimer";
    }

    @Override
    public String expression() {
        return "0 2/1 * * * ?";
    }

    @Override
    public void run() {
        // 过滤
        CrossLadderDateTime crossLadderDateTime = crossLadderService.getCrossLadderDateTime();
        Integer[] crossServerLadderOpenTime = systemSysCache.getCrossServerLadderOpenTime();
        int weekZeroTime = TimeDateUtil.getWeekZeroMondayAsFirstDayInt();
        int startTimeSecond = weekZeroTime + crossServerLadderOpenTime[0];
        int endTimeSecond = weekZeroTime + crossServerLadderOpenTime[1];


        int now = DateTimeUtil.currentSecond();
        if (now > startTimeSecond - 200 && now < endTimeSecond + 200) {
            crossLadderDateTime.setTheWeekStartDateTime(startTimeSecond);
            crossLadderDateTime.setTheWeekEndDateTime(endTimeSecond);

            crossLadderService.pushAllCrossLadderToServer(0);
            log.debug("CrossLadderTimer pushAllCrossLadderToServer.");
        }


    }
}
