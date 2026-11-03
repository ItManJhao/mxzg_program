package com.ayjs.mxzg.cross.module.ladder.service;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.lifecycle.Lifecycle;
import com.ayjs.mxzg.common.lifecycle.LifecycleInfo;
import com.ayjs.mxzg.common.util.GJsonUtils;
import com.ayjs.mxzg.common.util.InternerPool;
import com.ayjs.mxzg.common.util.RandomUtil;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.ServerLadderMatchSysCache;
import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.config.excel.entity.CServerLadderMatch;
import com.ayjs.mxzg.cross.module.MessageHelper;
import com.ayjs.mxzg.cross.module.crossparam.constant.CrossParamType;
import com.ayjs.mxzg.cross.module.crossparam.domain.CrossParam;
import com.ayjs.mxzg.cross.module.crossparam.service.CrossParamService;
import com.ayjs.mxzg.cross.module.crossrole.service.CrossRoleService;
import com.ayjs.mxzg.cross.module.crossservice.domain.CrossServerGroup;
import com.ayjs.mxzg.cross.module.crossservice.service.CrossServerGroupService;
import com.ayjs.mxzg.cross.module.ladder.constant.CrossLadderConstant;
import com.ayjs.mxzg.cross.module.ladder.dao.CrossLadderBackupDao;
import com.ayjs.mxzg.cross.module.ladder.dao.CrossLadderDao;
import com.ayjs.mxzg.cross.module.ladder.domain.CrossLadder;
import com.ayjs.mxzg.cross.module.ladder.domain.CrossLadderBackup;
import com.ayjs.mxzg.cross.module.ladder.domain.CrossLadderData;
import com.ayjs.mxzg.cross.module.ladder.domain.CrossLadderRobot;
import com.ayjs.mxzg.cross.module.ladder.event.LadderEndEvent;
import com.ayjs.mxzg.cross.module.ladder.event.LadderStartEvent;
import com.ayjs.mxzg.message.center.dto.CrossGroup;
import com.ayjs.mxzg.message.module.ladder.dao.LadderLikeRedisDao;
import com.ayjs.mxzg.message.module.ladder.domain.CrossLadderDateTime;
import com.ayjs.mxzg.message.module.ladder.domain.LadderLike;
import com.ayjs.mxzg.message.module.ladder.message.CrossLadderRank;
import com.ayjs.mxzg.message.module.ladder.message.CrossLadderRankResMessage;
import com.ayjs.mxzg.message.module.ladder.message.LadderDefenderData;
import com.ayjs.mxzg.message.module.role.domain.CrossRole;
import com.ayjs.mxzg.template.scheduler.service.SchedulerService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.concurrent.ConcurrentMap;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.concurrent.ScheduledFuture;
import java.util.concurrent.TimeUnit;
import java.util.function.Supplier;
import java.util.stream.Collectors;

/**
 * 跨服天梯
 */
@Slf4j
@Service
public class CrossLadderService implements Lifecycle {

    @Autowired
    private CrossLadderDao crossLadderDao;
    @Autowired
    private CrossLadderBackupDao crossLadderBackupDao;
    @Autowired
    private CrossServerGroupService crossServerGroupService;
    @Autowired
    private CrossLadderRobotService crossLadderRobotService;
    @Autowired
    private SystemSysCache systemSysCache;
    @Autowired
    private ServerLadderMatchSysCache serverLadderMatchSysCache;
    @Autowired
    private CrossRoleService crossRoleService;
    @Autowired
    private SchedulerService schedulerService;
    @Autowired
    private CrossParamService crossParamService;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private LadderLikeRedisDao ladderLikeRedisDao;
    @Autowired
    private MessageHelper messageHelper;

    private final static String START_SCHEDULE_ID = "CrossLadderServiceStart";
    private final static String END_SCHEDULE_ID = "CrossLadderServiceEnd";
    private ScheduledFuture<?> startFuture;
    private ScheduledFuture<?> endFuture;
    /**
     * 跨服天梯组锁
     */
    private final static String CROSS_LADDER_GROUP_LOCK = "CROSS_LADDER_GROUP_LOCK";


