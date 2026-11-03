package com.ayjs.mxzg.largecross.module.stagematch.battle.manager;

import com.ayjs.mxzg.battle.command.BattleCommand;
import com.ayjs.mxzg.battle.model.*;
import com.ayjs.mxzg.battle.model.mirror.BattlerVo;
import com.ayjs.mxzg.common.command.serivce.CommandBus;
import com.ayjs.mxzg.common.util.JsonUtil;
import com.ayjs.mxzg.common.util.RandomUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.SuperStageIntegralCache;
import com.ayjs.mxzg.config.excel.cache.SuperStageSysCache;
import com.ayjs.mxzg.config.excel.constant.StageMatchConst;
import com.ayjs.mxzg.config.excel.entity.CSuperStage;
import com.ayjs.mxzg.config.excel.entity.CSuperStageIntegral;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.largecross.module.stagematch.battle.dao.OpponentDao;
import com.ayjs.mxzg.largecross.module.stagematch.battle.domain.Opponent;
import com.ayjs.mxzg.largecross.servergroup.MessageHelper;
import com.ayjs.mxzg.message.module.stagematch.ChallengeResMessage;
import com.ayjs.mxzg.message.module.stagematch.GreatStyleMessage;
import com.ayjs.mxzg.message.module.stagematch.SynchronizeOpponentMessage;
import com.ayjs.mxzg.message.module.stagematch.dto.BattleResultType;
import com.ayjs.mxzg.message.module.stagematch.dto.RankDto;
import com.ayjs.mxzg.module.battle.BattleTemplate;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicLong;

/**
 * 段位赛管理者
 */
@Slf4j
@Component
public class StageMatchManager {

    @Autowired
    private CommandBus commandBus;
    @Autowired
    private BattleTemplate battleTemplate;
    @Autowired
    private SuperStageSysCache superStageSysCache;
    @Autowired
    private SuperStageIntegralCache superStageIntegralCache;
    @Autowired
    private MessageHelper messageHelper;
    @Autowired
    private OpponentDao opponentDao;
    @Autowired
    private OpponentGroupHolder opponentGroupHolder;


    /** 大神风采最后时间 */
    private AtomicLong lastGreatStyleTime = new AtomicLong();

    /** 调度器 */
    private static ScheduledExecutorService executorService = StageMatchScheduled.getExecutorService();

    /** 角色id, 当前最新的流水号*/
    private ConcurrentMap<Long, Integer> opponentSerialNumber = new ConcurrentHashMap<>();


    /**
     * 匹配对手，有可能匹配不到对手
     * @param challenger
     * @param skipArray
     * @param serialNumber
     * @return
     */
    public Opponent matching(Opponent challenger, boolean skipArray, int serialNumber){
        Opponent opponent = opponentGroupHolder.pickOpponent(challenger);
        if(opponent != null){
            scheduleBattleTask(challenger, opponent, skipArray, serialNumber);
        }
        return opponent;
    }

    /**
     * 添加定时战斗任务
     * @param challenger
     * @param opponent
     * @param skipArray
     */
    public void scheduleBattleTask(Opponent challenger, Opponent opponent, boolean skipArray, int serialNumber){
        int waitTime = getWaitingTime(skipArray);
        challenger.matchOpponent(opponent, waitTime);
        opponentSerialNumber.put(challenger.getRid(), serialNumber);
        executorService.schedule(()-> {
            synchronized (challenger){
                if(isExpires(challenger.getRid(), serialNumber)){
                    this.battle(challenger, opponent);
                } else {
                    int sn = opponentSerialNumber.getOrDefault(challenger.getRid(), 0);
                    log.error("{}战斗已经执行，当前流水号{}，过期流水号{}",challenger.getRid(), sn , serialNumber);
                }
            }
         }, waitTime, TimeUnit.SECONDS);
    }

    /**
     * 获取匹配战斗等待时间
     * @param skipArray
     * @return
     */
    public int getWaitingTime(boolean skipArray){
        int skipArrayWaitingTime = StageMatchConst.SKIP_ARRAY_WAITING_TIME;
        int matchingWaitingTime = StageMatchConst.MATCHING_WAITING_TIME;
        return skipArray ? skipArrayWaitingTime : matchingWaitingTime;
    }

    /**
     * 玩家序列号是否过期
     * @param rid
     * @param serialNumber
     * @return
     */
    private boolean isExpires(long rid, int serialNumber){
        int currentSerialNum = opponentSerialNumber.getOrDefault(rid, 0);
        return currentSerialNum == serialNumber;
    }

