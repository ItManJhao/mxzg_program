package com.ayjs.mxzg.largecross.module.stagematch.battle.manager;


import com.ayjs.mxzg.common.convert.ConvertUtils;
import com.ayjs.mxzg.common.lifecycle.Lifecycle;
import com.ayjs.mxzg.common.lifecycle.LifecycleInfo;
import com.ayjs.mxzg.common.lifecycle.Priority;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.LocalDateTimeUtil;
import com.ayjs.mxzg.config.excel.cache.SuperStageCycleSysCache;
import com.ayjs.mxzg.config.excel.entity.CSuperStageCycle;
import com.ayjs.mxzg.config.struct.StageType;
import com.ayjs.mxzg.largecross.module.stagematch.battle.dao.CrossStageMatchDao;
import com.ayjs.mxzg.largecross.module.stagematch.battle.domain.CrossStageMatch;
import com.ayjs.mxzg.largecross.module.stagematch.battle.stage.StageHandler;
import com.ayjs.mxzg.largecross.module.stagematch.battle.stage.StageHandlerHolder;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

/**
 * 段位赛工作者
 */
@Slf4j
@Component
public class StageMatchWorker implements Lifecycle {

    @Autowired
    private StageHandlerHolder stageHandlerHolder;
    @Autowired
    private OpponentGroupHolder opponentGroupHolder;
    @Autowired
    private CrossStageMatchDao crossStageMatchDao;
    @Autowired
    private SuperStageCycleSysCache stageMatchCycleSysCache;

    /** 调度器 */
    private static ScheduledExecutorService executorService = StageMatchScheduled.getExecutorService();

    @Override
    public LifecycleInfo getInfo() {
        return LifecycleInfo.valueOf(Priority.LOW, 1, "STAGE_MATCH_WORKER");
    }

    @Override
    public void start() throws Exception {
        log.info("起服恢复段位赛信息");
        loadAllOpponent();
        startWorker();
    }

    /**
     * 开启工作
     */
    public void startWorker(){
        log.info("开始恢复段位赛");
        CrossStageMatch crossStageMatch = crossStageMatchDao.get();
        log.info("段位赛数据处于第{}赛季[{}]阶段", crossStageMatch.getSeason(), crossStageMatch.getStageType());
        CSuperStageCycle nowCycle = stageMatchCycleSysCache.getNowCycle();
        if(nowCycle == null){
            log.info("当前不在段位赛周期");
            if(crossStageMatch.isUnOpen()){
                List<CSuperStageCycle> all = stageMatchCycleSysCache.getAll();
                log.info("段位赛周期数据size={}", all.size());
                if(!all.isEmpty()){
                    CSuperStageCycle cycle = stageMatchCycleSysCache.getFirstCycle();
                    log.info("首个赛季开始时间为：{}", cycle.getStart_time());
                    startStageMatchCycle(cycle);
                } else {
                    log.info("段位赛没有配置周期，段位赛关闭", all.size());
                }
            } else {
                overSeason(crossStageMatch);
            }
            return;
        }

        if(crossStageMatch.isUnOpen()){
            if(nowCycle.getStage_type() == StageType.START_SEASON){
                log.info("当前赛季段位赛正在匹配中，开启匹配阶段：{}", nowCycle.getStart_time());
                executeCycle(nowCycle);
                CSuperStageCycle endCycle = stageMatchCycleSysCache.getCycleBy(nowCycle.getSeason(), StageType.FINISH.ordinal());
                crossStageMatch.openNewSeason(nowCycle, endCycle);
            } else {
                nowCycle = stageMatchCycleSysCache.getCycleBy(nowCycle.getSeason() + 1, StageType.START_SEASON.ordinal());
                log.info("下个赛季开始时间为：{}", nowCycle.getStart_time());
                startStageMatchCycle(nowCycle);
            }
            startStageMatchCycle(nowCycle);
            crossStageMatchDao.update(crossStageMatch);
            return;
        }

        log.info("段位赛计算处于第{}赛季[{}]阶段", nowCycle.getSeason(), nowCycle.getStage_type());
        if(crossStageMatch.isSameCycle(nowCycle) || crossStageMatch.isLaterThan(nowCycle)){
            log.info("赛季周期一致");
            CSuperStageCycle startCycle = stageMatchCycleSysCache.getById(crossStageMatch.getCycleId());
            CSuperStageCycle endCycle = stageMatchCycleSysCache.getLastCycle(crossStageMatch.getSeason(), StageType.FINISH.ordinal());
            crossStageMatch.openNewSeason(startCycle, endCycle);
            crossStageMatchDao.update(crossStageMatch);

            log.info("重新同步段位赛开启{}和结束{}时间", startCycle.getStart_time(), endCycle.getStart_time());
            CSuperStageCycle nextCycle = stageMatchCycleSysCache.getById(nowCycle.getIdx() + 1);
            if(nextCycle == null){
                log.info("下个赛季周期信息为空,赛季已结束");
            } else {
                startStageMatchCycle(nextCycle);
            }
        } else if(crossStageMatch.isSameSeason(nowCycle)){
            log.info("赛季{}跨周期从{}阶段到{}阶段", crossStageMatch.getSeason(), crossStageMatch.getStageType(), nowCycle.getStage_type());
            CSuperStageCycle startCycle = stageMatchCycleSysCache.getCycleBy(crossStageMatch.getSeason(), crossStageMatch.getStageType());
            chaseCycle(startCycle, nowCycle);
        } else {
            log.info("段位赛跨赛季，上个赛季{}当前赛季{}", crossStageMatch.getSeason(), nowCycle.getSeason());
            overSeason(crossStageMatch);
        }
    }