    @Override
    public LifecycleInfo getInfo() {
        return LifecycleInfo.valueOf("Cross_Ladder_Service");
    }


    public CrossLadder getCrossLadder(int groupId) {
        CrossLadder crossLadder = crossLadderDao.get(groupId);
        if (Objects.nonNull(crossLadder)) {
            return crossLadder;
        }
        synchronized (InternerPool.intern(CROSS_LADDER_GROUP_LOCK, groupId)) {
            crossLadder = crossLadderDao.get(groupId);
            if (Objects.isNull(crossLadder)) {
                CrossServerGroup crossServerGroup = crossServerGroupService.getCrossServerGroup();
                CrossGroup crossGroup = crossServerGroup.getGroupByGroupId(groupId);
                if (Objects.nonNull(crossGroup)) {
                    CopyOnWriteArrayList list = robotToLadderData(CollectionUtil.newArrayList(crossGroup.getServerIds()));
                    if (CollectionUtil.isNotEmpty(list)) {
                        crossLadder = new CrossLadder();
                        crossLadder.setGroupId(groupId);
                        crossLadder.setRanks(list);
                        crossLadderDao.add(crossLadder);
                        printCrossLadder("getCrossLadder init ");
                    }
                }
            }
        }
        return crossLadder;
    }

    public List<CrossLadder> getAllCrossLadder() {
        return crossLadderDao.listAll();
    }

    /**
     * 活动示范开启，不含边界值
     *
     * @return
     */
    public boolean isLadderOpen() {
        Integer[] crossServerLadderOpenTime = systemSysCache.getCrossServerLadderOpenTime();
        int weekZeroTime = TimeDateUtil.getWeekZeroMondayAsFirstDayInt();
        int startTimeSecond = weekZeroTime + crossServerLadderOpenTime[0];
        int endTimeSecond = weekZeroTime + crossServerLadderOpenTime[1];
        int now = TimeDateUtil.getCurrentTimeInt();
        if (now > startTimeSecond && now < endTimeSecond) {
            return true;
        }
        return false;
    }