    /**
     * 立即开始战斗
     * @param challenger
     * @param serialNumber
     */
    public void startBattle(Opponent challenger, int serialNumber){
        synchronized (challenger) {
            if (challenger.hasMatchOpponent()) {
                opponentSerialNumber.put(challenger.getRid(), serialNumber);
                battle(challenger, challenger.getOpponent());
            }
        }
    }

    /**
     * 对战
     * @param challenger
     * @param opponent
     */
    private void battle(Opponent challenger, Opponent opponent){
        try {
            log.info("玩家{}开始挑战段位赛,挑战前积分:{}", challenger.getRid(), challenger.getEliteIntegral());
            challenger.cleanOpponent();

            BattlerVo attackBattlerVo = JsonUtil.parseJson(challenger.getBattlerVo(), BattlerVo.class);
            BattlerDo attacker = battleTemplate.queryBattler(attackBattlerVo, challenger.getName(), Faction.ATTACKER, UnitType.HERO);
            attacker.setRoleInfo(challenger.getServerId(), challenger.getHeadId(), challenger.getBorderId(), challenger.getLevel(), challenger.getFighting());
            BattlerVo defenderBattlerVo = JsonUtil.parseJson(opponent.getBattlerVo(), BattlerVo.class);
            BattlerDo defender = battleTemplate.queryBattler(defenderBattlerVo, opponent.getName(), Faction.DEFENDER, UnitType.HERO);
            defender.setRoleInfo(opponent.getServerId(),opponent.getHeadId(), opponent.getBorderId(), opponent.getLevel(), opponent.getFighting());
            if(challenger.isConsecutiveFailures()){
                updateRobotAttribute(attacker, defender);
            }

            BattleCommand battleCommand = BattleCommand.createOf(BattleType.STAGE_MATCH, attacker, defender);
            commandBus.invoke(battleCommand);
            BattleResult battleResult = battleCommand.getResult();

            updateBattleResult(challenger, opponent, battleResult.isWin());

            int resultType = battleResult.isWin() ? BattleResultType.VICTORY : BattleResultType.FAILURE;
            byte[] battleReportBytes = battleResult.getReport().toByteArray();
            ChallengeResMessage message = ChallengeResMessage.createOf(challenger.getRid(), challenger.getServerId(), challenger.getStageId(), challenger.getEliteIntegral(),
                    challenger.getIntegral(), challenger.getRank(), resultType, challenger.isQualifyingMatch(), challenger.getAdvanceResultSet(), battleReportBytes, opponent.getRank());
            messageHelper.pushToMessage(message);

            if(challenger.getStageId() >= StageMatchConst.GREAT_STYLE_STAGE_ID && greatStyleTime()){
                GreatStyleMessage greatStyleMessage = GreatStyleMessage.createOf(battleReportBytes, challenger.toOpponentDto(), opponent.toOpponentDto());
                OpponentGroup opponentGroup = opponentGroupHolder.getGroupBy(challenger.getServerId());
                if(opponentGroup != null){
                    messageHelper.pushToGroupMessage(opponentGroup.getGroupId(), greatStyleMessage);
                }
            }

        } catch (Exception ex){
            ex.printStackTrace();
            log.error("段位赛战斗失败%s", ex);
        } finally {
            opponentDao.update(challenger);
            log.info("玩家{}段位赛挑战完毕，分数:{}", challenger.getRid(), challenger.getEliteIntegral());
        }

    }

    /**
     * 根据挑战者修改机器人的属性
     * @param attacker
     * @param defender
     */
    private void updateRobotAttribute(BattlerDo attacker, BattlerDo defender){
        for (int i = 0; i < attacker.getHeros().size(); i++) {
            HeroDo hero =  attacker.getHeros().get(i);
            if(defender.getHeros().size() > i){
                HeroDo update = defender.getHeros().get(i);
                updateHeroAttribute(hero, update);
            }
        }
    }

