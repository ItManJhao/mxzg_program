package com.ayjs.mxzg.gameserver.module.magicTower.handler;

import com.ayjs.mxzg.battle.model.BattleResult;
import com.ayjs.mxzg.battle.model.BattleType;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.Faction;
import com.ayjs.mxzg.battle.model.UnitType;
import com.ayjs.mxzg.battle.model.mirror.BattlerVo;
import com.ayjs.mxzg.common.command.serivce.CommandBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.StringUtil;
import com.ayjs.mxzg.config.excel.cache.LanguageSysCache;
import com.ayjs.mxzg.config.excel.cache.magicTower.MagicTowerDailyBuySysCache;
import com.ayjs.mxzg.config.excel.cache.magicTower.MagicTowerKingRewardSysCache;
import com.ayjs.mxzg.config.excel.cache.magicTower.MagicTowerLevelSysCache;
import com.ayjs.mxzg.config.excel.cache.magicTower.MagicTowerStarRewardSysCache;
import com.ayjs.mxzg.config.excel.cache.magicTower.MagicTowerSysCache;
import com.ayjs.mxzg.config.excel.entity.CLanguage;
import com.ayjs.mxzg.config.excel.entity.magicTower.CMagicTower;
import com.ayjs.mxzg.config.excel.entity.magicTower.CMagicTowerDailyBuy;
import com.ayjs.mxzg.config.excel.entity.magicTower.CMagicTowerKingReward;
import com.ayjs.mxzg.config.excel.entity.magicTower.CMagicTowerLevel;
import com.ayjs.mxzg.config.excel.entity.magicTower.CMagicTowerStarReward;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.infrastructure.gm.GMCommand;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.GMCmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.Rewards;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.battle.BattleHelper;
import com.ayjs.mxzg.gameserver.module.godRelic.service.GodRelicTargetHelper;
import com.ayjs.mxzg.gameserver.module.magicTower.domain.MagicTower;
import com.ayjs.mxzg.gameserver.module.magicTower.domain.MagicTowerLevel;
import com.ayjs.mxzg.gameserver.module.magicTower.domain.MagicTowerRoad;
import com.ayjs.mxzg.gameserver.module.magicTower.service.MagicTowerService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.message.module.magicTower.MagicTowerLevelArenaChangeReq;
import com.ayjs.mxzg.message.module.magicTower.MagicTowerLevelArenaRoleReq;
import com.ayjs.mxzg.message.module.magicTower.MagicTowerLevelArenaRoleRes;
import com.ayjs.mxzg.message.module.magicTower.MagicTowerLevelPassDetailReq;
import com.ayjs.mxzg.message.module.magicTower.MagicTowerLevelPassDetailRes;
import com.ayjs.mxzg.message.module.magicTower.MagicTowerLevelRankReq;
import com.ayjs.mxzg.message.module.magicTower.MagicTowerLevelRankRes;
import com.ayjs.mxzg.message.module.magicTower.MagicTowerListAllLevelReq;
import com.ayjs.mxzg.message.module.magicTower.MagicTowerListAllLevelRes;
import com.ayjs.mxzg.message.module.magicTower.MagicTowerPassLevelReq;
import com.ayjs.mxzg.message.module.magicTower.MagicTowerRemoteBattleReq;
import com.ayjs.mxzg.message.module.magicTower.MagicTowerRemoteBattleRes;
import com.ayjs.mxzg.message.module.study.ReqBattlerVOMessage;
import com.ayjs.mxzg.message.module.study.ResBattlerVOMessage;
import com.ayjs.mxzg.module.battle.BattleReportManager;
import com.ayjs.mxzg.module.battle.BattleTemplate;
import com.ayjs.mxzg.module.battle.command.SaveBattleReportCommand;
import com.ayjs.mxzg.protocol.BattleGMsg;
import com.ayjs.mxzg.protocol.MagicTowerGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.ayjs.mxzg.template.language.LanguageHelper;
import com.ayjs.rpc.dispatcher.MessageDispatcher;
import com.ayjs.rpc.util.ProtostuffUtil;
import com.google.protobuf.InvalidProtocolBufferException;
import com.google.protobuf.Message;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Set;
import java.util.concurrent.TimeUnit;

