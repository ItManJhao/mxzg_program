package com.ayjs.mxzg.largecross.module.floatingIslands.service;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.lifecycle.Lifecycle;
import com.ayjs.mxzg.common.lifecycle.LifecycleInfo;
import com.ayjs.mxzg.common.lifecycle.Ordinal;
import com.ayjs.mxzg.common.lifecycle.Priority;
import com.ayjs.mxzg.common.top.TopN;
import com.ayjs.mxzg.common.util.InternerPool;
import com.ayjs.mxzg.common.util.JsonUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.floatingIslands.FloatingIslandsHeroSysCache;
import com.ayjs.mxzg.config.excel.cache.floatingIslands.FloatingIslandsTimeSysCache;
import com.ayjs.mxzg.config.excel.entity.floatingIslands.CFloatingIslandsTime;
import com.ayjs.mxzg.config.struct.FloatingIslandsStage;
import com.ayjs.mxzg.largecross.module.floatingIslands.dao.FloatingIslandsDao;
import com.ayjs.mxzg.largecross.module.floatingIslands.dao.FloatingIslandsRankSettleRecordDao;
import com.ayjs.mxzg.largecross.module.floatingIslands.dao.FloatingIslandsTimeDao;
import com.ayjs.mxzg.largecross.module.floatingIslands.dao.RoleFloatingIslandsDao;
import com.ayjs.mxzg.largecross.module.floatingIslands.domain.FloatingIslandsRankSettleRecord;
import com.ayjs.mxzg.largecross.module.floatingIslands.domain.RoleFloatingIslands;
import com.ayjs.mxzg.largecross.servergroup.MessageHelper;
import com.ayjs.mxzg.largecross.servergroup.event.CrossRegroupEvent;
import com.ayjs.mxzg.message.module.floatingIslands.message.FloatingIslandsGetStateResMessage;
import com.ayjs.mxzg.message.module.floatingIslands.message.FloatingIslandsStartNewMessage;
import com.ayjs.mxzg.message.module.floatingIslands.struct.FloatingIslands;
import com.ayjs.mxzg.message.module.floatingIslands.struct.FloatingIslandsTime;
import com.ayjs.mxzg.message.module.floatingIslands.struct.RankData;
import com.ayjs.mxzg.message.module.floatingIslands.struct.RankDataRecord;
import com.ayjs.mxzg.message.module.rank.dto.CrossRankType;
import com.ayjs.mxzg.message.module.role.domain.CrossRole;
import com.ayjs.mxzg.message.module.teamArena.domain.RoleSimpleMessage;
import com.ayjs.mxzg.template.scheduler.service.SchedulerService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2020/7/1
 **/
@Service
@Slf4j
public class FloatingIslandsService implements Lifecycle {

    @Autowired
    private FloatingIslandsTimeDao floatingIslandsTimeDao;
    @Autowired
    private FloatingIslandsDao floatingIslandsDao;
    @Autowired
    private FloatingIslandsTimeSysCache floatingIslandsTimeSysCache;
    @Autowired
    private MessageHelper messageHelper;
    @Autowired
    private SchedulerService schedulerService;
    @Autowired
    private RoleFloatingIslandsDao roleFloatingIslandsDao;
    @Autowired
    private FloatingIslandsRankService floatingIslandsRankService;
    @Autowired
    private FloatingIslandsRankSettleRecordDao floatingIslandsRankSettleRecordDao;
    @Autowired
    private FloatingIslandsHeroSysCache floatingIslandsHeroSysCache;


    public static final String FLOATING_ISLANDS_DMG_LOCK = "FLOATING_ISLANDS_DMG_LOCK";

    public FloatingIslandsTime getTime() {
        return floatingIslandsTimeDao.get();
    }

    public void update(FloatingIslandsTime time) {
        floatingIslandsTimeDao.update(time);
    }

    public FloatingIslands get() {
        return floatingIslandsDao.get();
    }

    public void update(FloatingIslands entity) {
        floatingIslandsDao.update(entity);
    }

    public List<RoleFloatingIslands> listAll() {
        return roleFloatingIslandsDao.listAll();
    }

    public void update(List<RoleFloatingIslands> entities) {
        roleFloatingIslandsDao.update(entities);
    }

    public RoleFloatingIslands getRoleFloatingIslands(long rid) {
        return roleFloatingIslandsDao.get(rid);
    }

