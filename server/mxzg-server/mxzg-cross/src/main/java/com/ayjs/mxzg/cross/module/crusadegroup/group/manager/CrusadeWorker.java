package com.ayjs.mxzg.cross.module.crusadegroup.group.manager;

import com.ayjs.mxzg.common.convert.ConvertUtils;
import com.ayjs.mxzg.common.lifecycle.Lifecycle;
import com.ayjs.mxzg.common.lifecycle.LifecycleInfo;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.LocalDateTimeUtil;
import com.ayjs.mxzg.config.excel.cache.crusadegroup.CrusadeGroupCycleSysCache;
import com.ayjs.mxzg.config.excel.entity.crusadegroup.CCrusadeGroupCycle;
import com.ayjs.mxzg.config.struct.CrusadeGroupStage;
import com.ayjs.mxzg.cross.module.crusadegroup.group.dao.CrusadeSystemDao;
import com.ayjs.mxzg.cross.module.crusadegroup.group.domain.CrusadeSystem;
import com.ayjs.mxzg.cross.module.crusadegroup.group.manager.stage.CrusadeStageHandler;
import com.ayjs.mxzg.cross.module.crusadegroup.group.manager.stage.CrusadeStageHandlerHolder;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

@Slf4j
@Component
public class CrusadeWorker implements Lifecycle {

    @Autowired
    private CrusadeGroupCycleSysCache crusadeGroupCycleSysCache;
    @Autowired
    private CrusadeSystemDao crusadeSystemDao;
    @Autowired
    private CrusadeStageHandlerHolder crusadeStageHandlerHolder;
    @Autowired
    private CrusadeGroupDataManager crusadeGroupDataManager;

    private boolean DEBUG_MODEL = false;

    /** 调度器 */
    private static ScheduledExecutorService executorService = CrusadeGroupScheduled.getExecutorService();

    @Override
    public LifecycleInfo getInfo() {
        return LifecycleInfo.valueOf("CRUSADE_GROUP_WORKER");
    }

    @Override
    public void start() throws Exception {
        log.info("起服检测讨伐团信息");
        CrusadeSystem crusadeSystem = crusadeSystemDao.get();
        log.info("讨伐团上次活动周期进度：{}", crusadeSystem.getCycleId());

        CCrusadeGroupCycle nowCycle = crusadeGroupCycleSysCache.getNowCycle();
        if(nowCycle == null){
            log.info("讨伐团当前时间不在活动中");
            nowCycle = crusadeGroupCycleSysCache.getFirstCycle();
        } else {
            log.info("讨伐团当前周期在:{}，开始时间为：{}", nowCycle.getIdx(), nowCycle.getStart_time());
        }

        if (crusadeSystem.getCycleId() == 0) {
            log.info("初始化讨伐团活动时间：{}", crusadeSystem.getCycleId());
            init(nowCycle.getRound(), crusadeSystem);
        }

        if(nowCycle.getIdx() == crusadeSystem.getCycleId()){
            log.info("停服前周期与当前计算周期预期一致，恢复讨伐团");
            CCrusadeGroupCycle nextCycle = crusadeGroupCycleSysCache.getOrThrow(nowCycle.getIdx() + 1);
            startStageMatchCycle(nextCycle);
        } else if(nowCycle.getStage_type() == CrusadeGroupStage.START_REGISTRATION){
            if(nowCycle.getStart_time().isAfter(LocalDateTime.now())){
                startStageMatchCycle(nowCycle);
            } else {
                log.info("讨伐团当前周期在开始报名阶段直接开始报名，开始时间为：{}", nowCycle.getIdx(), nowCycle.getStart_time());
                executeCycle(nowCycle);
            }
        } else if(nowCycle.getIdx() < crusadeSystem.getCycleId()){
            CCrusadeGroupCycle currentCycle = crusadeGroupCycleSysCache.getOrThrow(crusadeSystem.getCycleId());
            startStageMatchCycle(currentCycle);
            log.info("讨伐团实际周期{}大于当前周期{}，继续执行当前周期，开始时间为：{}", crusadeSystem.getCycleId(), nowCycle.getIdx(), currentCycle.getStart_time());
        } else {
            log.info("当前时间点讨伐团活动正在开启中，跳过当前活动准备下届活动");
            crusadeSystem.setCycle(nowCycle);
            init(nowCycle.getRound(), crusadeSystem);
            nowCycle = crusadeGroupCycleSysCache.getCycleBy(nowCycle.getRound() + 1, CrusadeGroupStage.START_REGISTRATION.ordinal());
            log.info("下个赛季开始时间为：{}", nowCycle.getStart_time());
            startStageMatchCycle(nowCycle);
        }

        crusadeSystemDao.update(crusadeSystem);

        crusadeGroupDataManager.loadData();
    }

