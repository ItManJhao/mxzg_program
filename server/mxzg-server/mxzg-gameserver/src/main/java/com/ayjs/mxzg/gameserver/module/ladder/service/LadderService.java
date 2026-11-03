package com.ayjs.mxzg.gameserver.module.ladder.service;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.Faction;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.LadderFightTimesSysCache;
import com.ayjs.mxzg.config.excel.cache.OpenConditionSysCache;
import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.config.excel.entity.COpenCondition;
import com.ayjs.mxzg.config.struct.LineUpType;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.battle.BattleHelper;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroLineUp;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroLineUpService;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.hero.struct.HeroPosition;
import com.ayjs.mxzg.gameserver.module.ladder.constant.RedDotConstant;
import com.ayjs.mxzg.gameserver.module.ladder.dao.LadderDao;
import com.ayjs.mxzg.gameserver.module.ladder.dao.LadderMyBattleDao;
import com.ayjs.mxzg.gameserver.module.ladder.dao.LadderSuperiorBattleDao;
import com.ayjs.mxzg.gameserver.module.ladder.domain.Ladder;
import com.ayjs.mxzg.gameserver.module.ladder.domain.LadderMyBattle;
import com.ayjs.mxzg.gameserver.module.ladder.domain.LadderSuperiorBattle;
import com.ayjs.mxzg.gameserver.module.ladder.struct.LadderBattleRole;
import com.ayjs.mxzg.gameserver.module.role.constant.EntryType;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.server.constant.ServerParamType;
import com.ayjs.mxzg.gameserver.module.server.domain.ServerParam;
import com.ayjs.mxzg.gameserver.module.server.service.ServerParamService;
import com.ayjs.mxzg.gameserver.module.server.struct.LadderData;
import com.ayjs.mxzg.gameserver.module.tweakCube.service.TweakCubeService;
import com.ayjs.mxzg.gameserver.remote.cross.dao.CrossServerGroupDao;
import com.ayjs.mxzg.gameserver.remote.cross.domain.CrossServerGroup;
import com.ayjs.mxzg.message.module.ladder.dao.LadderLikeRedisDao;
import com.ayjs.mxzg.message.module.ladder.domain.LadderLike;
import com.ayjs.mxzg.message.module.ladder.message.LadderChallengeReqMessage;
import com.ayjs.mxzg.message.module.ladder.message.LadderDefenderData;
import com.ayjs.mxzg.message.module.ladder.message.LadderDefendersResMessage;
import com.ayjs.mxzg.protocol.BattleGMsg;
import com.ayjs.mxzg.protocol.LadderGMsg;
import com.ayjs.rpc.dispatcher.MessageDispatcher;
import com.ayjs.rpc.util.ProtostuffUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

/**
 * 天梯
 */
@Service
@Slf4j
public class LadderService {

    @Autowired
    private LadderDao ladderDao;
    @Autowired
    private LadderMyBattleDao myLadderBattleDao;
    @Autowired
    private LadderSuperiorBattleDao ladderSuperiorBattle;
    @Autowired
    private LadderFightTimesSysCache ladderFightTimesSysCache;
    @Autowired
    private SystemSysCache systemSysCache;
    @Autowired
    private ServerParamService serverParamService;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private HeroLineUpService heroLineUpService;
    @Autowired
    private BattleHelper battleHelper;
    @Autowired
    private CrossServerGroupDao crossServerGroupDao;
    @Autowired
    private LadderLikeRedisDao ladderLikeRedisDao;
    @Autowired
    private OpenConditionSysCache openConditionSysCache;
    @Autowired
    private RoleService roleService;
    @Autowired
    private HeroService heroService;
    @Autowired
    private LadderRankService ladderRankService;
    @Autowired
    private MessageDispatcher messageDispatcher;
    @Autowired
    private ServerConfig serverConfig;
    @Autowired
    private TweakCubeService tweakCubeService;

