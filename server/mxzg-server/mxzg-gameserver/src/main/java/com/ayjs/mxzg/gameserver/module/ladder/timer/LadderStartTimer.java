//package com.ayjs.mxzg.gameserver.module.ladder.timer;
//
//import cn.hutool.core.date.DateUtil;
//import com.ayjs.mxzg.common.lifecycle.Lifecycle;
//import com.ayjs.mxzg.common.lifecycle.LifecycleInfo;
//import com.ayjs.mxzg.common.util.time.DateTimeUtil;
//import com.ayjs.mxzg.common.util.time.TimeDateUtil;
//import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
//import com.ayjs.mxzg.gameserver.module.ladder.service.LadderRankService;
//import com.ayjs.mxzg.gameserver.module.ladder.service.LadderService;
//import com.ayjs.mxzg.gameserver.module.server.struct.LadderData;
//import com.ayjs.mxzg.template.scheduler.service.SchedulerService;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.stereotype.Controller;
//
//import java.util.concurrent.ScheduledFuture;
//import java.util.concurrent.TimeUnit;
//
///**
// * @Author: CWJ
// * @Date: 2020/1/4
// **/
//@Controller
//public class LadderStartTimer implements Lifecycle {
//
//    @Autowired
//    private SchedulerService schedulerService;
//    @Autowired
//    private LadderService ladderService;
//    @Autowired
//    private SystemSysCache systemSysCache;
//    @Autowired
//    private LadderRankService ladderRankService;
//
//    private static final String END_SCHEDULE_ID = "CrossLadderServiceEnd";
//    private ScheduledFuture<?> endFuture;
//
//    @Override
//    public LifecycleInfo getInfo() {
//        return LifecycleInfo.valueOf("LADDER_TIMER");
//    }
//
//    @Override
//    public void start() throws Exception {
//        try {
//
//            Integer[] crossServerLadderOpenTime = systemSysCache.getCrossServerLadderOpenTime();
//            int weekZeroTime = (int) (DateUtil.beginOfWeek(DateUtil.calendar(System.currentTimeMillis()), true).
//                    getTime().getTime() / 1000L);
//            int startTimeSecond = weekZeroTime + crossServerLadderOpenTime[0];
//            int endTimeSecond = weekZeroTime + crossServerLadderOpenTime[1];
//            LadderData ladderData = ladderService.getLadderData();
//            if (ladderData.getStartTime() == 0) {
//                ladderData.setStartTime(+startTimeSecond);
//                ladderData.setEndTime(endTimeSecond);
//                ladderData.setRankMailTime(endTimeSecond);
//                ladderService.updateLadderData(ladderData);
//            }
//
//            // 启动开启关闭延迟任务
//            executeEndLadder(ladderData);
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//    }
//
//    public void executeEndLadder(LadderData ladderData) {
//        int nextExecuteTime = ladderData.getEndTime();
//
//        int now = DateTimeUtil.currentSecond();
//        long delay = 0;
//        if (now < nextExecuteTime) {
//            delay = nextExecuteTime - now;
//        }
//        long finalDelay = delay;
//        schedulerService.register(() -> this.endFuture = schedulerService.schedule(END_SCHEDULE_ID, () -> {
//            Integer[] crossServerLadderOpenTime = systemSysCache.getCrossServerLadderOpenTime();
//            int weekZeroTime = TimeDateUtil.getWeekZeroMondayAsFirstDayInt();
//            int startTimeSecond = weekZeroTime + TimeDateUtil.SEVEN_DAYS_TIME + crossServerLadderOpenTime[0];
//            int nextTime = weekZeroTime + TimeDateUtil.SEVEN_DAYS_TIME + crossServerLadderOpenTime[1];
//            ladderData.setStartTime(startTimeSecond);
//            ladderData.setEndTime(nextTime);
//            try {
//                ladderRankService.ladderComputer();
//            } catch (Exception e) {
//                e.printStackTrace();
//            }
//            ladderService.updateLadderData(ladderData);
//        }, finalDelay, TimeUnit.SECONDS));
//    }
//
//    @Override
//    public void stop() throws Exception {
//
//    }
//}