/**
 * @Author: CWJ
 * @Date: 2021/6/18
 **/
@Slf4j
@Component
public class MagicTowerHandler extends ProtocolHandler {
    @Autowired
    private MagicTowerService magicTowerService;
    @Autowired
    private MagicTowerSysCache magicTowerSysCache;
    @Autowired
    private MagicTowerLevelSysCache magicTowerLevelSysCache;
    @Autowired
    private ThingService thingService;

    @Autowired
    private BattleHelper battleHelper;
    @Autowired
    private GodRelicTargetHelper godRelicTargetHelper;

    @Autowired
    private BattleTemplate battleTemplate;
    @Autowired
    private LanguageSysCache languageSysCache;
    @Autowired
    private LanguageHelper languageHelper;
    @Autowired
    private MagicTowerDailyBuySysCache magicTowerDailyBuySysCache;
    @Autowired
    private MessageDispatcher messageDispatcher;
    @Autowired
    private ServerConfig serverConfig;
    @Autowired
    private BattleReportManager reportManager;
    @Autowired
    private RoleService roleService;
    @Autowired
    private MagicTowerStarRewardSysCache magicTowerStarRewardSysCache;
    @Autowired
    private MagicTowerKingRewardSysCache magicTowerKingRewardSysCache;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private CommandBus commandBus;

    @CMD(id = CmdCode._76501)
    public void sendData(PlayerContext playerContext, MagicTowerGMsg.GReqMagicTowerData req) {
        MagicTower magicTower = magicTowerService.load(playerContext.getId());
        messageDispatcher.dispatch(MagicTowerListAllLevelReq.of(serverConfig.getServerId(), magicTower.getMaxLevel()), response -> {
            MagicTowerListAllLevelRes res = (MagicTowerListAllLevelRes) response;

            MagicTowerGMsg.GResMagicTowerData.Builder builder = MagicTowerGMsg.GResMagicTowerData.newBuilder();
            builder.setBuyCount(magicTower.getBuyCount());
            builder.setCanChallengeCount(magicTower.getCanChallengeCount());
            magicTowerService.loadAllMagicTowerLevel(playerContext.getId()).forEach(level -> {
                if (level.getLevel() <= magicTower.getMaxLevel()) {
                    MagicTowerGMsg.PSMagicLevelData.Builder levelData = builderLevelData(level.getLevel(), level.getCompleteTarget());
                    builder.addLevelData(levelData);
                }
            });
            if (res.getPassData() != null) {
                for (byte[] arenaData : res.getPassData()) {
                    MagicTowerGMsg.PSMagicLevelPassData builderTemp = builderData(MagicTowerGMsg.PSMagicLevelPassData.getDefaultInstance(), arenaData);
                    if (builderTemp == null) {
                        continue;
                    }
                    builder.addPassData(builderTemp);
                }
            }
            if (res.getArenaList() != null) {
                for (byte[] arenaData : res.getArenaList()) {
                    MagicTowerGMsg.PSMagicTowerArena temp = builderData(MagicTowerGMsg.PSMagicTowerArena.getDefaultInstance(), arenaData);
                    if (temp == null) {
                        continue;
                    }
                    builder.addArena(temp);
                }
            }
            playerContext.write(CmdCode._76501, builder.build());
        });


    }

    public MagicTowerGMsg.PSMagicLevelData.Builder builderLevelData(int level, List<Integer> targetIds) {
        MagicTowerGMsg.PSMagicLevelData.Builder builder = MagicTowerGMsg.PSMagicLevelData.newBuilder();
        builder.setLevel(level);
        builder.addAllCompleteId(targetIds);
        return builder;
    }