    public Ladder getLadder(long rid) {
        Ladder ladder = ladderDao.get(rid);
        if (Objects.isNull(ladder)) {
            ladder = new Ladder();
            ladder.setRid(rid);
            ladder.setRefreshDateTime(LocalDate.now());
            ladder.setBuyTimes(ladderFightTimesSysCache.getMaxTimes());
            ladder.setHadBuyTimes(0);
            ladder.setBattleTimes(Math.max(ladder.getBattleTimes(), systemSysCache.getCrossServerLadderFreeTimes()));
            ladder.setLastRefreshDefend(LocalDateTime.now());
            ladderDao.add(ladder);
        } else if (!ladder.getRefreshDateTime().isEqual(LocalDate.now())) {
            ladder.setBuyTimes(ladderFightTimesSysCache.getMaxTimes());
            ladder.setHadBuyTimes(0);
            ladder.setBattleTimes(Math.max(ladder.getBattleTimes(), systemSysCache.getCrossServerLadderFreeTimes()));
            ladder.setRefreshDateTime(LocalDate.now());
            updateLadder(ladder);
        }

        LadderData ladderData = getLadderData();
        if (!ladderData.isOpen(TimeDateUtil.getCurrentTimeInt()) && ladder.getDefends().size() > 0) {
            ladder.getDefends().clear();
            updateLadder(ladder);
        }
        return ladder;
    }

    public void updateLadder(Ladder ladder) {
        ladderDao.update(ladder);
    }

    /***
     * 更新或替换旧的战报记录
     * @param newBattle
     * @return
     */
    public void addOrReplace(LadderMyBattle newBattle) {
        List<LadderMyBattle> list = getAllMyBattle(newBattle.getRid());
        if (list.size() >= systemSysCache.getCrossServerLadderMyRecord()) {
            LadderMyBattle old = list.stream().min(Comparator.comparingInt(LadderMyBattle::getBattleTime)).get();
            old.setReportId(newBattle.getReportId());
            old.setDefend(newBattle.getDefend());
            old.setAttack(newBattle.getAttack());
            old.setBattleTime(newBattle.getBattleTime());
            old.setOldRank(newBattle.getOldRank());
            old.setNewRank(newBattle.getNewRank());
            old.setWinRid(newBattle.getWinRid());
            myLadderBattleDao.update(old);
        } else {
            myLadderBattleDao.add(newBattle);
        }
    }

    public LadderMyBattle getMyBattle(long battleId) {
        return myLadderBattleDao.get(battleId);
    }

    /***
     * 更新或替换旧的战报记录
     * @param newBattle
     * @return
     */
    public void addOrReplaceSuperior(LadderSuperiorBattle newBattle) {
        List<LadderSuperiorBattle> list = getAllSuperiorBattle();
        if (list.size() >= systemSysCache.getCrossServerLadderGodRecord()) {
            LadderSuperiorBattle old = list.stream().min(Comparator.comparingInt(LadderSuperiorBattle::getBattleTime)).get();
            old.setDefend(newBattle.getDefend());
            old.setAttack(newBattle.getAttack());
            old.setReportId(newBattle.getReportId());
            old.setBattleTime(newBattle.getBattleTime());
            old.setWinRid(newBattle.getWinRid());
            ladderSuperiorBattle.update(old);
        } else {
            ladderSuperiorBattle.add(newBattle);
        }
    }


    public List<LadderMyBattle> getAllMyBattle(long rid) {
        return myLadderBattleDao.list("rid", rid);
    }

    public List<LadderSuperiorBattle> getAllSuperiorBattle() {
        return ladderSuperiorBattle.listAll();
    }

    public LadderSuperiorBattle getSuperiorBattle(long battleId) {
        return ladderSuperiorBattle.get(battleId);
    }

    public LadderData getLadderData() {
        ServerParam serverParam = serverParamService.getOrCreate(ServerParamType.LADDER_TIMER, () -> new LadderData());
        return serverParam.parseJson(LadderData.class);
    }

    public void updateLadderData(LadderData entity) {
        ServerParam serverParam = serverParamService.getOrCreate(ServerParamType.LADDER_TIMER, () -> new LadderData());
        serverParam.saveJson(entity);
        serverParamService.update(serverParam);
    }

