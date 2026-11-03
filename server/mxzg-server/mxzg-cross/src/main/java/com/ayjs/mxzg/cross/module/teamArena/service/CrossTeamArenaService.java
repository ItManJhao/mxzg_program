package com.ayjs.mxzg.cross.module.teamArena.service;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.common.lifecycle.Lifecycle;
import com.ayjs.mxzg.common.lifecycle.LifecycleInfo;
import com.ayjs.mxzg.common.lifecycle.Ordinal;
import com.ayjs.mxzg.common.lifecycle.Priority;
import com.ayjs.mxzg.common.top.TopN;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.teamArena.TeamArenaSysCache;
import com.ayjs.mxzg.config.excel.entity.teamArena.CTeamArena;
import com.ayjs.mxzg.cross.module.MessageHelper;
import com.ayjs.mxzg.cross.module.crossparam.constant.CrossParamType;
import com.ayjs.mxzg.cross.module.crossparam.service.CrossParamService;
import com.ayjs.mxzg.cross.module.crossservice.domain.CrossServerGroup;
import com.ayjs.mxzg.cross.module.crossservice.service.CrossServerGroupService;
import com.ayjs.mxzg.cross.module.rank.service.impl.CrossTeamArenaRankService;
import com.ayjs.mxzg.cross.module.teamArena.dao.CrossArenaTeamDao;
import com.ayjs.mxzg.cross.module.teamArena.dao.TeamArenaSettleTeamDao;
import com.ayjs.mxzg.cross.module.teamArena.domain.CrossArenaTeam;
import com.ayjs.mxzg.cross.module.teamArena.domain.TeamArenaSettleRecord;
import com.ayjs.mxzg.message.module.floatingIslands.struct.RankData;
import com.ayjs.mxzg.message.module.teamArena.domain.TeamArenaRankData;
import com.ayjs.mxzg.message.module.teamArena.domain.TeamArenaState;
import com.ayjs.mxzg.message.module.teamArena.domain.TeamArenaTime;
import com.ayjs.mxzg.message.module.teamArena.message.TeamArenaChangeStateReqMessage;
import com.ayjs.mxzg.message.module.teamArena.message.TeamArenaGetDataResMessage;
import com.ayjs.mxzg.template.scheduler.service.SchedulerService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2020/4/10
 **/
@Service
@Slf4j
public class CrossTeamArenaService implements Lifecycle {

    @Autowired
    private CrossArenaTeamDao crossArenaTeamDao;
    @Autowired
    private CrossServerGroupService crossServerGroupService;
    @Autowired
    private CrossParamService crossParamService;
    @Autowired
    private TeamArenaSysCache teamArenaSysCache;
    @Autowired
    private SchedulerService schedulerService;
    @Autowired
    private CrossTeamArenaRankService crossTeamArenaRankService;
    @Autowired
    private TeamArenaSettleTeamDao teamArenaSettleTeamDao;

    @Autowired
    private MessageHelper messageHelper;

    public List<CrossArenaTeam> getAll() {
        return crossArenaTeamDao.listAll();
    }

    /***
     * 这个启动要比排行榜慢
     * @return
     */
    @Override
    public LifecycleInfo getInfo() {
        return LifecycleInfo.valueOf(Priority.MEDIUM, Ordinal._10, this.getClass().getSimpleName());
    }

    @Override
    public void start() {
        TeamArenaTime teamArenaTime = loadTeamArenaTime();
        TeamArenaState newCurrState = TeamArenaState.OVER;
        int weekZeroTime = TimeDateUtil.getWeekZeroMondayAsFirstDayInt();
        int overStateNum = 0;
        for (; ; ) {
            CTeamArena config = teamArenaSysCache.getById(newCurrState.getState());
            if (config.getTime() + weekZeroTime + overStateNum * TimeDateUtil.ONEDAYINT * 7 <= TimeDateUtil.getCurrentTimeInt()) {
                newCurrState = newCurrState.nextState();
            } else {
                break;
            }
            if (newCurrState == TeamArenaState.OVER) {
                overStateNum++;
            }
        }

        if (teamArenaTime.getCurrState() != null) {
            while (teamArenaTime.getCurrState() != newCurrState) {
                setState(teamArenaTime.getCurrState().nextState(), false);
            }
            schedulerNext(teamArenaTime);
        } else {
            setState(newCurrState, true);
        }

    }

    public TeamArenaTime loadTeamArenaTime() {
        return crossParamService.getOrCreate(CrossParamType.TEAM_ARENA_TIME, () -> new TeamArenaTime()).parseJson(TeamArenaTime.class);
    }

    public void updateTeamArenaTime(TeamArenaTime entity) {
        crossParamService.save(CrossParamType.TEAM_ARENA_TIME, () -> entity);
    }

    public void add(CrossArenaTeam team) {
        crossArenaTeamDao.add(team);
    }

    public CrossArenaTeam getTeam(long teamId) {
        return crossArenaTeamDao.get(teamId);
    }

    public void updateTeam(CrossArenaTeam team) {
        crossArenaTeamDao.update(team);
    }

    public void updateTeams(List<CrossArenaTeam> teams) {
        crossArenaTeamDao.update(teams);
    }

    public void remove(List<CrossArenaTeam> teams) {
        crossArenaTeamDao.remove(teams);
    }