    /**
     * 初始化
     * @param round
     * @param crusadeSystem
     */
    public void init(int round, CrusadeSystem crusadeSystem){
        CCrusadeGroupCycle starRegistration = crusadeGroupCycleSysCache.getCycleBy(round, CrusadeGroupStage.START_REGISTRATION.ordinal());
        CCrusadeGroupCycle endRegistration = crusadeGroupCycleSysCache.getCycleBy(round, CrusadeGroupStage.END_REGISTRATION.ordinal());
        CCrusadeGroupCycle starBattle = crusadeGroupCycleSysCache.getCycleBy(round, CrusadeGroupStage.START_BATTLE.ordinal());
        CCrusadeGroupCycle endBattle = crusadeGroupCycleSysCache.getCycleBy(round, CrusadeGroupStage.END_BATTLE.ordinal());
        if(starRegistration == null || endRegistration == null || starBattle == null || endBattle == null){
            log.info("讨伐团周期{}数据不完整，讨伐团开启失败", round);
            return;
        }
        crusadeSystem.init(CrusadeGroupStage.UN_OPEN.ordinal(), starRegistration.getStart_time(), endRegistration.getStart_time(),
                starBattle.getStart_time(), endBattle.getStart_time());
    }

    /**
     * 开始段位赛周期
     * @param cycle
     */
    public void startStageMatchCycle(CCrusadeGroupCycle cycle){

        CrusadeGroupStage stage = ConvertUtils.toEnum(cycle.getStage_type(), CrusadeGroupStage.class);
        log.info("下一阶段为[{}]执行时间为:{}", stage, cycle.getStart_time());
        int delay = LocalDateTimeUtil.toEpochSecond(cycle.getStart_time()) - DateTimeUtil.currentSecond();
        executorService.schedule(()-> {
            try {
                if (!this.DEBUG_MODEL) {
                    executeCycle(cycle);
                }
            } catch(Exception ex){
                ex.printStackTrace();
                log.error("讨伐团处理器执行失败", ex);
            }
        } , delay, TimeUnit.SECONDS);
    }


    /**
     * 追周期
     * @param startCycle
     * @param endCycle
     */
    public void chaseCycle(CCrusadeGroupCycle startCycle, CCrusadeGroupCycle endCycle){
        if(startCycle == null || endCycle == null){
            log.error("赛季结束数据不存在，start = {} end = {}", startCycle, endCycle);
            return;
        }
        if(startCycle.getStart_time().isAfter(endCycle.getStart_time())){
            log.error("周期时间错乱，开始周期在结束周期之后start = {} end = {}", startCycle.getStart_time(), endCycle.getStart_time());
            return;
        }

        CCrusadeGroupCycle nextCycle = crusadeGroupCycleSysCache.getById(startCycle.getIdx() + 1);
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
    public void executeCycle(CCrusadeGroupCycle startCycle){
        log.info("讨伐团开始执行[{}]任务", startCycle.getStage_type());

        CrusadeSystem crusadeSystem = crusadeSystemDao.get();
        crusadeSystem.setCycle(startCycle);
        crusadeSystemDao.update(crusadeSystem);

        CrusadeStageHandler stageHandler = crusadeStageHandlerHolder.getOrThrow(startCycle.getStage_type());
        stageHandler.handle(startCycle);

        CCrusadeGroupCycle next = crusadeGroupCycleSysCache.getById(startCycle.getIdx() + 1);
        if(next != null){
            startStageMatchCycle(next);
        }

    }

    /**
     * 开启调试
     */
    public void openDebug() {
        this.DEBUG_MODEL = true;
    }

}