    @CMD(id = CmdCode._76502)
    public void challenge(PlayerContext playerContext, MagicTowerGMsg.GReqMagicTowerChallenge req) {
        MagicTower magicTower = magicTowerService.load(playerContext.getId());
        CMagicTower config = magicTowerSysCache.getById(req.getIdx());

        Asserts.isTrue(magicTower.getMaxLevel() + 1 >= config.getLevel(),
                ErrorCode.MAGIC_TOWER_PASS_LEVEL_LOW.getValue(),
                String.format("通关关卡数不足{%s},请求关卡{%s}", magicTower.getMaxLevel(), config.getLevel()));

//        Asserts.isTrue(magicTower.getCanChallengeCount() > 0, ErrorCode.MAGIC_TOWER_CHALLENGE_COUNT_LOW.getValue(),
//                String.format("挑战次数不足{%s}", config.getLevel()));

        List<CMagicTowerLevel> byMission = magicTowerLevelSysCache.getByMission(req.getIdx());
        BattlerDo playerDo = battleHelper.queryPlayerBattler(BattleType.MAGIC_TOWER, playerContext.getId(), Faction.ATTACKER);
        CLanguage language = languageSysCache.getByKey(config.getLanguage());
        BattlerDo monsterDo = battleTemplate.queryBattler(byMission, String.format(languageHelper.getLanguageBy(language), config.getLevel()), Faction.DEFENDER, UnitType.MOSTER);
        BattleResult battleResult = battleHelper.invokeBattle(BattleType.MAGIC_TOWER, playerDo, monsterDo);

        List<Integer> completeIds = new ArrayList<>();
        MagicTowerLevel magicTowerLevel = magicTowerService.loadLevel(playerContext.getId(), config.getLevel());
        List<Integer> maxCompleteIds = magicTowerLevel.getCompleteTarget();
        Rewards reward = null;
        for (Integer targetId : config.getTarget()) {
            boolean complete = godRelicTargetHelper.magicTowerVerify(targetId, Arrays.asList(battleResult));
            if (complete) {
                completeIds.add(targetId);
            }
        }
        if (battleResult.isWin()) {
            int battleTime = (int) TimeUnit.MILLISECONDS.toSeconds(battleResult.getContext().getBattleDuration());
            if (maxCompleteIds.size() <= completeIds.size()) {
                magicTowerLevel.setCompleteTarget(completeIds);
                if (StringUtil.isBlank(magicTowerLevel.getBattleId())) {
                    magicTowerLevel.setBattleId(battleResult.getReport().getBattleId());
                    magicTowerLevel.setSpendTime(battleTime);
                } else if (battleTime < magicTowerLevel.getSpendTime()) {
                    magicTowerLevel.setBattleId(battleResult.getReport().getBattleId());
                    magicTowerLevel.setSpendTime(battleTime);
                }

                magicTowerService.update(magicTowerLevel);

                if (completeIds.size() > maxCompleteIds.size()) {
                    magicTower.setSumStar(magicTower.getSumStar() + completeIds.size() - maxCompleteIds.size());
                }
                maxCompleteIds.addAll(completeIds);
                maxCompleteIds = completeIds;
            }

            //保存到本地
            commandBus.invoke(SaveBattleReportCommand.of(battleResult.getReport()));

            messageDispatcher.dispatch(MagicTowerPassLevelReq.of(magicTower.getRid(), config.getLevel(),
                    battleTime, battleResult.getContext().getAttacker().getFighting(),
                    battleResult.getContext().getBattleId()));

            if (magicTower.getMaxLevel() < config.getLevel()) {
                magicTower.setMaxLevel(config.getLevel());
                reward = thingService.add(playerContext.getId(), config.getFirst_reward(), GameEvent.MAGIC_TOWER_PASS_REWARD, NoticeType.SLIENT);
            } else {
                reward = thingService.add(playerContext.getId(), config.getReward(), GameEvent.MAGIC_TOWER_PASS_REWARD, NoticeType.SLIENT);
            }

            magicTower.setCanChallengeCount(magicTower.getCanChallengeCount() - 1);
            magicTowerService.update(magicTower);
        }

        MagicTowerGMsg.GResMagicTowerChallenge.Builder builder = MagicTowerGMsg.GResMagicTowerChallenge.newBuilder();
        builder.setBattleReport(battleResult.getReport());
        builder.setCanChallengeCount(magicTower.getCanChallengeCount());
        if (reward != null) {
            builder.addAllReward(PbUtil.buildReward(reward));
        }
        builder.setLevelData(builderLevelData(config.getLevel(), completeIds));
        builder.setMaxStarMap(builderLevelData(config.getLevel(), maxCompleteIds));
        playerContext.write(CmdCode._76502, builder.build());
    }

