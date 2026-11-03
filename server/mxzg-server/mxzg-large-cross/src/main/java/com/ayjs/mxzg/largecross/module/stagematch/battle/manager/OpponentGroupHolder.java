package com.ayjs.mxzg.largecross.module.stagematch.battle.manager;

import com.ayjs.mxzg.common.util.RandomUtil;
import com.ayjs.mxzg.config.excel.cache.RobotFormationSysCache;
import com.ayjs.mxzg.config.excel.cache.SuperStageSysCache;
import com.ayjs.mxzg.config.excel.entity.CRobotFormation;
import com.ayjs.mxzg.largecross.module.stagematch.battle.converter.StageMatchConverter;
import com.ayjs.mxzg.largecross.module.stagematch.battle.dao.OpponentDao;
import com.ayjs.mxzg.largecross.module.stagematch.battle.domain.Opponent;
import com.ayjs.mxzg.largecross.module.stagematch.preliminaries.dao.PreliminariesLadderDao;
import com.ayjs.mxzg.largecross.module.stagematch.preliminaries.domain.PreliminariesLadder;
import com.ayjs.mxzg.largecross.servergroup.dao.CrossServerGroupDao;
import com.ayjs.mxzg.largecross.servergroup.domain.CrossServerGroup;
import com.ayjs.mxzg.message.center.dto.CrossGroup;
import com.ayjs.mxzg.message.module.stagematch.dto.RankDto;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.util.CollectionUtils;

import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

/**
 * 对手持有者
 */
@Slf4j
@Component
public class OpponentGroupHolder {

    @Autowired
    private OpponentDao opponentDao;
    @Autowired
    private CrossServerGroupDao crossServerGroupDao;
    @Autowired
    private PreliminariesLadderDao preliminariesLadderDao;
    @Autowired
    private SuperStageSysCache superStageSysCache;
    @Autowired
    private RobotFormationSysCache robotFormationSysCache;
    @Autowired
    private StageMatchConverter stageMatchConverter;

    /** <分组id, 分组信息>*/
    private ConcurrentMap<Integer, OpponentGroup> groups = new ConcurrentHashMap<>();
    /** <分区id, 分组信息>*/
    private ConcurrentMap<Integer, OpponentGroup> serverGroup = new ConcurrentHashMap<>();

    /**
     * 初始化分组信息
     */
    public void initGroupInfo(){
        this.groups.clear();
        this.serverGroup.clear();
        CrossServerGroup crossServerGroup = crossServerGroupDao.get();
        for (CrossGroup group : crossServerGroup.getGroups().values()) {
            OpponentGroup opponentGroup = OpponentGroup.createOf(group.getGroupId(), opponentDao, superStageSysCache);
            groups.put(group.getGroupId(), opponentGroup);
            for (Integer serverId : group.getServerIds()) {
                serverGroup.put(serverId, opponentGroup);
            }
        }
    }

    /**
     * 初始化对手信息
     */
    public void initOpponent(){
        List<Opponent> opponents = opponentDao.listAll();
        for (Opponent opponent : opponents) {
            addOpponent(opponent);
        }
    }

    /**
     * 初始化对手信息
     */
    public void initLadder(){
        List<PreliminariesLadder> opponents = preliminariesLadderDao.listAll();
        for (PreliminariesLadder ladder : opponents) {
            if(ladder.getRank() <= 0){
                continue;
            }

            Opponent opponent = opponentDao.getOrCreate(ladder.getRid());
            OpponentGroup group = getGroupBy(opponent.getServerId());
            if(group != null){
                RankDto rankDto = RankDto.createOf(ladder.getRank(), ladder.getRid(), opponent.getStageId(), opponent.getHeadId(), opponent.getBorderId(), opponent.getImage_id(), opponent.getName()
                        , opponent.getFighting(), opponent.getLevel(), opponent.getServerId(), ladder.getLikes());
                group.addLadder(rankDto);
            } else {
                log.info("对手{}分区信息未找到", opponent.getRid());
            }
        }
    }

    /**
     * 重置
     */
    public void reset(){
        for (OpponentGroup group : groups.values()) {
            group.reset();
        }
    }

    /**
     * 根据分组id获取对手分组
     * @param groupId
     * @return
     */
    public OpponentGroup getGroup(int groupId){
        return this.groups.get(groupId);
    }

    /**
     * 根据服id获取分组
     * @param serverId
     * @return
     */
    public OpponentGroup getGroupBy(int serverId){
        return this.serverGroup.get(serverId);
    }

    /**
     * 获取所有分组id列表
     * @return
     */
    public Collection<Integer> getGroupIds(){
        return this.groups.keySet();
    }

    /**
     * 分组列表
     * @return
     */
    public Collection<OpponentGroup> getGroups(){
        return this.groups.values();
    }

    /**
     * 添加对手
     * @param opponent
     */
    public void addOpponent(Opponent opponent){
        OpponentGroup group = serverGroup.get(opponent.getServerId());
        if(group == null){
            log.error("对手分组数据不存在{}", opponent.getRid());
            return;
        }
        group.addOpponent(opponent);
    }

    /**
     * 选择一个对手
     * @param challenger
     * @return
     */
    public Opponent pickOpponent(Opponent challenger){
        OpponentGroup group = serverGroup.get(challenger.getServerId());
        if(group == null){
            log.error("玩家[{}]没有找到跨服分组", challenger.getRid());
            return null;
        }

        if(challenger.isConsecutiveFailures()){
            log.info("玩家{}连败{}场，匹配机器人", challenger.getRid(), challenger.getConsecutiveFailuresNumber());
            return pickRobot(challenger, group);
        }

        Long opponentId = group.pickOpponent(challenger);
        if(opponentId == null || opponentId == 0){
            log.info("玩家没有匹配到对手，执行匹配机器人", challenger.getRid());
            return pickRobot(challenger, group);
        }
         return opponentDao.get(opponentId);
    }

    /**
     * 选择一个机器人
     * @param challenger
     * @param group
     * @return
     */
    private Opponent pickRobot(Opponent challenger, OpponentGroup group){
        CRobotFormation robotFormation = randomFormation(challenger.getMaxFighting());
        if(robotFormation != null){
            CrossServerGroup crossServerGroup = crossServerGroupDao.get();
            CrossGroup crossGroup = crossServerGroup.getGroupByGroupId(group.getGroupId());
            return stageMatchConverter.buildOpponent(robotFormation, challenger, crossGroup.randomServerId());
        }
        return null;
    }

    /**
     * 更新信息
     * @param challenger
     * @param stageChange
     * @return
     */
    public List<Opponent> updateOpponent(Opponent challenger, boolean stageChange){
        OpponentGroup group = serverGroup.get(challenger.getServerId());
        if(group == null){
            log.error("玩家[{}]没有找到跨服分组", challenger.getRid());
            return Collections.emptyList();
        }
        return group.updateOpponent(challenger, stageChange);
    }

    /**
     * 根据战力获取一个阵容
     * @param fighting
     */
    public CRobotFormation randomFormation(int fighting){
        List<CRobotFormation> robotFormations = robotFormationSysCache.getFormationsBy(fighting);
        return CollectionUtils.isEmpty(robotFormations) ? null : robotFormations.get(RandomUtil.rand(0, robotFormations.size()));
    }


}