    public void sendRedStatus(long rid) {

        Ladder ladder = getLadder(rid);
        LadderGMsg.GResMyBattleRed.Builder builder = LadderGMsg.GResMyBattleRed.newBuilder();

        Role role = roleService.getOrThrow(rid);
        COpenCondition condition = openConditionSysCache.getCondition(EntryType.MAIN_LADDER_WAR);
        // 活动开启
        if (Objects.nonNull(condition) && role.getLevel() >= condition.getCondition_value()) {
            if (isOpen()) {
                if (ladder.getBattleTimes() > 0)
                    builder.addRedList(RedDotConstant.ZCJ_DHZC_KFSK_TTZB);
                if (getAllMyBattle(rid).stream().filter(battle ->
                        battle.getBattleTime() > ladder.getReadTime()).count() > 0) {
                    builder.addRedList(RedDotConstant.ZCJ_DHZC_KFSK_TTZB_ZB);
                }
            }
            LocalDate now = LocalDate.now();
            List<LocalDate> list = new ArrayList<>(ladder.getLikeTime().values());
            boolean todayCanLike = list.size() <= 0;
            for (LocalDate localDate : list) {
                todayCanLike = todayCanLike | !localDate.isEqual(now);
            }
            if (todayCanLike && getLikeList().size() > 0) {
                builder.addRedList(RedDotConstant.ZCJ_DHZC_KFSK_TTZB_YXD);
            }
        }
        contextManager.write(rid, CmdCode._43014, builder.build());
    }

    public List<LadderLike> getLikeList() {
        CrossServerGroup group = crossServerGroupDao.get();
        if (group == null) {
            return Collections.emptyList();
        }
        List<String> rankList = new ArrayList<>();
        rankList.add(LadderLike.getKey(group.getGroupId(), 1));
        rankList.add(LadderLike.getKey(group.getGroupId(), 2));
        rankList.add(LadderLike.getKey(group.getGroupId(), 3));
        List<LadderLike> ladderLikes = ladderLikeRedisDao.get(rankList).stream().filter(Objects::nonNull).collect(Collectors.toList());
        return ladderLikes;
    }

    public List<LadderGMsg.PSLikeData> getLakeList(long rid) {
        Ladder ladder = getLadder(rid);
        List<LadderLike> ladderLikes = getLikeList();
        List<LadderGMsg.PSLikeData> result = new ArrayList<>();
        ladderLikes.forEach(ladderLike -> {
            if (Objects.nonNull(ladderLike)) {

                LadderGMsg.PSLikeData.Builder likeData = LadderGMsg.PSLikeData.newBuilder();
                likeData.setClanName(ladderLike.getClanName());
                likeData.setNick(ladderLike.getNick());
                likeData.setLikeNum(ladderLike.getLikeNum());
                likeData.setRank(ladderLike.getRank());
                likeData.setImage(ladderLike.getImage());
                likeData.setCanLike(ladder.getLikeTime().get(ladderLike.getRank()) == null ||
                        !ladder.getLikeTime().get(ladderLike.getRank()).isEqual(LocalDate.now()) ? true : false);
                result.add(likeData.build());
            }
        });
        return result;
    }

    public LadderMyBattle createRecord(int newRank, int oldRank, int battleTime, long rid, LadderBattleRole
            attackRole, LadderBattleRole defendRole, long winId, String battleId) {
        LadderMyBattle ladderMyBattle = new LadderMyBattle();
        ladderMyBattle.setNewRank(newRank);
        ladderMyBattle.setOldRank(oldRank);
        ladderMyBattle.setBattleTime(battleTime);
        ladderMyBattle.setRid(rid);
        ladderMyBattle.setWinRid(winId);

        ladderMyBattle.setReportId(battleId);
        ladderMyBattle.setAttack(attackRole);
        ladderMyBattle.setDefend(defendRole);
        return ladderMyBattle;
    }