    public void update(RoleFloatingIslands entity) {
        roleFloatingIslandsDao.update(entity);
    }

    public void add(RoleFloatingIslands roleFloatingIslands) {
        roleFloatingIslandsDao.add(roleFloatingIslands);
    }

    public List<FloatingIslandsRankSettleRecord> getRecordByGroup(int groupId) {
        List<FloatingIslandsRankSettleRecord> records = floatingIslandsRankSettleRecordDao.list("groupId", groupId);
        //过滤掉过期的记录
        return records;
    }

    @Override
    public LifecycleInfo getInfo() {
        return LifecycleInfo.valueOf(Priority.MEDIUM, Ordinal._10, this.getClass().getSimpleName());
    }

    @Override
    public void start() throws Exception {
        FloatingIslandsTime islandsTime = getTime();
        FloatingIslandsStage newCurrStage = FloatingIslandsStage.OVER;
        int weekZeroTime = TimeDateUtil.getWeekZeroMondayAsFirstDayInt();
        int overStateNum = 0;
        for (; ; ) {
            CFloatingIslandsTime config = floatingIslandsTimeSysCache.getById(newCurrStage.getCode());
            if (config.getIntervalTime() + weekZeroTime + overStateNum * TimeDateUtil.ONEDAYINT * 7 <= TimeDateUtil.getCurrentTimeInt()) {
                newCurrStage = newCurrStage.nextStage();
            } else {
                break;
            }
            if (newCurrStage == FloatingIslandsStage.OVER) {
                overStateNum++;
            }
        }

        FloatingIslandsStage currStage = FloatingIslandsStage.getStage(islandsTime.getStage());
        if (currStage != null) {
            while ((currStage = FloatingIslandsStage.getStage(islandsTime.getStage())) != newCurrStage) {
                setStage(currStage.nextStage(), false);
            }
            schedulerNext(islandsTime);
        } else {
            setStage(newCurrStage, true);
        }
        log.info("当前阶段》》" + JsonUtil.toJson(islandsTime));
    }

    public void setStage(FloatingIslandsStage newStage, boolean startNextScheduler) {
        FloatingIslandsTime islandsTime = getTime();
        if (newStage == FloatingIslandsStage.getStage(islandsTime.getStage())) {
            log.info("floating islands状态设置错误，当前已处于该状态");
            return;
        }
        log.info("floating islands set new state:{}", newStage);
        islandsTime.setStage(newStage.getCode());
        islandsTime.setStageChangeTime(TimeDateUtil.getCurrentTimeInt());

        FloatingIslandsStage nextState = newStage.nextStage();
        CFloatingIslandsTime config = floatingIslandsTimeSysCache.getById(newStage.getCode());
        int weekZeroTime = TimeDateUtil.getWeekZeroMondayAsFirstDayInt();
        int nextTime = weekZeroTime + config.getIntervalTime();
        if (nextTime < TimeDateUtil.getCurrentTimeInt()) {
            nextTime += TimeDateUtil.ONEDAYINT * 7;
        }
        islandsTime.setNextTime(nextTime);
        islandsTime.setNextStage(nextState.getCode());
//        if (newStage == FloatingIslandsStage.CHALLENGE_BOSS) {
//            islandsTime.setBossTurns(nextBossTurns(islandsTime));
//        }
        update(islandsTime);
        if (startNextScheduler) {
            schedulerNext(islandsTime);
        }
        doChangeStage(newStage);
        messageHelper.pushToAll(FloatingIslandsGetStateResMessage.of(islandsTime));
    }

    private void schedulerNext(FloatingIslandsTime islandsTime) {
        schedulerService.schedule("floating_islands_change_stage_time", () -> {
            setStage(FloatingIslandsStage.getStage(islandsTime.getNextStage()), true);
        }, islandsTime.getNextTime() - TimeDateUtil.getCurrentTimeInt(), TimeUnit.SECONDS);
        log.info("floating islands下一个阶段{}的定时器，时间为{}", FloatingIslandsStage.getStage(islandsTime.getNextStage()),
                TimeDateUtil.time2String(islandsTime.getNextTime() * 1000l));
    }