    public void setState(TeamArenaState newState, boolean startNextScheduler) {
        TeamArenaTime teamArenaTime = loadTeamArenaTime();
        if (newState == teamArenaTime.getCurrState()) {
            log.info("team arena状态设置错误，当前已处于该状态");
            return;
        }
        log.info("team arena set new state:{}", newState);
        teamArenaTime.setCurrState(newState);
        teamArenaTime.setStateChangeTime(TimeDateUtil.getCurrentTimeInt());

        TeamArenaState nextState = newState.nextState();
        CTeamArena config = teamArenaSysCache.getById(newState.getState());
        int weekZeroTime = TimeDateUtil.getWeekZeroMondayAsFirstDayInt();
        int nextTime = weekZeroTime + config.getTime();
        if (nextTime < TimeDateUtil.getCurrentTimeInt()) {
            nextTime += TimeDateUtil.ONEDAYINT * 7;
        }
        teamArenaTime.setNextStateTime(nextTime);
        teamArenaTime.setNextState(nextState);

        updateTeamArenaTime(teamArenaTime);
//        updateTeamArenaTime(teamArenaTime);
        if (startNextScheduler) {
            schedulerNext(teamArenaTime);
        }
        doChangeState(newState, teamArenaTime);

        messageHelper.pushToAll(TeamArenaChangeStateReqMessage.of(teamArenaTime));

    }

    /***
     * 定时下一阶段
     */
    public void schedulerNext(TeamArenaTime teamArenaTime) {
        schedulerService.schedule("change_state_time", () -> {
            setState(teamArenaTime.getNextState(), true);
        }, teamArenaTime.getNextStateTime() - TimeDateUtil.getCurrentTimeInt(), TimeUnit.SECONDS);
        log.info("team arena下一个阶段{}的定时器，时间为{}", teamArenaTime.getNextState(),
                TimeDateUtil.time2String(teamArenaTime.getNextStateTime() * 1000l));
    }

    private void doChangeState(TeamArenaState newState, TeamArenaTime teamArenaTime) {

        switch (newState) {

            case TEAM: {
                log.info(String.format("team arena开启新赛季，清除榜单"));
                startNewSeason();
                break;
            }

            case OVER: {
                //推送结算榜单到游戏服
                CrossServerGroup crossServerGroup = crossServerGroupService.getCrossServerGroup();
                Set<Integer> set = new HashSet<>(crossServerGroup.getGroups().keySet());

                teamArenaTime.setLastSettleTime(TimeDateUtil.getCurrentTimeInt());
                updateTeamArenaTime(teamArenaTime);
                settleRecord();

                set.forEach(groupId -> {
                    try {
                        List<TeamArenaRankData> ranks = crossTeamArenaRankService.getAll(groupId);
                        log.info(String.format("team arena推送组队竞技场排行榜,数量{%s}到游戏服{%s}", ranks.size(), groupId));
                        messageHelper.pushToGroupMessage(groupId, TeamArenaGetDataResMessage.createOf(ranks, true));
                    } catch (Exception e) {
                        log.info(String.format("team arena推送组队竞技场排行榜失败，跨服组{%s}", groupId));
                    }
                });

                break;
            }
            default:
                break;

        }
    }

    /***
     * 结算排名记录
     */
    private void settleRecord() {
        Map<Integer, TeamArenaSettleRecord> serverIds = new HashMap<>();
        int now = TimeDateUtil.getCurrentTimeInt();
        List<TeamArenaSettleRecord> entities = new ArrayList<>();

        Map<Integer, TopN<Long, RankData>> groupTopN = crossTeamArenaRankService.getGroupTopN();
        if (groupTopN.size() > 0) {
            for (Integer groupId : groupTopN.keySet()) {
                List<TeamArenaRankData> all = crossTeamArenaRankService.getAll(groupId);
                if (CollectionUtil.isEmpty(all)) {
                    continue;
                }
                all.forEach(teamArenaRankData -> {
                    TeamArenaSettleRecord settleRecord = serverIds.get(teamArenaRankData.getTeamData().getServerId());
                    if (settleRecord == null) {
                        int serverId = teamArenaRankData.getTeamData().getServerId();
                        settleRecord = new TeamArenaSettleRecord();
                        settleRecord.setServerId(serverId);
                        settleRecord.setGroupId(groupId);
                        settleRecord.setSettleTime(now);
                        settleRecord.setRanks(new ArrayList<>());
                        serverIds.put(serverId, settleRecord);
                        entities.add(settleRecord);
                    }
                    settleRecord.getRanks().add(teamArenaRankData);
                });
            }
            teamArenaSettleTeamDao.add(entities);
        }
        log.info("添加结算数据库》》》" + entities.size());

    }

    public List<TeamArenaSettleRecord> getByServerId(int serverId, int time) {
        List<TeamArenaSettleRecord> records = teamArenaSettleTeamDao.list("serverId", serverId);
        //移除半个月前的数据
        List<TeamArenaSettleRecord> expireList = records.stream().filter(record -> record.getSettleTime() +
                TimeDateUtil.ONEDAYINT * 15 < TimeDateUtil.getCurrentTimeInt()).collect(Collectors.toList());
        if (!CollectionUtil.isEmpty(expireList)) {
            teamArenaSettleTeamDao.remove(expireList);
        }
        return records.stream().
                filter(record -> record.getSettleTime() > time).collect(Collectors.toList());
    }

    public void startNewSeason() {
        remove(getAll());
        crossTeamArenaRankService.clear();
        TeamArenaTime teamArenaTime = loadTeamArenaTime();
        teamArenaTime.setRemoveTeamTime(TimeDateUtil.getCurrentTimeInt());
        updateTeamArenaTime(teamArenaTime);

        CrossServerGroup crossServerGroup = crossServerGroupService.getCrossServerGroup();
        Set<Integer> set = new HashSet<>(crossServerGroup.getGroups().keySet());
        set.forEach(groupId -> {
            messageHelper.pushToGroupMessage(groupId, TeamArenaGetDataResMessage.createOf(
                    crossTeamArenaRankService.getAll(groupId), true));
        });
    }

}