    @CMD(id = CmdCode._76503)
    public void buyCount(PlayerContext playerContext, MagicTowerGMsg.GReqMagicTowerBuyCount req) {
        MagicTower magicTower = magicTowerService.load(playerContext.getId());

        CMagicTowerDailyBuy config = magicTowerDailyBuySysCache.getOrThrow(magicTower.getBuyCount() + 1);

        thingService.cost(playerContext.getId(), config.getNeed(), GameEvent.MAGIC_TOWER_BUY_COUNT_COST);

        magicTower.setBuyCount(magicTower.getBuyCount() + 1);
        magicTower.setCanChallengeCount(magicTower.getCanChallengeCount() + 1);
        magicTowerService.update(magicTower);

        MagicTowerGMsg.GResMagicTowerBuyCount.Builder builder = MagicTowerGMsg.GResMagicTowerBuyCount.newBuilder();
        builder.setBuyCount(magicTower.getBuyCount());
        builder.setCanChallengeCount(magicTower.getCanChallengeCount());
        playerContext.write(CmdCode._76503, builder.build());

    }

    @CMD(id = CmdCode._76505)
    public void sweep(PlayerContext playerContext, MagicTowerGMsg.GReqMagicTowerSweep req) {

        MagicTower magicTower = magicTowerService.load(playerContext.getId());

        CMagicTower config = magicTowerSysCache.getById(req.getIdx());

        Asserts.isTrue(magicTower.getMaxLevel() >= config.getLevel(),
                ErrorCode.MAGIC_TOWER_PASS_LEVEL_LOW.getValue(), String.format("通关关卡数不够{%s}", config.getLevel()));

        MagicTowerLevel MagicTowerLevel = magicTowerService.loadLevel(playerContext.getId(), config.getLevel());
        int completeStar = MagicTowerLevel.getCompleteTarget().size();
        Asserts.isTrue(completeStar >= config.getTarget().size(),
                ErrorCode.MAGIC_TOWER_CHAPTER_STAR_LOW.getValue(), String.format("星级数不够{%s}", completeStar));

        Asserts.isTrue(magicTower.getCanChallengeCount() > 0, ErrorCode.MAGIC_TOWER_CHALLENGE_COUNT_LOW.getValue(),
                String.format("挑战次数不足{%s}", config.getLevel()));

        magicTower.setCanChallengeCount(magicTower.getCanChallengeCount() - 1);
        magicTowerService.update(magicTower);

        thingService.add(playerContext.getId(), config.getReward(), GameEvent.MAGIC_TOWER_PASS_REWARD);

        MagicTowerGMsg.GResMagicTowerSweep.Builder builder = MagicTowerGMsg.GResMagicTowerSweep.newBuilder();
        builder.setCanChallengeCount(magicTower.getCanChallengeCount());

        playerContext.write(CmdCode._76505, builder.build());
    }