    private void doChangeStage(FloatingIslandsStage stage) {
        switch (stage) {
            case OVER:
                break;
            case CHALLENGE_BOSS:
                clearDmg();
                floatingIslandsRankService.clear();
                floatingIslandsRankService.pullToAllGame();
                break;
            case CHALLENGE_SETTLE:
                settleRecord();
                break;
        }
    }

//    private int nextBossTurns(FloatingIslandsTime time) {
//        int turns = time.getBossTurns() + 1;
//        return turns <= floatingIslandsHeroSysCache.getMaxTurns() ? turns : 1;
//    }

    /***
     * 结算排名记录
     */
    private void settleRecord() {
        Map<Integer, FloatingIslandsRankSettleRecord> groupMap = new HashMap<>();
        int now = TimeDateUtil.getCurrentTimeInt();
        List<FloatingIslandsRankSettleRecord> entities = new ArrayList<>();

        FloatingIslands floatingIslands = get();

        Map<Integer, TopN<Long, RankData>> groupTopN = floatingIslandsRankService.getGroupTopN();
        groupTopN.forEach((groupId, topN) -> {
            List<RankData> rankData = topN.top(CrossRankType.FLOATING_ISLANDS.getRankCount());
            if (!CollectionUtil.isEmpty(rankData)) {
                FloatingIslandsRankSettleRecord settleRecord = groupMap.get(groupId);
                if (settleRecord == null) {
                    settleRecord = new FloatingIslandsRankSettleRecord();
                    settleRecord.setGroupId(groupId);
                    settleRecord.setSettleTime(now);
                    settleRecord.setTotalDmg(floatingIslands.getDmg());
                    groupMap.put(groupId, settleRecord);
                    entities.add(settleRecord);
                }
                for (int i = 0; i < rankData.size(); i++) {
                    RankData rankDate1 = rankData.get(i);
                    RankDataRecord record = new RankDataRecord();
                    record.setRank(i + 1);

                    RankData rankDataTemp = new RankData();
                    rankDataTemp.setRankId(rankDate1.getRankId());
                    rankDataTemp.setRankValue(rankDate1.getRankValue());
                    rankDataTemp.setRankTime(rankDate1.getRankTime());
                    record.setRankData(rankDataTemp);
                    settleRecord.getRanks().add(record);
                }
            }
        });

        floatingIslandsRankSettleRecordDao.add(entities);
        //清理掉过期的记录
        List<FloatingIslandsRankSettleRecord> expires = floatingIslandsRankSettleRecordDao.listAll().stream().filter(record ->
                record.getSettleTime() + TimeDateUtil.ONEDAYINT * 15 < now).collect(Collectors.toList());
        if (expires.size() > 0) {
            floatingIslandsRankSettleRecordDao.remove(expires);
        }
        log.info("添加结算数据库》》》" + entities.size());
    }

    public void setRoleInfo(CrossRole crossRole, RoleFloatingIslands roleFloatingIslands) {
        if (crossRole != null) {
            RoleSimpleMessage simpleMessage = new RoleSimpleMessage();
            simpleMessage.setLevel(crossRole.getLevel());
            simpleMessage.setHeadId(crossRole.getHeadId());
            simpleMessage.setBorderId(crossRole.getBorderId());
            simpleMessage.setImage(crossRole.getImageId());
            simpleMessage.setRoleName(crossRole.getNick());
            simpleMessage.setServerId(crossRole.getServerId());
            simpleMessage.setClanName(crossRole.getClanName());
            simpleMessage.setFighting(crossRole.getFighting());
            simpleMessage.setRid(crossRole.getId());
            roleFloatingIslands.setRoleSimpleMessage(simpleMessage);
        }
    }

    private void clearDmg() {
        //清除总伤害
        synchronized (InternerPool.intern(FloatingIslandsService.FLOATING_ISLANDS_DMG_LOCK)) {
            FloatingIslands serverDmg = get();
            serverDmg.setDmg(0);
            update(serverDmg);
        }
        //清除伤害记录
        List<RoleFloatingIslands> allRole = listAll();
        allRole.forEach(roleFloatingIslandsTemp -> {
            roleFloatingIslandsTemp.setMaxDmg(0);
            roleFloatingIslandsTemp.setTotalDmg(0);
        });
        update(allRole);

    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void startNewSeason(CrossRegroupEvent event) {
        //清除伤害记录
        clearDmg();

        floatingIslandsRankService.clear();
        floatingIslandsRankService.pullToAllGame();

        messageHelper.pushToAll(FloatingIslandsStartNewMessage.of());
    }

}