    /***
     * 构建我的battleDO
     * @param rid
     * @return
     */
    public BattlerDo toMyAttackDo(long rid) {
        Role role = roleService.getOrThrow(rid);
        LineUpType lineUpType = LineUpType.LADDER_ATTACKER;
        HeroLineUp heroLineUp = heroLineUpService.getLineUpByType(rid, lineUpType);
        if (heroLineUp.getFormationMap().isEmpty()) {
            lineUpType = LineUpType.MAIN;
            heroLineUp = heroLineUpService.getLineUpByType(rid, lineUpType);
        }
        BattlerDo battlerDo = battleHelper.queryPlayerBattler(lineUpType, rid, Faction.ATTACKER);
        int fighting = heroLineUpService.getLineUpFighting(heroLineUp);
        battlerDo.setRoleInfo(role.getServerId(), role.getHeadId(), role.getBorderId(), role.getLevel(), fighting);
        return battlerDo;
    }

    /***
     * 构建我的battleDO
     * @param rid
     * @return
     */
    public HeroLineUp getMyDefendLineUp(long rid) {
        HeroLineUp lineUpByType = heroLineUpService.getLineUpByType(rid, LineUpType.LADDER_DEFENDER);
        if (lineUpByType.getFormationMap().size() > 0) {
            return lineUpByType;
        } else {
            return heroLineUpService.getLineUpByType(rid, LineUpType.MAIN);
        }
    }

    public boolean isOpen() {
        LadderData ladderData = getLadderData();
        int now = TimeDateUtil.getCurrentTimeInt();
        return ladderData.isOpen(now);
    }

    public LadderGMsg.GResLadderLineUpData.Builder builderLineup(long rid) {
        LadderGMsg.GResLadderLineUpData.Builder builder = LadderGMsg.GResLadderLineUpData.newBuilder();
        HeroLineUp lineUpData = getMyDefendLineUp(rid);
        Role role = roleService.getOrThrow(rid);
        for (HeroPosition heroPosition : lineUpData.getFormationMap().values()) {
            Hero hero = heroService.getHero(rid, heroPosition.getHeroId());
            if (Objects.nonNull(hero)) {
                LadderGMsg.PSLadderBriefData.Builder heroBriefData = LadderGMsg.PSLadderBriefData.newBuilder();
                heroBriefData.setHeroType(hero.getType());
                heroBriefData.setLevel(tweakCubeService.getTweakCubeLvAndStage(hero)[0]);
                heroBriefData.setStar(hero.getStar());
                heroBriefData.setPos(heroPosition.getPos());
                heroBriefData.setHeroId(hero.getId());
                builder.addHeroData(heroBriefData);
            }
        }
        builder.setFormationId(lineUpData.getFormationId());
        builder.setFight(heroLineUpService.getLineUpFighting(lineUpData));
        return builder;
    }

    /***
     * 构建天梯战报的玩家对象数据
     * @param ladderBattleRole
     * @return
     */
    public LadderGMsg.PSLadderRoleInfo.Builder getLadderRole(LadderBattleRole ladderBattleRole) {
        LadderGMsg.PSLadderRoleInfo.Builder ladderRole = LadderGMsg.PSLadderRoleInfo.newBuilder();
        ladderRole.setServerId(ladderBattleRole.getServerId());
        ladderRole.setRid(ladderBattleRole.getRid());
        ladderRole.setNick(ladderBattleRole.getNick());
        ladderRole.setLadderRank(ladderBattleRole.getLadderRank());
        ladderRole.setHeadId(ladderBattleRole.getHeadId());
        ladderRole.setBorderId(ladderBattleRole.getBorderId());
        ladderRole.setImageId(ladderBattleRole.getImageId());
        ladderRole.setFight(ladderBattleRole.getFight());
        ladderRole.setLevel(ladderBattleRole.getLevel());
        return ladderRole;
    }