    @CMD(id = CmdCode._76506)
    public void challengeArena(PlayerContext playerContext, MagicTowerGMsg.GReqMagicTowerChallengeArena req) {
        MagicTower magicTower = magicTowerService.load(playerContext.getId());

        CMagicTower config = magicTowerSysCache.getById(req.getIdx());

        Asserts.isTrue(config.getRank() == 1,
                ErrorCode.MAGIC_TOWER_NOT_ARENA_LEVEL.getValue(), String.format("不是擂主关{%s}", config.getLevel()));

        Asserts.isTrue(magicTower.getMaxLevel() >= config.getLevel(),
                ErrorCode.MAGIC_TOWER_PASS_LEVEL_LOW.getValue(), String.format("通关关卡数不够{%s}", config.getLevel()));
        messageDispatcher.dispatch(MagicTowerLevelArenaRoleReq.of(playerContext.getId(), config.getLevel()), res -> {
            MagicTowerLevelArenaRoleRes response = (MagicTowerLevelArenaRoleRes) res;
            if (response == null || response.getArenaRole() == null)
                return;
            MagicTowerGMsg.PSMagicTowerArena arenaRole = builderData(MagicTowerGMsg.PSMagicTowerArena.getDefaultInstance(), response.getArenaRole());

            if (arenaRole == null || arenaRole.getRid() == playerContext.getId()) {
                playerContext.writeError(ErrorCode.MAGIC_TOWER_NOT_EXIST_ARENA,String.format("擂主不合法{%s}", arenaRole == null ? 0 : arenaRole.getRid()));
                return;
            }

            messageDispatcher.dispatch(ReqBattlerVOMessage.of(arenaRole.getRid(), arenaRole.getServerId(), BattleType.MAGIC_TOWER.getValue()), battleRes -> {
                ResBattlerVOMessage message = (ResBattlerVOMessage) battleRes;
                BattlerVo battlerVo = ProtostuffUtil.deserialize(message.getBattlerVo(), BattlerVo.class);
                BattlerDo defender = battleTemplate.queryBattler(battlerVo, message.getNick(), Faction.DEFENDER, UnitType.HERO);
                defender.setRoleInfo(message.getServerId(), message.getHeadId(), message.getBorderId(), message.getLevel(), message.getFighting());
                BattlerDo attacker = battleHelper.queryPlayerBattler(BattleType.MAGIC_TOWER, playerContext.getId(), Faction.ATTACKER);
                BattleResult result = battleHelper.invokeBattle(BattleType.MAGIC_TOWER, attacker, defender);
                MagicTowerGMsg.GResMagicTowerChallengeArena.Builder builder = MagicTowerGMsg.GResMagicTowerChallengeArena.newBuilder();
                builder.setBattleReport(result.getReport());
                builder.setLevel(req.getIdx());
                if (result.isWin()) {
                    messageDispatcher.dispatch(MagicTowerLevelArenaChangeReq.of(playerContext.getId(), config.getLevel(), defender.getPlayerId()));
                }

                playerContext.write(CmdCode._76506, builder.build());

            });

        });
    }

    public <T extends Message> T builderData(T message, byte[] date) {
        try {
            return (T) message.getParserForType().parseFrom(date);
        } catch (InvalidProtocolBufferException e) {
            log.error("协议解析失败", e);
        }
        return null;
    }

    @CMD(id = CmdCode._76510)
    public void levelDetail(PlayerContext playerContext, MagicTowerGMsg.GReqMagicTowerLevelPassDetail req) {
        MagicTower magicTower = magicTowerService.load(playerContext.getId());
        CMagicTower config = magicTowerSysCache.getOrThrow(req.getLevel());
//        Asserts.isTrue(magicTower.getMaxLevel() >= config.getLevel(),
//                ErrorCode.MAGIC_TOWER_PASS_LEVEL_LOW.getValue(), String.format("通关关卡数不够{%s}", config.getLevel()));

        messageDispatcher.dispatch(MagicTowerLevelPassDetailReq.of(serverConfig.getServerId(), req.getLevel()), res -> {
            MagicTowerLevelPassDetailRes response = (MagicTowerLevelPassDetailRes) res;

            MagicTowerGMsg.GResMagicTowerLevelPassDetail data = builderData(MagicTowerGMsg.GResMagicTowerLevelPassDetail.getDefaultInstance(),
                    response.getPassData());
            if (data == null) {
                log.error("消息返回未空");
                return;
            }
            MagicTowerGMsg.GResMagicTowerLevelPassDetail.Builder builder = data.toBuilder();

            MagicTowerLevel selfPass = magicTowerService.loadLevel(playerContext.getId(), req.getLevel());

            if (!StringUtil.isBlank(selfPass.getBattleId())) {
                MagicTowerGMsg.PSMagicTowerPassRole.Builder selfBuilder = MagicTowerGMsg.PSMagicTowerPassRole.newBuilder();
                Role role = roleService.getOrThrow(playerContext.getId());
                selfBuilder.setRid(playerContext.getId());
                selfBuilder.setName(role.getNick());
                selfBuilder.setHeadId(role.getHeadId());
                selfBuilder.setBroadId(role.getBorderId());
                selfBuilder.setServerId(role.getServerId());
                selfBuilder.setBattleId(selfPass.getBattleId());
                selfBuilder.setLowestTime(selfPass.getSpendTime());
                builder.setSelf(selfBuilder);
            }
            playerContext.write(CmdCode._76510, builder.build());

        });
    }