    @Override
    public void start() throws Exception {
        crossLadderRobotService.init();
        CrossServerGroup crossServerGroup = crossServerGroupService.getCrossServerGroup();
        ConcurrentMap<Integer, CrossGroup> groups = crossServerGroup.getGroups();

        try {
            // 预加载，初始化数据
            groups.forEach((groupId, group) -> {
                getCrossLadder(groupId);
            });
        } catch (Exception e) {
            e.printStackTrace();
        }

        try {

            CrossLadderDateTime crossLadderDateTime = getCrossLadderDateTime();
            Integer[] crossServerLadderOpenTime = systemSysCache.getCrossServerLadderOpenTime();
            int weekZeroTime = TimeDateUtil.getWeekZeroMondayAsFirstDayInt();
            int startTimeSecond = weekZeroTime + crossServerLadderOpenTime[0];
            int endTimeSecond = weekZeroTime + crossServerLadderOpenTime[1];
            if (crossLadderDateTime.getNextStartDateTime() <= 0) {
                crossLadderDateTime.setNextStartDateTime(startTimeSecond);
                crossLadderDateTime.setTheWeekStartDateTime(startTimeSecond);
            }
            if (crossLadderDateTime.getNextEndDateTime() <= 0) {
                crossLadderDateTime.setNextEndDateTime(endTimeSecond);
                crossLadderDateTime.setTheWeekEndDateTime(endTimeSecond);
            }
            int now = DateTimeUtil.currentSecond();
            if (crossLadderDateTime.getTheWeekStartDateTime() < now) {
                crossLadderDateTime.setTheWeekStartDateTime(startTimeSecond);
            }
            if (crossLadderDateTime.getTheWeekEndDateTime() < now) {
                crossLadderDateTime.setTheWeekEndDateTime(endTimeSecond);
            }
            // 启动开启关闭延迟任务
            executeStartLadder(crossLadderDateTime);
            executeEndLadder(crossLadderDateTime);

            crossParamService.save(CrossParamType.LADDER_DATE_TIME, () -> crossLadderDateTime);
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Test
//        try {
//            groups.forEach((groupId, group) -> {
//                if (CollectionUtil.isNotEmpty(group.getServerIds())) {
//                    for (int i = 0; i < 100; i++) {
//                        List<CrossLadderData> match = match(groupId, 10);
//                        match(groupId, 11);
//                        match(groupId, 999);
//                        match(groupId, 1000);
//                        match(groupId, i);
////                    log.debug("groupId :{}, rank:{},match:{}", groupId, i, match);
//                    }
//                }
//            });
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
    }

    /**
     * 定时执行天梯启动
     *
     * @param crossLadderDateTime
     */
    public void executeStartLadder(CrossLadderDateTime crossLadderDateTime) {
        log.info("cross ladder date time:{}", crossLadderDateTime.toString());

        int nextExecuteTime = crossLadderDateTime.getNextStartDateTime();

        int now = DateTimeUtil.currentSecond();
        long delay = 0;
        if (now < nextExecuteTime) {
            delay = nextExecuteTime - now;
        }
        log.info("executeStartLadder nextExecuteTime:{}, delay:{},", nextExecuteTime, delay);
        long finalDelay = delay;
        schedulerService.register(() -> this.startFuture = schedulerService.schedule(START_SCHEDULE_ID, () -> {
            Integer[] crossServerLadderOpenTime = systemSysCache.getCrossServerLadderOpenTime();
            int weekZeroTime = TimeDateUtil.getWeekZeroMondayAsFirstDayInt();
            int nextTime = weekZeroTime + TimeDateUtil.SEVEN_DAYS_TIME + crossServerLadderOpenTime[0];
            crossLadderDateTime.setNextStartDateTime(nextTime);

            crossParamService.save(CrossParamType.LADDER_DATE_TIME, () -> crossLadderDateTime);
            try {
                log.info("executeEndLadder :{}", DateTimeUtil.date());
                startLadder();
            } catch (Exception e) {
                e.printStackTrace();
            }
            executeStartLadder(crossLadderDateTime);
        }, finalDelay, TimeUnit.SECONDS));
    }

    /**
     * 定时执行天梯关闭
     *
     * @param crossLadderDateTime
     */
    public void executeEndLadder(CrossLadderDateTime crossLadderDateTime) {
        log.info("cross ladder date time:{}", crossLadderDateTime.toString());

        int nextExecuteTime = crossLadderDateTime.getNextEndDateTime();

        int now = DateTimeUtil.currentSecond();
        long delay = 0;
        if (now < nextExecuteTime) {
            delay = nextExecuteTime - now;
        }
        log.info("executeEndLadder nextExecuteTime:{}, delay:{},", nextExecuteTime, delay);
        long finalDelay = delay;
        schedulerService.register(() -> this.endFuture = schedulerService.schedule(END_SCHEDULE_ID, () -> {
            Integer[] crossServerLadderOpenTime = systemSysCache.getCrossServerLadderOpenTime();
            int weekZeroTime = TimeDateUtil.getWeekZeroMondayAsFirstDayInt();
            int nextTime = weekZeroTime + TimeDateUtil.SEVEN_DAYS_TIME + crossServerLadderOpenTime[1];

            crossLadderDateTime.setLastEndDateTime(crossLadderDateTime.getNextEndDateTime());
            crossLadderDateTime.setNextEndDateTime(nextTime);

            crossParamService.save(CrossParamType.LADDER_DATE_TIME, () -> crossLadderDateTime);
            try {
                log.info("executeEndLadder :{}", DateTimeUtil.date());
                endLadder();

            } catch (Exception e) {
                e.printStackTrace();
            }
            executeEndLadder(crossLadderDateTime);
        }, finalDelay, TimeUnit.SECONDS));
    }


    /**
     * 排行榜数据转换成map结构
     *
     * @param crossLadder
     * @return
     */
    public Map<Integer, CrossLadderRank> rankMapAll(CrossLadder crossLadder) {
        Map<Integer, CrossLadderRank> rankMap = new HashMap<>();
        if (Objects.isNull(crossLadder)) {
            return rankMap;
        }

        Iterator<CrossLadderData> iterator = crossLadder.getRanks().iterator();
        int i = 1;
        while (iterator.hasNext()) {
            CrossLadderData next = iterator.next();
            rankMap.put(i, toCrossLadderRank(next.getRid(), next));
            i++;
        }
        return rankMap;
    }

    /**
     * 执行天梯启动
     */
    private void startLadder() {
        backupCrossLadder("startLadder");
        printCrossLadder("startLadder-1");
        clearAllCrossLadderData();
        pushAllCrossLadderToServer(1);
        eventBus.post(LadderStartEvent.of());
        printCrossLadder("startLadder-2");
    }

    /**
     * 执行天梯关闭
     */
    private void endLadder() {

        pushAllCrossLadderToServer(2);
        printCrossLadder("endLadder");

        CrossServerGroup crossServerGroup = crossServerGroupService.getCrossServerGroup();
        ConcurrentMap<Integer, CrossGroup> groups = crossServerGroup.getGroups();

        groups.forEach((groupId, group) -> {
            CrossLadder crossLadder = getCrossLadder(groupId);
            if (Objects.nonNull(crossLadder)) {

                crossLadder.getRanks().stream().limit(3).forEach(crossLadderData -> {
                    LadderLike ladderLike = new LadderLike();
                    ladderLike.setGroupIdAndRank(LadderLike.getKey(groupId, crossLadderData.getRank()));
                    ladderLike.setRank(crossLadderData.getRank());
                    ladderLike.setLikeNum(0);
                    ladderLike.setRid(crossLadderData.getRid());
                    ladderLike.setServerId(crossLadderData.getSid());
                    if (crossLadderData.isReallyPlayer()) {
                        CrossRole crossRole = crossRoleService.getOrThrow(crossLadderData.getRid());
                        ladderLike.setBorderId(crossRole.getBorderId());
                        ladderLike.setHeadId(crossRole.getHeadId());
                        ladderLike.setLevel(crossRole.getLevel());
                        ladderLike.setClanId(crossRole.getClanId());
                        ladderLike.setClanName(crossRole.getClanName());
                        ladderLike.setFighting(crossRole.getFighting());
                        ladderLike.setImage(crossRole.getImageId());
                        ladderLike.setReallyPlayer(true);
                        ladderLike.setNick(crossRole.getNick());
                    } else {
                        CrossLadderRobot robot = crossLadderRobotService.getRobot(crossLadderData.getRid());
                        ladderLike.setBorderId(robot.getBorderId());
                        ladderLike.setHeadId(robot.getHeadId());
                        ladderLike.setLevel(robot.getLevel());
                        ladderLike.setClanId(0);
                        ladderLike.setClanName("");
                        ladderLike.setFighting(robot.getFighting());
                        ladderLike.setImage(robot.getImageId());
                        ladderLike.setReallyPlayer(false);
                        ladderLike.setNick(robot.getNick());
                    }

                    ladderLikeRedisDao.addOrUpdate(ladderLike);
                    log.debug("update ladder like :{}", GJsonUtils.toJson(ladderLike));
                });
            } else {
                log.debug("crossLadder :{} is null", groupId);
            }
        });
        backupCrossLadder("endLadder");


        eventBus.post(LadderEndEvent.of());
    }


    /**
     * 匹配或者刷新对手
     *
     * @param groupId
     * @param rid
     */
    public List<CrossLadderData> match(int groupId, long rid) {
        CrossLadder crossLadder = getCrossLadder(groupId);
        List<CrossLadderData> result = new ArrayList<>();
        if (Objects.isNull(crossLadder)) {
            log.error("ladder match defender crossLadder is null groupId:{}", groupId);
            return result;
        }
        int rank = crossLadder.getRank(rid);
        if (rank <= 0) {
            // 没有排名时默认为最大排名
            rank = CrossLadderConstant.RANK_MAX;
        }

        CopyOnWriteArrayList<CrossLadderData> ranks = crossLadder.getRanks();
        if (rank <= systemSysCache.getCrossServerLadderMatchSeparateRankB()) {
            // 前6名
            result = ranks.stream().limit(6).filter(c -> c.getRid() != rid).collect(Collectors.toList());
        } else if (rank > systemSysCache.getCrossServerLadderMatchSeparateRankB() && rank <= systemSysCache.getCrossServerLadderMatchSeparateRankA()) {
            // 前6到10名
            List<CrossLadderData> tempList = ranks.stream().limit(rank + systemSysCache.getCrossServerLadderMatchSeparateRatio())
                    .filter(c -> c.getRid() != rid).collect(Collectors.toList());
            result = RandomUtil.randomList(tempList, CrossLadderConstant.DEFENDER_NUMBER)
                    .stream().sorted(Comparator.comparingInt(CrossLadderData::getRank)).collect(Collectors.toList());
//            log.debug("ranks:{}",result.stream().map(CrossLadderData::getRank));
        } else {
            // 10名以后
            int beforeRank = 0;
            List<Long> matchRidList = new ArrayList<>();
            int position = 1;
            log.debug("match groupId:{}, rid:{},rank:{}", groupId, rid, rank);
            // 防止死循环
            for (int i = 1; i <= 100; i++) {
                int defenderRank = Math.min(CrossLadderConstant.RANK_MAX - 1, randomDefenderRank(rank, position, beforeRank));
//                log.debug("match rank:{}, position:{},beforeRank:{},defenderRank:{},resultIndexList:{}",
//                        rank, position, beforeRank, defenderRank, GJsonUtils.toJson(resultIndexList));
                beforeRank = defenderRank;// 记录上次随机到的数字，传入下次匹配
                // 过滤自己
                if (defenderRank == rank - 1) {
                    // 避免最后匹配到自己一直循环
                    if (rank > 990) {
                        defenderRank = rank - RandomUtil.rand(2, 20);// 默认给最近几个玩家的信息
                    } else {
                        continue;
                    }
                }
                if (defenderRank <= 0 || defenderRank > CrossLadderConstant.RANK_MAX) {
                    continue;
                }
                long matchRid = ranks.get(defenderRank).getRid();
                // 匹配到自己，或者已经在匹配列表
                if (matchRid == rid || matchRidList.contains(matchRid)) {
                    continue;
                }
                matchRidList.add(matchRid);
                position++;
                if (position > CrossLadderConstant.DEFENDER_NUMBER || matchRidList.size() >= CrossLadderConstant.DEFENDER_NUMBER) {
                    break;
                }
            }
//            log.debug("match rank:{}, resultIndexList:{}", rank, GJsonUtils.toJson(matchRidList));
            List<CrossLadderData> dataList = crossLadder.getCrossLadderData(matchRidList);
            result.addAll(dataList);
        }
        log.debug("match rank:{}, resultIndexList:{}", rank, result.stream().map(CrossLadderData::getRank).toArray());

        return result;
    }

    /**
     * 交换排名
     */
    public void exchangeRank(long attackRid, int attackServerId, long defendRid, CrossLadder crossLadder) {
        synchronized (InternerPool.intern(CROSS_LADDER_GROUP_LOCK, crossLadder.getGroupId())) {
            CrossLadderData attackData = null;
            int attackIndex = -1;
            CrossLadderData defendData = null;
            int defendIndex = -1;
            CopyOnWriteArrayList<CrossLadderData> ranks = crossLadder.getRanks();
            for (int i = 0; i < ranks.size(); i++) {
                CrossLadderData ladderData = ranks.get(i);
                if (ladderData.getRid() == attackRid) {
                    attackData = ladderData;
                    attackIndex = i;
                }
                if (ladderData.getRid() == defendRid) {
                    defendData = ladderData;
                    defendIndex = i;
                }
                if (Objects.nonNull(attackData) && Objects.nonNull(defendData)) {
                    break;
                }
            }
            if (Objects.isNull(attackData)) {
                attackData = new CrossLadderData();
                attackData.setRid(attackRid);
                attackData.setSid(attackServerId);
                attackData.setRank(defendIndex + 1);
                attackData.setReallyPlayer(true);
            } else {
                attackData.setRank(defendIndex + 1);
            }
            ranks.set(defendIndex, attackData);

            if (attackIndex >= 0 && Objects.nonNull(defendData)) {
                defendData.setRank(attackIndex + 1);
                ranks.set(attackIndex, defendData);
            }
            crossLadderDao.update(crossLadder);
        }
    }

    /**
     * 随机防守者
     */
    public int randomDefenderRank(int rank, int position, int beforeRank) {
        CServerLadderMatch ladderPosition = serverLadderMatchSysCache.getOrThrow(position);
        return (int) Math.max(beforeRank + 1,
                Math.ceil(10000.0d * rank / RandomUtil.rand(ladderPosition.getRatio_low(), ladderPosition.getRatio_up() + 1)));
    }

    public CrossLadderDateTime getCrossLadderDateTime() {
        CrossParam crossTimeParam = crossParamService.getOrCreate(CrossParamType.LADDER_DATE_TIME, CrossLadderDateTime::new);
        return crossTimeParam.parseJson(CrossLadderDateTime.class);
    }

    public void updateLadderLike(LadderLike ladderLike) {
        ladderLikeRedisDao.addOrUpdate(ladderLike);
    }

    /**
     * 推送所有数据到游戏服
     *
     * @param sendStatus
     */
    public void pushAllCrossLadderToServer(int sendStatus) {
        ConcurrentMap<Integer, CrossGroup> groups = crossServerGroupService.getCrossServerGroup().getGroups();
        groups.forEach((groupId, group) -> {
            CrossLadder crossLadder = getCrossLadder(groupId);
            if (Objects.nonNull(crossLadder)) {
                Map<Integer, CrossLadderRank> rankMap = rankMapAll(crossLadder);

                messageHelper.pushToGroupMessage(groupId, CrossLadderRankResMessage.of(rankMap, true,
                        getCrossLadderDateTime(), sendStatus));
            }
        });
    }

    /**
     * 打印天梯数据
     *
     * @param event
     */
    public void printCrossLadder(String event) {
        getAllCrossLadder().forEach(crossLadder -> {
            if (log.isDebugEnabled()) {
                log.debug(" {} crossLadder:{}", event, GJsonUtils.toJson(crossLadder));
            }
        });
    }

    /**
     * 清理所有天梯数据
     */
    public void clearAllCrossLadderData() {

        List<CrossLadder> allCrossLadder = getAllCrossLadder();
        printCrossLadder("clearAllCrossLadderData");

        allCrossLadder.forEach(crossLadder -> {
            synchronized (InternerPool.intern(CROSS_LADDER_GROUP_LOCK, crossLadder.getGroupId())) {
                crossLadderDao.remove(crossLadder);
            }
        });
        try {
            // 预加载，初始化数据
            ConcurrentMap<Integer, CrossGroup> groups = crossServerGroupService.getCrossServerGroup().getGroups();
            groups.forEach((groupId, group) -> {
                getCrossLadder(groupId);
            });
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 备份天梯数据
     *
     * @param event
     */
    public void backupCrossLadder(String event) {
        try {
            List<CrossLadder> allCrossLadder = getAllCrossLadder();
            List<CrossLadderBackup> listBackUp = new ArrayList<>();
            allCrossLadder.forEach(crossLadder -> {
                CrossLadderBackup crossLadderBackup = new CrossLadderBackup();
                crossLadderBackup.setId(DateTimeUtil.currentSecond());
                crossLadderBackup.setGroupId(crossLadder.getGroupId());
                crossLadderBackup.setRanks(crossLadder.getRanks());
                crossLadderBackup.setEvent(event);
                crossLadderBackup.setUpdateTime(LocalDateTime.now());
                listBackUp.add(crossLadderBackup);
            });
            crossLadderBackupDao.add(listBackUp);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private CopyOnWriteArrayList robotToLadderData(List<Integer> serverIds) {
        if (CollectionUtil.isEmpty(serverIds)) {
            return null;
        }
        return crossLadderRobotService.getAllRobot().stream().limit(1000).map(robot -> {
            CrossLadderData data = new CrossLadderData();
            data.setReallyPlayer(false);
            data.setRid(robot.getRid());
            data.setSid(RandomUtil.getRand(serverIds));
            data.setRank((int) robot.getRid());// 机器人默认排名和id是一样的
            return data;
        }).collect(Collectors.toCollection((Supplier<CopyOnWriteArrayList>) CopyOnWriteArrayList::new));
    }

    public LadderDefenderData toLadderDefenderData(CrossLadderData crossLadderData) {
        LadderDefenderData defenderData = new LadderDefenderData();
        defenderData.setRid(crossLadderData.getRid());
        if (crossLadderData.isReallyPlayer()) {
            CrossRole crossRole = crossRoleService.getOrThrow(crossLadderData.getRid());
            defenderData.setLevel(crossRole.getLevel());
            defenderData.setHeadId(crossRole.getHeadId());
            defenderData.setBorderId(crossRole.getBorderId());
            defenderData.setImageId(crossRole.getImageId());
            defenderData.setRank(crossLadderData.getRank());
            defenderData.setNick(crossRole.getNick());
            defenderData.setServerId(crossLadderData.getSid());
            defenderData.setClanName(crossRole.getClanName());
            defenderData.setFighting(crossRole.getFighting());
            defenderData.setRealPlayer(true);
        } else {
            CrossLadderRobot robot = crossLadderRobotService.getRobot(crossLadderData.getRid());
            defenderData.setLevel(robot.getLevel());
            defenderData.setHeadId(robot.getHeadId());
            defenderData.setBorderId(robot.getBorderId());
            defenderData.setImageId(robot.getImageId());
            defenderData.setRank(crossLadderData.getRank());
            defenderData.setNick(robot.getNick());
            defenderData.setServerId(crossLadderData.getSid());
            defenderData.setClanName("");
            defenderData.setFighting(robot.getFighting());
            defenderData.setRealPlayer(false);
        }
        return defenderData;
    }

    public CrossLadderRank toCrossLadderRank(long rid, CrossLadderData data) {

        CrossLadderRank rank = new CrossLadderRank();

        rank.setRankId(rid);
        if (Objects.nonNull(data)) {
            rank.setServerId(data.getSid());
            rank.setRank(data.getRank());
            rank.setReallyPlayer(data.isReallyPlayer());
            if (data.isReallyPlayer()) {
                CrossRole crossRole = crossRoleService.getOrThrow(rid);
                rank.setRoleName(crossRole.getNick());
                rank.setBorderId(crossRole.getBorderId());
                rank.setHeadId(crossRole.getHeadId());
                rank.setImage(crossRole.getImageId());
                rank.setLevel(crossRole.getLevel());
                rank.setClanId(crossRole.getClanId());
                rank.setClanName(crossRole.getClanName());
                rank.setFighting(crossRole.getFighting());
            } else {
                CrossLadderRobot robot = crossLadderRobotService.getRobot(rid);
                rank.setRoleName(robot.getNick());
                rank.setBorderId(robot.getBorderId());
                rank.setHeadId(robot.getHeadId());
                rank.setImage(robot.getImageId());
                rank.setLevel(robot.getLevel());
                rank.setClanId(0);
                rank.setClanName("");
                rank.setFighting(robot.getFighting());
            }
        }
        return rank;
    }
}