    /***
     * 构建防守列表玩家对象
     * @param defend
     * @return
     */
    public LadderGMsg.PSLadderRoleInfo.Builder builderLadderRole(LadderDefenderData defend) {
        LadderGMsg.PSLadderRoleInfo.Builder defendRoleBuilder = LadderGMsg.PSLadderRoleInfo.newBuilder();
        defendRoleBuilder.setBorderId(defend.getBorderId());
        defendRoleBuilder.setHeadId(defend.getHeadId());
        defendRoleBuilder.setFight(defend.getFighting());
        defendRoleBuilder.setLadderRank(defend.getRank());
        defendRoleBuilder.setRid(defend.getRid());
        defendRoleBuilder.setNick(defend.getNick());
        defendRoleBuilder.setImageId(defend.getImageId());
        defendRoleBuilder.setServerId(defend.getServerId());
        defendRoleBuilder.setLevel(defend.getLevel());
        defendRoleBuilder.setClanName(defend.getClanName());
        return defendRoleBuilder;
    }

    /***
     * 推送天梯数据
     * @param playerContext
     * @param ladder
     */
    public void sendData(PlayerContext playerContext, Ladder ladder) {
        LadderGMsg.GResLadderInfo.Builder builder = LadderGMsg.GResLadderInfo.newBuilder();
        builder.setMyRank(ladderRankService.getRank(playerContext.getId()));
        builder.setBattleTimes(ladder.getBattleTimes());
        builder.setBuyTimes(ladder.getBuyTimes());
        builder.setHadBuyTimes(ladder.getHadBuyTimes());
        if (CollectionUtil.isNotEmpty(ladder.getDefends()))
            ladder.getDefends().forEach(defend -> {
                LadderGMsg.PSLadderRankData.Builder defendBuilder = LadderGMsg.PSLadderRankData.newBuilder();
                defendBuilder.setRank(defend.getRank());
                defendBuilder.setRoleInfo(builderLadderRole(defend));
                builder.addDefends(defendBuilder);
            });
        playerContext.write(CmdCode._43001, builder.build());
    }

    /***
     * 更新玩家防守列表
     * @param ladder
     * @param response
     * @return
     */
    public boolean updateDefends(Ladder ladder, LadderDefendersResMessage response) {
        LadderDefendersResMessage res = response;
        if (res.getDefenders() == null || res.getDefenders().isEmpty()) {
            log.error("跨服数据返回错误！");
            return false;
        }
        ladder.setLastRefreshDefend(LocalDateTime.now());
        ladder.setDefends(res.getDefenders());
        updateLadder(ladder);
        return true;
    }

    /***
     * 发送跨服战斗
     * @param rid
     * @param ladderDefenderData
     * @param attackDo
     * @param defender
     */
    public void crossBattle(long rid, LadderDefenderData ladderDefenderData, BattlerDo attackDo, BattlerDo defender) {
        LadderChallengeReqMessage.LadderChallengeReqMessageBuilder battleMessage = LadderChallengeReqMessage.builder();
        battleMessage.attackServerId(serverConfig.getServerId());
        battleMessage.attackRid(rid);
        battleMessage.attackBattlerVo(ProtostuffUtil.serialize(attackDo.toBattlerVo()));
        battleMessage.atkFighting(attackDo.getFighting());

        battleMessage.defendRank(ladderDefenderData.getRank());
        battleMessage.defendRid(ladderDefenderData.getRid());
        battleMessage.defendServerId(ladderDefenderData.getServerId());
        battleMessage.defendBattlerVo(ProtostuffUtil.serialize(defender.toBattlerVo()));

        messageDispatcher.dispatch(battleMessage.build());
    }

    /***
     * 根据战报战斗对象构建天梯玩家对象
     * @param rank
     * @param attackLog
     * @return
     */
    public LadderBattleRole getLadderBattleRole(int rank, BattleGMsg.BattlerFightLog attackLog) {
        LadderBattleRole attackRole = new LadderBattleRole();
        attackRole.setBorderId(attackLog.getBorderId());
        attackRole.setFight(attackLog.getFighting());
        attackRole.setHeadId(attackLog.getHeadId());
        attackRole.setImageId(0);
        attackRole.setLadderRank(rank);
        attackRole.setNick(attackLog.getName());
        attackRole.setRid(attackLog.getRid());
        attackRole.setServerId(attackLog.getServerId());
        attackRole.setLevel(attackLog.getLevel());
        return attackRole;
    }

}