    @CMD(id = CmdCode._76507)
    public void query(PlayerContext playerContext, MagicTowerGMsg.GReqMagicTowerQuery req) {
        BattleGMsg.BattleReport report = reportManager.getReport(req.getBattleId());
        if (report == null) {
            messageDispatcher.dispatch(MagicTowerRemoteBattleReq.of(req.getServerId(), req.getBattleId()), response -> {
                MagicTowerRemoteBattleRes res = (MagicTowerRemoteBattleRes) response;
                Asserts.notNull(res.getBattleReport(), ErrorCode.BATTLE_REPORT_TIMEOUT.getValue(),
                        () -> String.format("战报已过期：%s", req.getBattleId()));
                BattleGMsg.BattleReport reportRemote = builderData(BattleGMsg.BattleReport.getDefaultInstance(), res.getBattleReport());

                Asserts.notNull(reportRemote == null, ErrorCode.BATTLE_REPORT_TIMEOUT.getValue(),
                        () -> String.format("战报已过期：%s", req.getBattleId()));

                MagicTowerGMsg.GResMagicTowerQuery.Builder builder = MagicTowerGMsg.GResMagicTowerQuery.newBuilder();
                builder.setReport(reportRemote);
                playerContext.write(CmdCode._76507, builder.build());
                //保存到本地
                commandBus.invoke(SaveBattleReportCommand.of(reportRemote));

            });
        } else {
            MagicTowerGMsg.GResMagicTowerQuery.Builder builder = MagicTowerGMsg.GResMagicTowerQuery.newBuilder();
            builder.setReport(report);
            playerContext.write(CmdCode._76507, builder.build());
        }
    }

    @CMD(id = CmdCode._76520)
    public void rankList(PlayerContext playerContext, MagicTowerGMsg.GReqMagicTowerLevelRank req) {
        messageDispatcher.dispatch(MagicTowerLevelRankReq.of(playerContext.getId(), serverConfig.getServerId()), res -> {
            MagicTowerLevelRankRes response = (MagicTowerLevelRankRes) res;
            MagicTowerGMsg.GResMagicTowerLevelRank data = builderData(MagicTowerGMsg.GResMagicTowerLevelRank.getDefaultInstance(), response.getArena());
            playerContext.write(CmdCode._76520, data);
        });
    }


    @GMCommand(command = GMCmdCode.MAGIC_TOWER_ADD_LEVEL)
    public void addLv(Role role, List<String> param) {
        int level = Integer.valueOf(param.get(0));
        MagicTower magicTower = magicTowerService.load(role.getId());
        List<MagicTowerLevel> update = new ArrayList<>();
        for (int i = 1; i <= level; i++) {
            CMagicTower config = magicTowerSysCache.getById(i);
            MagicTowerLevel MagicTowerLevel = magicTowerService.loadLevel(role.getId(), config.getLevel());
            List<Integer> complete = new ArrayList<>(config.getTarget());
            if (complete.size() > MagicTowerLevel.getCompleteTarget().size()) {
                magicTower.setSumStar(magicTower.getSumStar() + complete.size() - MagicTowerLevel.getCompleteTarget().size());
                MagicTowerLevel.setCompleteTarget(complete);
                update.add(MagicTowerLevel);
            }
        }
        if (update.size() > 0) {
            magicTower.setMaxLevel(level);
            magicTowerService.update(magicTower);
            magicTowerService.updateList(update);

            messageDispatcher.dispatch(MagicTowerPassLevelReq.of(role.getId(), level, 10, 0, ""));
        }
    }


    //--------------------------------------------