    /**
     * 开始段位赛周期
     * @param cycle
     */
    public void startStageMatchCycle(CSuperStageCycle cycle){
        StageType stageType = ConvertUtils.toEnum(cycle.getStage_type(), StageType.class);
        log.info("下一阶段为[{}]执行时间为:{}", stageType, cycle.getStart_time());
        int delay = LocalDateTimeUtil.toEpochSecond(cycle.getStart_time()) - DateTimeUtil.currentSecond();
        executorService.schedule(()-> {
                try {
                    executeCycle(cycle);
                } catch(Exception ex){
                    ex.printStackTrace();;
                }
            } , delay, TimeUnit.SECONDS);
    }

    /**
     * 结束赛季
     * @param crossStageMatch
     */
    public void overSeason(CrossStageMatch crossStageMatch){
        CSuperStageCycle startCycle = stageMatchCycleSysCache.getCycleBy(crossStageMatch.getSeason(), crossStageMatch.getStageType());
        CSuperStageCycle endCycle = stageMatchCycleSysCache.getCycleBy(crossStageMatch.getSeason(), StageType.SETTLEMENT.ordinal());
        chaseCycle(startCycle, endCycle);
    }

    /**
     * 追周期
     * @param startCycle
     * @param endCycle
     */
    public void chaseCycle(CSuperStageCycle startCycle, CSuperStageCycle endCycle){
        if(startCycle == null || endCycle == null){
            log.error("赛季结束数据不存在，start = {} end = {}", startCycle, endCycle);
            return;
        }
        if(startCycle.getStart_time().isAfter(endCycle.getStart_time())){
            log.error("周期时间错乱，开始周期在结束周期之后start = {} end = {}", startCycle.getStart_time(), endCycle.getStart_time());
            return;
        }

        CSuperStageCycle nextCycle = stageMatchCycleSysCache.getById(startCycle.getIdx() + 1);
        if(nextCycle == null){
            log.error("赛季已结束，当前赛季id = {}", startCycle.getIdx());
            return;
        }

        executeCycle(nextCycle);

        if(nextCycle.getIdx() < endCycle.getIdx()){
            chaseCycle(nextCycle, endCycle);
        }
    }

    /**
     * 执行周期
     * @param startCycle
     */
    public void executeCycle(CSuperStageCycle startCycle){
        log.info("段位赛开始执行[{}]任务", startCycle.getStage_type());

        StageHandler stageHandler = stageHandlerHolder.getOrThrow(startCycle.getStage_type());
        stageHandler.handle(startCycle);

        CrossStageMatch crossStageMatch = crossStageMatchDao.get();
        crossStageMatch.nextCycle(startCycle);
        crossStageMatchDao.update(crossStageMatch);

        CSuperStageCycle next = stageMatchCycleSysCache.getById(startCycle.getIdx() + 1);
        if(next != null){
            startStageMatchCycle(next);
        }

    }

    /**
     * 加载所有对手信息到缓存
     */
    public void loadAllOpponent(){
        opponentGroupHolder.initGroupInfo();
        opponentGroupHolder.initOpponent();
        opponentGroupHolder.initLadder();
    }
}