    /**
     * 修改英雄屬性
     * @param source
     * @param update
     */
    private void updateHeroAttribute(HeroDo source, HeroDo update){
        AttributeInfo attributes = source.getAttributeInfo();
        Long attack = RandomUtil.getRandomInt(StageMatchConst.ROBOT_ATTRIBUTE_RANGE_MINIMUM, StageMatchConst.ROBOT_ATTRIBUTE_RANGE_MAXIMUM) * attributes.getAttributeInfos().get(AttributeType.ATTACK) / 10000;
        Long defend = RandomUtil.getRandomInt(StageMatchConst.ROBOT_ATTRIBUTE_RANGE_MINIMUM, StageMatchConst.ROBOT_ATTRIBUTE_RANGE_MAXIMUM) * attributes.getAttributeInfos().get(AttributeType.DEFENSE) / 10000;
        Long hp = RandomUtil.getRandomInt(StageMatchConst.ROBOT_ATTRIBUTE_RANGE_MINIMUM, StageMatchConst.ROBOT_ATTRIBUTE_RANGE_MAXIMUM) * attributes.getAttributeInfos().get(AttributeType.HP) / 10000;
        Long speed = RandomUtil.getRandomInt(StageMatchConst.ROBOT_ATTRIBUTE_RANGE_MINIMUM, StageMatchConst.ROBOT_ATTRIBUTE_RANGE_MAXIMUM) * attributes.getAttributeInfos().get(AttributeType.SPEED) / 10000;
        Map<AttributeType, Long> baseAttributes = new HashMap<>(attributes.getAttributeInfos());
        baseAttributes.put(AttributeType.ATTACK, attack);
        baseAttributes.put(AttributeType.DEFENSE, defend);
        baseAttributes.put(AttributeType.HP, hp);
        baseAttributes.put(AttributeType.SPEED, speed);
        update.getAttributeInfo().setAttributeInfos(baseAttributes);
    }

    /**
     * 是否
     * @return
     */
    private boolean greatStyleTime(){
        long lastTime = this.lastGreatStyleTime.get();
        long now = TimeDateUtil.getCurrentTimeInt();
        if((TimeDateUtil.getCurrentTimeInt() - lastTime) > 180){
            return lastGreatStyleTime.compareAndSet(lastTime, now);
        }
        return false;
    }

    /**
     * 根据结果和对手更新段位信息
     * @param challenger
     * @param opponent
     * @param result
     */
    private void updateBattleResult(Opponent challenger, Opponent opponent, boolean result){
        int pointsDifference = challenger.getEliteIntegral() - opponent.getEliteIntegral();
        CSuperStageIntegral superStageIntegral = superStageIntegralCache.getWith(pointsDifference);
        CSuperStage superStage = superStageSysCache.getOrThrow(challenger.getStageId());
        int updateIntegral = result ? superStageIntegral.getVictory_points() : -superStageIntegral.getFailure_points();
        int currentStageId = challenger.getStageId();
        if (challenger.isQualifyingMatch()) {
            challenger.addAdvanceResult(updateIntegral);
            if (challenger.isAdvanceFinish(superStage.getAdvance_num(), superStage.getAdvance_win())) {
                if (challenger.isAdvanceSuccess(superStage.getAdvance_win())) {
                    CSuperStage nextSuperStage = superStageSysCache.getById(challenger.getStageId() + 1);
                    if (nextSuperStage != null) {
                        challenger.upgradeStage(nextSuperStage);
                    }
                }
                challenger.advanceFinish();
            }
        } else {
            CSuperStage lastStage = superStageSysCache.getById(challenger.getStageId() - 1);
            challenger.updateIntegral(updateIntegral, lastStage);
            if (challenger.isFull(superStage.getIntegral_limit()) && superStage.getAdvance_num() > 0) {
                challenger.startAdvance(superStage.getIntegral_limit());
            }
        }
        boolean stageChange = currentStageId != challenger.getStageId();
        List<Opponent> changeRankingOpponents = opponentGroupHolder.updateOpponent(challenger, stageChange);
        for(Opponent rankingOpponent : changeRankingOpponents){
            if(rankingOpponent.getRid() != challenger.getRid()){
                messageHelper.pushToMessage(SynchronizeOpponentMessage.createOf(rankingOpponent.toOpponentDto()));
            }
        }

        challenger.addBattleResult(result);
    }


    /**
     * 获取指定数量的头部排名
     * @param groupId
     * @param topNum
     * @return
     */
    public List<RankDto> getRankTop(int groupId, int topNum){
        OpponentGroup group = this.opponentGroupHolder.getGroup(groupId);
        if(group == null){
            log.error("获取排行榜数据时未找到指定的分组:{}", groupId);
            return Collections.emptyList();
        }
        return group.getRankTop(topNum);
    }



}