    @CMD(id = CmdCode._76542)
    public void reqRoadInfo(PlayerContext playerContext, MagicTowerGMsg.GReqMagicTowerRoadInfo req) {
        long rid = playerContext.getId();
        MagicTowerRoad towerRoad = magicTowerService.getMagicTowerRoadByRid(rid);
        MagicTowerGMsg.GResMagicTowerRoadInfo.Builder proto = MagicTowerGMsg.GResMagicTowerRoadInfo.newBuilder();
        proto.addAllNormalList(new ArrayList<>(towerRoad.getNormalSet()));
        proto.addAllKingList(new ArrayList<>(towerRoad.getKingSet()));
        proto.setState(towerRoad.getKingState());
        playerContext.write(CmdCode._76542, proto.build());
    }

    @CMD(id = CmdCode._76543)
    public void reqRoadReceive(PlayerContext playerContext, MagicTowerGMsg.GReqMagicTowerRoadReceive req) {
        long rid = playerContext.getId();
        int receiveId = req.getReceiveId();
        int type = req.getType();

        MagicTower magicTower = magicTowerService.load(rid);
        int sumStar = magicTower.getSumStar();
        MagicTowerRoad towerRoad = magicTowerService.getMagicTowerRoadByRid(rid);
        List<Integer> resultList = new ArrayList<>();
        if (type == 1) {
            CMagicTowerStarReward config = magicTowerStarRewardSysCache.getOrThrow(receiveId);
            int needStar = config.getStar();
            Asserts.isTrue(sumStar >= needStar, ErrorCode.MAGIC_TOWER_STAR_NO_ENOUGH.getValue(),
                    String.format("当前星数{%s} <= {%s}", sumStar, needStar));
            Set<Integer> normalSet = towerRoad.getNormalSet();
            Asserts.isTrue(!normalSet.contains(receiveId), ErrorCode.MAGIC_TOWER_REWARD_HAD_RECEIVE.getValue(),
                    String.format("任务{%s}奖励已经领取", receiveId));

            normalSet.add(receiveId);
            magicTowerService.updateMagicTowerRoad(towerRoad);

            thingService.add(rid, config.getReward(), GameEvent.MAGIC_TOWER_ROAD_REWARD);
            resultList.addAll(new ArrayList<>(normalSet));
        } else if (type == 2) {
            CMagicTowerKingReward kingConfig = magicTowerKingRewardSysCache.getOrThrow(receiveId);
            int needStar = kingConfig.getStar();
            Asserts.isTrue(towerRoad.getKingState() == 1, ErrorCode.MAGIC_TOWER_KING_TITLE_UNLOCK.getValue(),
                    "斩魔王者称号没有解锁");
            Asserts.isTrue(sumStar >= needStar, ErrorCode.MAGIC_TOWER_STAR_NO_ENOUGH.getValue(),
                    String.format("当前星数{%s} <= {%s}", sumStar, needStar));
            Set<Integer> kingSet = towerRoad.getKingSet();
            Asserts.isTrue(!kingSet.contains(receiveId), ErrorCode.MAGIC_TOWER_REWARD_HAD_RECEIVE.getValue(),
                    String.format("任务{%s}奖励已经领取", receiveId));

            kingSet.add(receiveId);
            magicTowerService.updateMagicTowerRoad(towerRoad);

            thingService.add(rid, kingConfig.getReward(), GameEvent.MAGIC_TOWER_KING_ROAD_REWARD);
            resultList.addAll(new ArrayList<>(kingSet));
        }
        MagicTowerGMsg.GResMagicTowerRoadReceive.Builder proto = MagicTowerGMsg.GResMagicTowerRoadReceive.newBuilder();
        proto.addAllList(resultList);
        proto.setType(type);
        playerContext.write(CmdCode._76543, proto.build());
    }

    @GMCommand(command = GMCmdCode.MAGIC_TOWER_ADD_COUNT)
    public void addCount(Role role, List<String> param) {
        int count = Integer.valueOf(param.get(0));
        MagicTower magicTower = magicTowerService.load(role.getId());
        magicTower.setCanChallengeCount(count);
        magicTowerService.update(magicTower);

        MagicTowerGMsg.GResMagicTowerBuyCount.Builder builder = MagicTowerGMsg.GResMagicTowerBuyCount.newBuilder();
        builder.setBuyCount(magicTower.getBuyCount());
        builder.setCanChallengeCount(magicTower.getCanChallengeCount());
        contextManager.write(role.getId(), CmdCode._76503, builder.build());
    }


}
