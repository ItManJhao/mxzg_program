package com.ayjs.mxzg.gameserver.module.countryWar.handler;

import com.ayjs.mxzg.battle.model.BattleType;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.Faction;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.DropUtil;
import com.ayjs.mxzg.common.util.gson.GsonUtils;
import com.ayjs.mxzg.common.util.time.LocalDateTimeUtil;
import com.ayjs.mxzg.config.excel.cache.countryWar.CountryWarCitySysCache;
import com.ayjs.mxzg.config.excel.cache.countryWar.CountryWarConst;
import com.ayjs.mxzg.config.excel.cache.countryWar.CountryWarFlagMissionSysCache;
import com.ayjs.mxzg.config.excel.cache.countryWar.CountryWarFlagRoundRewardSysCache;
import com.ayjs.mxzg.config.excel.cache.countryWar.CountryWarLotterySysCache;
import com.ayjs.mxzg.config.excel.cache.countryWar.CountryWarMissionScoreSysCache;
import com.ayjs.mxzg.config.excel.cache.countryWar.CountryWarMissionSysCache;
import com.ayjs.mxzg.config.excel.cache.countryWar.CountryWarRandomEventSysCache;
import com.ayjs.mxzg.config.excel.cache.countryWar.CountryWarRandomShopSysCache;
import com.ayjs.mxzg.config.excel.cache.countryWar.CountryWarTimeSysCache;
import com.ayjs.mxzg.config.excel.entity.countrywar.CCountryWarCity;
import com.ayjs.mxzg.config.excel.entity.countrywar.CCountryWarFlagMission;
import com.ayjs.mxzg.config.excel.entity.countrywar.CCountryWarFlagRoundReward;
import com.ayjs.mxzg.config.excel.entity.countrywar.CCountryWarLottery;
import com.ayjs.mxzg.config.excel.entity.countrywar.CCountryWarMission;
import com.ayjs.mxzg.config.excel.entity.countrywar.CCountryWarMissionScore;
import com.ayjs.mxzg.config.excel.entity.countrywar.CCountryWarRandomShop;
import com.ayjs.mxzg.config.excel.entity.countrywar.CountryWarMissionType;
import com.ayjs.mxzg.config.excel.entity.countrywar.CountryWarStage;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.infrastructure.gm.GMCommand;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.GMCmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.battle.BattleHelper;
import com.ayjs.mxzg.gameserver.module.countryWar.domain.CountryWar;
import com.ayjs.mxzg.gameserver.module.countryWar.domain.CountryWarScoreMission;
import com.ayjs.mxzg.gameserver.module.countryWar.domain.CountryWarSystem;
import com.ayjs.mxzg.gameserver.module.countryWar.event.CountryWarAttackEvent;
import com.ayjs.mxzg.gameserver.module.countryWar.event.CountryWarMoveEvent;
import com.ayjs.mxzg.gameserver.module.countryWar.event.CountryWarRandomShopBuyEvent;
import com.ayjs.mxzg.gameserver.module.countryWar.pb.CountryWarPb;
import com.ayjs.mxzg.gameserver.module.countryWar.service.CountryWarService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.message.module.countryWar.CountryWarAttackReqMessage;
import com.ayjs.mxzg.message.module.countryWar.CountryWarAttackResMessage;
import com.ayjs.mxzg.message.module.countryWar.CountryWarGMReqMessage;
import com.ayjs.mxzg.message.module.countryWar.CountryWarMoveReqMessage;
import com.ayjs.mxzg.message.module.countryWar.CountryWarMoveResMessage;
import com.ayjs.mxzg.message.module.countryWar.CountryWarRandomShopBuyReqMessage;
import com.ayjs.mxzg.message.module.countryWar.CountryWarRandomShopBuyResMessage;
import com.ayjs.mxzg.message.module.countryWar.CountryWarRankListReqMessage;
import com.ayjs.mxzg.message.module.countryWar.CountryWarRankListResMessage;
import com.ayjs.mxzg.message.module.countryWar.CountryWarRoleLogReqMessage;
import com.ayjs.mxzg.message.module.countryWar.CountryWarRoleLogResMessage;
import com.ayjs.mxzg.message.module.countryWar.CountryWarScanCityReqMessage;
import com.ayjs.mxzg.message.module.countryWar.CountryWarScanCityResMessage;
import com.ayjs.mxzg.message.module.countryWar.CountryWarScanSmallCityReqMessage;
import com.ayjs.mxzg.message.module.countryWar.CountryWarScanSmallCityResMessage;
import com.ayjs.mxzg.message.module.countryWar.CountryWarServerLogReqMessage;
import com.ayjs.mxzg.message.module.countryWar.CountryWarServerLogResMessage;
import com.ayjs.mxzg.message.module.countryWar.dto.CountryWarStageTimeInfo;
import com.ayjs.mxzg.protocol.CountryWarGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.ayjs.rpc.dispatcher.MessageDispatcher;
import com.google.protobuf.InvalidProtocolBufferException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2021/4/19
 **/
@Component
@Slf4j
public class CountryWarHandler extends ProtocolHandler {

    @Autowired
    private MessageDispatcher messageDispatcher;
    @Autowired
    private CountryWarService countryWarService;
    @Autowired
    private CountryWarTimeSysCache countryWarTimeSysCache;
    @Autowired
    private ServerConfig serverConfig;
    @Autowired
    private ThingService thingService;
    @Autowired
    private CountryWarCitySysCache countryWarCitySysCache;
    @Autowired
    private CountryWarMissionSysCache countryWarMissionSysCache;
    @Autowired
    private CountryWarPb countryWarPb;
    @Autowired
    private CountryWarConst countryWarConst;
    @Autowired
    private CountryWarMissionScoreSysCache countryWarMissionScoreSysCache;
    @Autowired
    private CountryWarLotterySysCache countryWarLotterySysCache;
    @Autowired
    private CountryWarFlagMissionSysCache countryWarFlagMissionSysCache;
    @Autowired
    private CountryWarFlagRoundRewardSysCache countryWarFlagRoundRewardSysCache;
    @Autowired
    private CountryWarRandomShopSysCache countryWarRandomShopSysCache;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private CountryWarRandomEventSysCache countryWarRandomEventSysCache;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private BattleHelper battleHelper;


    @CMD(id = CmdCode._76350)
    public void scanStage(PlayerContext playerContext, CountryWarGMsg.GReqCountryWarTime req) {
        CountryWarStageTimeInfo timeInfo = countryWarService.getCountryWarStageTimeInfo();
        Asserts.isTrue(timeInfo != null,
                ErrorCode.COUNTRY_WAR_NOT_JOIN.getValue(),
                String.format("跨服链接断开"));

        CountryWarGMsg.GResCountryWarTime.Builder builder = CountryWarGMsg.GResCountryWarTime.newBuilder();

        builder.setStage(timeInfo.getStage());
        builder.setStartTime(LocalDateTimeUtil.toEpochSecond(timeInfo.getStageStartTime()));
        builder.setNextStageTime(LocalDateTimeUtil.toEpochSecond(timeInfo.getNextStageTime()));
        builder.setHadJoin(timeInfo.isJoin());
        builder.setRound(timeInfo.getRound());
        builder.setType(countryWarTimeSysCache.getOrThrow(timeInfo.getIdx()).getType());
        builder.setMainServerId(serverConfig.getServerId());
        playerContext.write(CmdCode._76350, builder.build());
    }

    @CMD(id = CmdCode._76351)
    public void scanCity(PlayerContext playerContext, CountryWarGMsg.GReqCountryWarCity req) {
        CountryWarStageTimeInfo timeInfo = countryWarService.getCountryWarStageTimeInfo();

        if (timeInfo == null || !timeInfo.isJoin()) {
            return;
        }

        CountryWarScanCityReqMessage reqMessage = CountryWarScanCityReqMessage.of(serverConfig.getServerId(), playerContext.getId());
        messageDispatcher.dispatch(reqMessage, response -> {
            CountryWarScanCityResMessage res = (CountryWarScanCityResMessage) response;
            CountryWarSystem countryWarSystem = countryWarService.getCountryWarSystem();
            try {
                CountryWar countryWar = countryWarService.get(playerContext.getId());
                CountryWarGMsg.GResCountryWarCity.Builder data = null;
                if (res != null && res.getScanData() != null) {
                    data = CountryWarGMsg.GResCountryWarCity.parseFrom(res.getScanData()).toBuilder();
                } else {
                    data = CountryWarGMsg.GResCountryWarCity.newBuilder();
                }
                data.setMoveItemNum(countryWar.getMoveItemNum());
                data.setAttackItemNum(countryWar.getAttackItemNum());
                if (countryWar.getAttackItemNum() < countryWarConst.getAttackItemMax()) {
                    data.setAttackAddTime(LocalDateTimeUtil.toEpochSecond(countryWar.getLastAttackAdd()) + countryWarConst.getAttackAddInterval());
                } else {
                    data.setAttackAddTime(0);
                }
                if (countryWar.getMoveItemNum() < countryWarConst.getMoveItemMax()) {
                    data.setMoveAddTime(LocalDateTimeUtil.toEpochSecond(countryWar.getLastMoveAdd()) + countryWarConst.getMoveAddInterval());
                } else {
                    data.setMoveAddTime(0);
                }
//                data.setMoveAddTime(LocalDateTimeUtil.toEpochSecond(countryWar.getLastMoveAdd()) + countryWarConst.getMoveAddInterval());
                boolean hadReward = mapSub(countryWarSystem.getCityRewardCount(), countryWar.getCityRewardCount()).size() > 0 ||
                        mapSub(countryWarSystem.getEventRewardCount(), countryWar.getEventRewardCount()).size() > 0;
                data.setHadReward(hadReward);
                playerContext.write(CmdCode._76351, data.build());
            } catch (Exception e) {
                log.error("byte[] converter to GResCountryWarCity error!", e);
            }
        });
    }

    /***
     * 计算map1-map2;
     * @param map1
     * @param map2
     * @return
     */
    public Map<Integer, Integer> mapSub(Map<Integer, Integer> map1, Map<Integer, Integer> map2) {
        Map<Integer, Integer> result = new HashMap<>();
        map1.forEach((key, value) -> {
            int add = value - map2.getOrDefault(key, 0);
            if (add > 0) {
                result.put(key, add);
            }
        });
        return result;
    }

    @CMD(id = CmdCode._76352)
    public void scanSmallCity(PlayerContext playerContext, CountryWarGMsg.GReqCountryWarSmallCity req) {
        CountryWarStageTimeInfo timeInfo = countryWarService.getCountryWarStageTimeInfo();
        Asserts.isTrue(timeInfo != null || timeInfo.isJoin(),
                ErrorCode.COUNTRY_WAR_NOT_JOIN.getValue(),
                String.format("跨服链接断开"));
        countryWarCitySysCache.getOrThrow(req.getIdx());

        CountryWarScanSmallCityReqMessage reqMessage = CountryWarScanSmallCityReqMessage.of(playerContext.getId(), req.getIdx(),
                serverConfig.getServerId());
        messageDispatcher.dispatch(reqMessage, response -> {
            CountryWarScanSmallCityResMessage res = (CountryWarScanSmallCityResMessage) response;
            try {
                if (res.getSmallCity() != null) {
                    CountryWarGMsg.GResCountryWarSmallCity data = CountryWarGMsg.GResCountryWarSmallCity.parseFrom(res.getSmallCity());
                    playerContext.write(CmdCode._76352, data);
                } else {
                    playerContext.write(CmdCode._76352, CountryWarGMsg.GResCountryWarSmallCity.getDefaultInstance());
                }
            } catch (InvalidProtocolBufferException e) {
                log.error("byte[] converter to GResCountryWarSmallCity error!", e);
            }
        });
    }

    @CMD(id = CmdCode._76353)
    public void attack(PlayerContext playerContext, CountryWarGMsg.GReqCountryWarAttackCity req) {
        CountryWarStageTimeInfo timeInfo = countryWarService.getCountryWarStageTimeInfo();
        Asserts.isTrue(timeInfo != null || timeInfo.isJoin(),
                ErrorCode.CROSS_SERVICE_HAS_BEEN_DISCONNECTED.getValue(),
                String.format("跨服链接断开"));

        countryWarCitySysCache.getOrThrow(req.getIdx());

        Asserts.isTrue(timeInfo.getStage() == CountryWarStage.WAR.getValue(),
                ErrorCode.COUNTRY_WAR_STAGE_ERROR.getValue(),
                String.format("状态：{%s}错误", timeInfo.getStage()));

        CountryWar countryWar = countryWarService.get(playerContext.getId());
        Asserts.isTrue(countryWar.getAttackItemNum() > 0,
                ErrorCode.ITEM_NUM_LOW.getValue(),
                String.format("道具不足", timeInfo.getStage()));

        CountryWarAttackReqMessage reqMessage = new CountryWarAttackReqMessage();
        reqMessage.setAttackId(playerContext.getId());
        reqMessage.setCityId(req.getIdx());
        reqMessage.setServerId(serverConfig.getServerId());
        BattlerDo battlerDo = battleHelper.queryBattlerOrMain(BattleType.COUNTRY_WAR, playerContext.getId(), Faction.ATTACKER);
        reqMessage.setBattleVo(GsonUtils.toJson(battlerDo.toBattlerVo()));
        messageDispatcher.dispatch(reqMessage, response -> {
            CountryWarAttackResMessage res = (CountryWarAttackResMessage) response;

            if (res == null || res.getData() == null) {
                //跨服已经推送了错误码
//                playerContext.write(CmdCode._76353, CountryWarGMsg.GResCountryWarAttackCity.getDefaultInstance());
                return;
            }
            try {
                countryWar.setAttackItemNum(countryWar.getAttackItemNum() - 1);
                if (countryWar.getAttackItemNum() == countryWarConst.getAttackItemMax() - 1) {
                    countryWar.setLastAttackAdd(LocalDateTime.now());
                }
                countryWarService.update(countryWar);

                CountryWarGMsg.GResCountryWarAttackCity.Builder data = CountryWarGMsg.GResCountryWarAttackCity
                        .parseFrom(res.getData()).toBuilder();
                boolean win = true;
                boolean isBattle = res.isTriggerExtraSkill() || (data.getReport().getDefender().getPlayerId() != 0 &&
                        data.getReport().getWinId() == data.getReport().getAttacker().getPlayerId());
                List<ImmutableThing> reward = new ArrayList<>();
                if (isBattle) {
                    win = res.isTriggerExtraSkill() || data.getReport().getWinId() == data.getReport().getAttacker().getPlayerId();
                    if (win) {
                        reward.addAll(countryWarConst.getAttackSuccReward());
                    } else {
                        reward.addAll(countryWarConst.getAttackFailReward());
                    }
                    thingService.add(playerContext.getId(), reward, GameEvent.COUNTRY_WAR_ATTACK, NoticeType.SLIENT);
                }

                if (!reward.isEmpty()) {
                    data.addAllReward(PbUtil.buildReward(reward));
                }
                data.setAttackItemNum(countryWar.getAttackItemNum());
                data.setTriggerSkill(res.isTriggerExtraSkill());
                playerContext.write(CmdCode._76353, data.build());

                eventBus.post(CountryWarAttackEvent.of(playerContext.getId(), win, res.isOccupy()));

            } catch (InvalidProtocolBufferException e) {
                log.error("byte[] converter to GResCountryWarAttackCity error!", e);
            }
        });
    }

    @CMD(id = CmdCode._76354)
    public void move(PlayerContext playerContext, CountryWarGMsg.GReqCountryWarMoveCity req) {
        CountryWarStageTimeInfo timeInfo = countryWarService.getCountryWarStageTimeInfo();
        Asserts.isTrue(timeInfo != null || timeInfo.isJoin(),
                ErrorCode.CROSS_SERVICE_HAS_BEEN_DISCONNECTED.getValue(),
                String.format("跨服链接断开"));
        Asserts.isTrue(timeInfo.getStage() == CountryWarStage.WAR.getValue(),
                ErrorCode.COUNTRY_WAR_STAGE_ERROR.getValue(),
                String.format("状态：{%s}错误", timeInfo.getStage()));
        CCountryWarCity config = countryWarCitySysCache.getOrThrow(req.getIdx());
        CountryWar countryWar = countryWarService.get(playerContext.getId());

        boolean hadItem = countryWar.getMoveItemNum() >= config.getMove_cost();
        CountryWarMoveReqMessage reqMessage = CountryWarMoveReqMessage.of(req.getIdx(), playerContext.getId(), serverConfig.getServerId(), hadItem);
        messageDispatcher.dispatch(reqMessage, response -> {
            if (response == null) {
                log.info("返回内容为空");
                return;
            }

            CountryWarMoveResMessage res = (CountryWarMoveResMessage) response;
            if (res.isCostItem()) {
                countryWar.setMoveItemNum(countryWar.getMoveItemNum() - config.getMove_cost());
                if (countryWar.getMoveItemNum() == countryWarConst.getMoveItemMax() - 1) {
                    countryWar.setLastMoveAdd(LocalDateTime.now());
                    countryWarService.update(countryWar);
                }
                eventBus.post(CountryWarMoveEvent.of(playerContext.getId(), res.isCostItem()));
            }
            if (res.getData() == null) {
                playerContext.write(CmdCode._76354, CountryWarGMsg.GResCountryWarMoveCity.getDefaultInstance());
                return;
            }
            try {
                CountryWarGMsg.GResCountryWarMoveCity.Builder data = CountryWarGMsg.GResCountryWarMoveCity
                        .parseFrom(res.getData()).toBuilder();
                data.setMoveItemNum(countryWar.getMoveItemNum());
                playerContext.write(CmdCode._76354, data.build());
            } catch (InvalidProtocolBufferException e) {
                log.error("byte[] converter to GResCountryWarAttackCity error!", e);
            }
        });
    }

    @CMD(id = CmdCode._76355)
    public void scoreInfo(PlayerContext playerContext, CountryWarGMsg.GReqCountryWarScore req) {
        CountryWarStageTimeInfo timeInfo = countryWarService.getCountryWarStageTimeInfo();
        Asserts.isTrue(timeInfo != null || timeInfo.isJoin(),
                ErrorCode.COUNTRY_WAR_NOT_JOIN.getValue(),
                String.format("未参加国战"));
        Asserts.isTrue(timeInfo.getStage() == CountryWarStage.WAR.getValue(),
                ErrorCode.COUNTRY_WAR_STAGE_ERROR.getValue(),
                String.format("状态：{%s}错误", timeInfo.getStage()));

        CountryWar countryWar = countryWarService.get(playerContext.getId());
        CountryWarGMsg.GResCountryWarScore.Builder builder = CountryWarGMsg.GResCountryWarScore.newBuilder();
        countryWar.getScoreMission().forEach((type, mission) -> {
            CountryWarGMsg.PSCountryWarScoreMission.Builder missionBuilder = CountryWarGMsg.PSCountryWarScoreMission.newBuilder();
            missionBuilder.setRound(mission.getRound());
            missionBuilder.setType(type);
            List<CCountryWarMission> configs = countryWarMissionSysCache.getByRoundAndType(type, mission.getRound());
            configs.forEach(config -> {
                missionBuilder.addTask(countryWarPb.builder(mission, config));
            });
            LocalDate nextRefreshTime = mission.getRefreshDate().plusDays(CountryWarMissionType.typeOf(type).getDay());
            missionBuilder.setRefreshTime(nextRefreshTime.isBefore(timeInfo.getNextStageTime().toLocalDate()) ?
                    LocalDateTimeUtil.toEpochSecond(nextRefreshTime) :
                    LocalDateTimeUtil.toEpochSecond(timeInfo.getNextStageTime()));
            builder.addTasks(missionBuilder);
        });
        builder.addAllScoreRecord(countryWar.getScoreReward());
        builder.addAllMysteryScoreRecord(countryWar.getScoreMysteryReward());
        builder.setBuyGem(countryWar.isBuyMystery());
        builder.setScore(countryWar.getScore());
        playerContext.write(CmdCode._76355, builder.build());
    }

    @CMD(id = CmdCode._76356)
    public void getScoreMissionReward(PlayerContext playerContext, CountryWarGMsg.GReqCountryWarScoreMissionGet req) {
        CountryWar countryWar = countryWarService.get(playerContext.getId());
        CCountryWarMission config = countryWarMissionSysCache.getById(req.getIdx());
        CountryWarScoreMission mission = countryWar.getScoreMission().get(config.getType());
        Asserts.isTrue(config.getTarget().getTarget() <= mission.getCount(config.getIdx()),
                ErrorCode.PROCESS_LOW.getValue(), String.format("任务：{%s},进度:{%s}不足", config.getIdx(), mission.getCount(config.getIdx())));
        Asserts.isTrue(!mission.getMissionReward().getOrDefault(config.getIdx(), false),
                ErrorCode.REWARD_REPEAT_GET.getValue(), String.format("重复领奖：{%s},领奖状态:{%s}", config.getIdx(),
                        mission.getMissionReward().getOrDefault(config.getIdx(), false)));

        mission.getMissionReward().put(config.getIdx(), true);
        countryWarService.update(countryWar);
        thingService.add(playerContext.getId(), config.getReward(), GameEvent.COUNTRY_WAR_SCORE);

        CountryWarGMsg.GResCountryWarScoreMissionGet.Builder builder = CountryWarGMsg.GResCountryWarScoreMissionGet.newBuilder();
        builder.setTask(countryWarPb.builder(mission, config));
        builder.setScore(countryWar.getScore());
        playerContext.write(CmdCode._76356, builder.build());
    }

    @CMD(id = CmdCode._76358)
    public void getScoreReward(PlayerContext playerContext, CountryWarGMsg.GReqCountryWarScoreGet req) {

        CountryWar countryWar = countryWarService.get(playerContext.getId());
        List<CCountryWarMissionScore> rewardConfigs = new ArrayList<>();
        if (req.getIdx() != 0) {
            CCountryWarMissionScore config = countryWarMissionScoreSysCache.getOrThrow(req.getIdx());
            Asserts.isTrue(countryWar.getScore() >= config.getNeed_score().get(0).getItem_num(),
                    ErrorCode.COUNTRY_WAR_SCORE_LOW.getValue(),
                    String.format("配置：{%s}积分：{%s}不足", req.getIdx(), countryWar.getScore()));

            Asserts.isTrue(!countryWar.getScoreReward().contains(req.getIdx()) || (countryWar.isBuyMystery() &&
                            !countryWar.getScoreMysteryReward().contains(req.getIdx())),
                    ErrorCode.COUNTRY_WAR_SCORE_LOW.getValue(),
                    String.format("已经领取:{%s}-{%s}", GsonUtils.toJson(countryWar.getScoreReward()), req.getIdx()));
            rewardConfigs.add(config);
        } else {//idx==0代表一键领取
            rewardConfigs = countryWarMissionScoreSysCache.getByType(countryWarService.getOpenType()).stream().filter(config ->
                    config.getNeed_score().get(0).getItem_num() <= countryWar.getScore()).collect(Collectors.toList());
            rewardConfigs = rewardConfigs.stream().filter(config -> !countryWar.getScoreReward().contains(config.getIdx()) ||
                    (countryWar.isBuyMystery() && !countryWar.getScoreMysteryReward().contains(req.getIdx()))).collect(Collectors.toList());
            Asserts.isTrue(rewardConfigs.size() > 0,
                    ErrorCode.COUNTRY_WAR_SCORE_LOW.getValue(),
                    String.format("配置：{%s}积分：{%s}不足", req.getIdx(), countryWar.getScore()));

        }

        List<ImmutableThing> reward = new ArrayList<>();
        for (CCountryWarMissionScore config : rewardConfigs) {
            if (countryWar.getScoreReward().add(config.getIdx())) {
                reward.addAll(config.getReward());
            }
            if (countryWar.isBuyMystery()) {
                if (countryWar.getScoreMysteryReward().add(config.getIdx())) {
                    reward.addAll(config.getMystery_reward());
                }
            }
        }
        countryWarService.update(countryWar);
        thingService.add(playerContext.getId(), reward, GameEvent.COUNTRY_WAR_SCORE);

        CountryWarGMsg.GResCountryWarScoreGet.Builder builder = CountryWarGMsg.GResCountryWarScoreGet.newBuilder();
        builder.addAllScoreRecord(countryWar.getScoreReward());
        builder.addAllMysteryScoreRecord(countryWar.getScoreMysteryReward());
        playerContext.write(CmdCode._76358, builder.build());

    }

    @CMD(id = CmdCode._76359)
    public void getCityReward(PlayerContext playerContext, CountryWarGMsg.GReqCountryWarGetCityReward req) {

        CountryWarSystem countryWarSystem = countryWarService.getCountryWarSystem();
        CountryWar countryWar = countryWarService.get(playerContext.getId());
        Map<Integer, Integer> cityReward = mapSub(countryWarSystem.getCityRewardCount(), countryWar.getCityRewardCount());
        Map<Integer, Integer> eventReward = mapSub(countryWarSystem.getEventRewardCount(), countryWar.getEventRewardCount());

        Asserts.isTrue(!cityReward.isEmpty() || !eventReward.isEmpty(),
                ErrorCode.SYSTEM_ERROR.getValue(),
                String.format("不存在奖励可以领取"));

        countryWar.getCityRewardCount().putAll(countryWarSystem.getCityRewardCount());
        countryWar.getEventRewardCount().putAll(countryWarSystem.getEventRewardCount());
        countryWarService.update(countryWar);

        List<ImmutableThing> rewards = new ArrayList<>();
        cityReward.forEach((key, value) -> {
            rewards.addAll(ImmutableThingUtil.multiplyThing(countryWarCitySysCache.getById(key).getReward(),
                    Math.min(value, countryWarConst.getCityRewardMaxCount())));
        });
        eventReward.forEach((key, value) -> {
            rewards.addAll(ImmutableThingUtil.multiplyThing(countryWarRandomEventSysCache.getById(key).getReward(),
                    Math.min(value, countryWarConst.getCityRewardMaxCount())));
        });
        List<ImmutableThing> mergeRewards = ImmutableThingUtil.mergeThing(rewards);
        thingService.add(countryWar.getRid(), mergeRewards, GameEvent.COUNTRY_WAR_CITY_SCHEDULER);

        CountryWarGMsg.GResCountryWarGetCityReward.Builder builder = CountryWarGMsg.GResCountryWarGetCityReward.newBuilder();
        builder.setHadReward(false);
        playerContext.write(CmdCode._76359, builder.build());
    }

    @CMD(id = CmdCode._76370)
    public void lottery(PlayerContext playerContext, CountryWarGMsg.GReqCountryWarLottery req) {
        CountryWarStageTimeInfo timeInfo = countryWarService.getCountryWarStageTimeInfo();
        Asserts.isTrue(timeInfo != null || timeInfo.isJoin(),
                ErrorCode.CROSS_SERVICE_HAS_BEEN_DISCONNECTED.getValue(),
                String.format("跨服链接断开"));

        Asserts.isTrue(req.getLotteryTimes() > 0,
                ErrorCode.SYSTEM_ERROR.getValue(),
                String.format("次数{%s}不合法", req.getLotteryTimes()));

        thingService.cost(playerContext.getId(), ImmutableThingUtil.multiplyThing(countryWarConst.getLotteryCost(), req.getLotteryTimes()),
                GameEvent.COUNTRY_WAR_LOTTERY);
        CountryWar countryWar = countryWarService.get(playerContext.getId());
        countryWar.setLotteryCount(countryWar.getLotteryCount() + req.getLotteryTimes());
        countryWarService.update(countryWar);

        List<ImmutableThing> rewards = new ArrayList<>();
        CCountryWarLottery first = null;
        for (int i = 0; i < req.getLotteryTimes(); i++) {
            CCountryWarLottery config = countryWarLotterySysCache.getByRoundAndMaxCount(timeInfo.getRound(),
                    countryWar.getLotteryCount() - i);
            if (config == null) {
                int finalI = i;
                List<CCountryWarLottery> configs = countryWarLotterySysCache.getByRound(timeInfo.getRound()).stream().
                        filter(configTemp -> configTemp.getMin_count() <= countryWar.getLotteryCount() - finalI).collect(Collectors.toList());
                config = DropUtil.randomDrop(configs);
            }
            first = config;
            rewards.addAll(config.getReward());
        }
        rewards = ImmutableThingUtil.mergeThing(rewards);
        thingService.add(playerContext.getId(), rewards, GameEvent.COUNTRY_WAR_LOTTERY, NoticeType.SLIENT);

        CountryWarGMsg.GResCountryWarLottery.Builder builder = CountryWarGMsg.GResCountryWarLottery.newBuilder();
        builder.addAllReward(PbUtil.buildReward(rewards));
        builder.setIdx(first.getIdx());
        playerContext.write(CmdCode._76370, builder.build());

    }

    @CMD(id = CmdCode._76371)
    public void lotteryData(PlayerContext playerContext, CountryWarGMsg.GReqCountryWarLotteryData req) {
        CountryWarStageTimeInfo timeInfo = countryWarService.getCountryWarStageTimeInfo();
        Asserts.isTrue(timeInfo != null || timeInfo.isJoin(),
                ErrorCode.COUNTRY_WAR_NOT_JOIN.getValue(),
                String.format("跨服链接断开"));

        CountryWarGMsg.GResCountryWarLotteryData.Builder builder = CountryWarGMsg.GResCountryWarLotteryData.newBuilder();
        builder.setRound(Math.min(timeInfo.getRound(), countryWarLotterySysCache.getMaxRound()));
        playerContext.write(CmdCode._76371, builder.build());

    }

    @CMD(id = CmdCode._76375)
    public void flagInfo(PlayerContext playerContext, CountryWarGMsg.GReqCountryWarFlag req) {
        CountryWar countryWar = countryWarService.get(playerContext.getId());
        CountryWarGMsg.GResCountryWarFlag.Builder builder = CountryWarGMsg.GResCountryWarFlag.newBuilder();
        builder.setRound(countryWar.getFlagRound());
        countryWarFlagMissionSysCache.getAll().forEach(config -> {
            builder.addTasks(countryWarPb.builderFlag(countryWar, config));
        });
        builder.addAllRoundReward(countryWar.getFlagRoundReward());
        playerContext.write(CmdCode._76375, builder.build());
    }

    @CMD(id = CmdCode._76376)
    public void getFlagMission(PlayerContext playerContext, CountryWarGMsg.GReqCountryWarFlagMissionGet req) {
        CountryWar countryWar = countryWarService.get(playerContext.getId());
        CCountryWarFlagMission config = countryWarFlagMissionSysCache.getOrThrow(req.getIdx());
        long count = countryWar.getFlagMissionCount().getOrDefault(config.getIdx(), 0l);
        Asserts.isTrue(count >= config.getTarget().getTarget(),
                ErrorCode.PROCESS_LOW.getValue(), String.format("任务：{%s},进度:{%s}不足", req.getIdx(), count));
        Asserts.isTrue(!countryWar.getFlagMissionReward().getOrDefault(config.getIdx(), false),
                ErrorCode.REWARD_REPEAT_GET.getValue(), String.format("重复领奖：{%s},领奖状态:{%s}", config.getIdx(),
                        countryWar.getFlagMissionReward().getOrDefault(config.getIdx(), false)));
        Asserts.isTrue(config.getRound() == countryWar.getFlagRound() + 1,
                ErrorCode.REWARD_REPEAT_GET.getValue(), String.format("轮次不对:{%s}", config.getIdx()));

        countryWar.getFlagMissionReward().put(config.getIdx(), true);
        if (countryWarFlagMissionSysCache.getByRound(config.getRound()).stream()
                .allMatch(configTemp -> countryWar.getFlagMissionReward().getOrDefault(configTemp.getIdx(), false))) {
            if (countryWar.getFlagRound() < countryWarFlagMissionSysCache.getMaxRound()) {
                countryWar.setFlagRound(countryWar.getFlagRound() + 1);
            }
        }
        countryWarService.update(countryWar);

        thingService.add(playerContext.getId(), config.getReward(), GameEvent.COUNTRY_WAR_FLAG);

        CountryWarGMsg.GResCountryWarFlagMissionGet.Builder builder = CountryWarGMsg.GResCountryWarFlagMissionGet.newBuilder();
        builder.setTask(countryWarPb.builderFlag(countryWar, config));
        builder.setRound(countryWar.getFlagRound());
        playerContext.write(CmdCode._76376, builder.build());
    }

    @CMD(id = CmdCode._76378)
    public void getRoundReward(PlayerContext playerContext, CountryWarGMsg.GReqCountryWarFlagRoundGet req) {

        CCountryWarFlagRoundReward config = countryWarFlagRoundRewardSysCache.getOrThrow(req.getIdx());
        CountryWar countryWar = countryWarService.get(playerContext.getId());
        Asserts.isTrue(config.getRound() <= countryWar.getFlagRound(),
                ErrorCode.COUNTRY_WAR_ROUND_MISSION_NOT_COMPLETE.getValue(),
                String.format("没有完成该轮次所有任务：{%s}，{%s}不足", req.getIdx(), countryWar.getFlagRound()));

        Asserts.isTrue(config.getIdx() == countryWarService.getOpenType(),
                ErrorCode.COUNTRY_WAR_ROUND_MISSION_NOT_COMPLETE.getValue(),
                String.format("轮次不对：{%s}，{%s}不足", req.getIdx(), countryWarService.getOpenType()));

        Asserts.isTrue(!countryWar.getFlagRoundReward().contains(req.getIdx()),
                ErrorCode.COUNTRY_WAR_REPEATED_REWARD.getValue(),
                String.format("已经领取:{%s}-{%s}", GsonUtils.toJson(countryWar.getFlagRoundReward()), req.getIdx()));

        countryWar.getFlagRoundReward().add(config.getIdx());
        countryWarService.update(countryWar);

        thingService.add(playerContext.getId(), config.getReward(), GameEvent.COUNTRY_WAR_FLAG);

        CountryWarGMsg.GResCountryWarFlagRoundGet.Builder builder = CountryWarGMsg.GResCountryWarFlagRoundGet.newBuilder();
        builder.addAllRoundReward(countryWar.getFlagRoundReward());
        playerContext.write(CmdCode._76378, builder.build());

    }

    @CMD(id = CmdCode._76385)
    public void serverLog(PlayerContext playerContext, CountryWarGMsg.GReqCountryWarServerLog req) {
        messageDispatcher.dispatch(CountryWarServerLogReqMessage.of(serverConfig.getServerId(), playerContext.getId()), response -> {
            CountryWarServerLogResMessage res = (CountryWarServerLogResMessage) response;
            if (res.getData() != null) {
                try {
                    CountryWarGMsg.GResCountryWarServerLog data = CountryWarGMsg.GResCountryWarServerLog.parseFrom(res.getData());
                    playerContext.write(CmdCode._76385, data);
                    return;
                } catch (InvalidProtocolBufferException e) {
                    log.error("协议解析失败", e);
                }
            }
            playerContext.write(CmdCode._76385, CountryWarGMsg.GResCountryWarServerLog.getDefaultInstance());
        });
    }

    @CMD(id = CmdCode._76386)
    public void roleLog(PlayerContext playerContext, CountryWarGMsg.GReqCountryWarServerLog req) {
        messageDispatcher.dispatch(CountryWarRoleLogReqMessage.of(playerContext.getId()), response -> {
            CountryWarRoleLogResMessage res = (CountryWarRoleLogResMessage) response;
            if (res.getData() != null) {
                try {
                    CountryWarGMsg.GResCountryWarRoleLog data = CountryWarGMsg.GResCountryWarRoleLog.parseFrom(res.getData());
                    playerContext.write(CmdCode._76386, data);
                    return;
                } catch (InvalidProtocolBufferException e) {
                    log.error("协议解析失败", e);
                }
            }
            playerContext.write(CmdCode._76386, CountryWarGMsg.GResCountryWarRoleLog.getDefaultInstance());
        });
    }

    @CMD(id = CmdCode._76390)
    public void rankList(PlayerContext playerContext, CountryWarGMsg.GReqCountryWarRank req) {
        messageDispatcher.dispatch(CountryWarRankListReqMessage.of(serverConfig.getServerId(), playerContext.getId(), req.getRankType()), response -> {
            CountryWarRankListResMessage res = (CountryWarRankListResMessage) response;
            if (res == null || res.getRankData() == null) {
                playerContext.write(CmdCode._76390, CountryWarGMsg.GResCountryWarRank.getDefaultInstance());
                return;
            }
            try {
                CountryWarGMsg.GResCountryWarRank data = CountryWarGMsg.GResCountryWarRank.parseFrom(res.getRankData());
                playerContext.write(CmdCode._76390, data);
            } catch (InvalidProtocolBufferException e) {
                log.error("排行榜协议解析失败", e);
            }
        });
    }

    @CMD(id = CmdCode._76395)
    public void randomShop(PlayerContext playerContext, CountryWarGMsg.GReqCountryWarRandomShop req) {
        CountryWarStageTimeInfo timeInfo = countryWarService.getCountryWarStageTimeInfo();
        Asserts.isTrue(timeInfo != null,
                ErrorCode.CROSS_SERVICE_HAS_BEEN_DISCONNECTED.getValue(),
                String.format("跨服链接断开"));
//        Asserts.isTrue(timeInfo.getStage() == CountryWarStage.WAR.getValue() && timeInfo.isJoin(),
//                ErrorCode.COUNTRY_WAR_STAGE_ERROR.getValue(),
//                String.format("状态：{%s}错误", timeInfo.getStage()));

        CountryWar countryWar = countryWarService.get(playerContext.getId());
        CountryWarGMsg.GResCountryWarRandomShop.Builder builder = CountryWarGMsg.GResCountryWarRandomShop.newBuilder();
        countryWar.getShopBuyCount().forEach((key, value) -> {
            builder.addBuyCount(PbUtil.builderMap(key, value));
        });

        playerContext.write(CmdCode._76395, builder.build());
    }

    @CMD(id = CmdCode._76396)
    public void randomShopBuy(PlayerContext playerContext, CountryWarGMsg.GReqCountryWarRandomShopBuy req) {
        CountryWarStageTimeInfo timeInfo = countryWarService.getCountryWarStageTimeInfo();
        Asserts.isTrue(timeInfo != null || timeInfo.isJoin(),
                ErrorCode.COUNTRY_WAR_NOT_JOIN.getValue(),
                String.format("未参与国战"));
//        Asserts.isTrue(timeInfo.getStage() == CountryWarStage.WAR.getValue() && timeInfo.isJoin(),
//                ErrorCode.COUNTRY_WAR_STAGE_ERROR.getValue(),
//                String.format("状态：{%s}错误", timeInfo.getStage()));

        Asserts.isTrue(req.getCount() > 0,
                ErrorCode.SYSTEM_ERROR.getValue(),
                String.format("购买数量：{%s}错误", req.getCount()));

        CountryWar countryWar = countryWarService.get(playerContext.getId());
        CCountryWarRandomShop config = countryWarRandomShopSysCache.getOrThrow(req.getIdx());

        Asserts.isTrue(countryWar.getShopBuyCount().getOrDefault(req.getIdx(), 0) < config.getBuy_limit(),
                ErrorCode.BUY_SPACE_MAX_TIMES.getValue(),
                String.format("购买数量：{%s}错误", countryWar.getShopBuyCount().getOrDefault(req.getIdx(), 0)));

        List<ImmutableThing> cost = ImmutableThingUtil.multiplyThing(config.getNeed_item(), req.getCount());
        Asserts.isTrue(thingService.enough(playerContext.getId(), cost),
                ErrorCode.ITEM_NUM_LOW.getValue(),
                String.format("道具不足：{%s}", config.getIdx()));

        messageDispatcher.dispatch(CountryWarRandomShopBuyReqMessage.of(serverConfig.getServerId(), playerContext.getId()),
                response -> {
                    CountryWarRandomShopBuyResMessage res = (CountryWarRandomShopBuyResMessage) response;
                    if (res == null) {
                        return;
                    }
                    CountryWarGMsg.GResCountryWarRandomShopBuy.Builder data = CountryWarGMsg.GResCountryWarRandomShopBuy.newBuilder();
                    if (res.isBuySuccess()) {
                        thingService.cost(playerContext.getId(), cost, GameEvent.COUNTRY_WAR_RANDOM_SHOP);
                        thingService.add(playerContext.getId(), ImmutableThingUtil.multiplyThing(config.getItem_type(),
                                req.getCount()), GameEvent.COUNTRY_WAR_RANDOM_SHOP);
                        countryWar.getShopBuyCount().put(req.getIdx(), countryWar.getShopBuyCount().getOrDefault(req.getIdx(), 0) + req.getCount());
                        countryWarService.update(countryWar);

                        countryWar.getShopBuyCount().forEach((key, value) -> {
                            data.addBuyCount(PbUtil.builderMap(key, value));
                        });
                        eventBus.post(CountryWarRandomShopBuyEvent.of(playerContext.getId(), req.getCount()));
                    }
                    playerContext.write(CmdCode._76396, data.build());
                });
    }

    @GMCommand(command = GMCmdCode.COUNTRY_WAR_ADD_ITEM)
    public void addCountryItem(Role role, List<String> param) {
        int add = Integer.valueOf(param.get(0));
        CountryWar countryWar = countryWarService.get(role.getId());
        countryWar.setMoveItemNum(countryWar.getMoveItemNum() + add);
        countryWar.setAttackItemNum(countryWar.getAttackItemNum() + add);
        countryWarService.update(countryWar);
    }

    @GMCommand(command = GMCmdCode.COUNTRY_WAR_GM_NEXT)
    public void nextStage(Role role, List<String> param) {
        CountryWarGMReqMessage.CountryWarGMReqMessageBuilder builder = CountryWarGMReqMessage.builder();
        builder.type(0);
        builder.mainServerId(serverConfig.getServerId());
        messageDispatcher.dispatch(builder.build());
    }

    @GMCommand(command = GMCmdCode.COUNTRY_WAR_CLEAR_SHOP)
    public void clearShop(Role role, List<String> param) {
        CountryWarGMReqMessage.CountryWarGMReqMessageBuilder builder = CountryWarGMReqMessage.builder();
        builder.type(1);
        builder.mainServerId(serverConfig.getServerId());
        messageDispatcher.dispatch(builder.build());
    }

    @GMCommand(command = GMCmdCode.COUNTRY_WAR_CLEAR_CITY)
    public void clearCity(Role role, List<String> param) {
        CountryWarGMReqMessage.CountryWarGMReqMessageBuilder builder = CountryWarGMReqMessage.builder();
        builder.type(2);
        builder.mainServerId(serverConfig.getServerId());
        messageDispatcher.dispatch(builder.build());
    }

    @GMCommand(command = GMCmdCode.COUNTRY_WAR_FORCE_GROUP)
    public void forceGroup(Role role, List<String> param) {
        CountryWarGMReqMessage.CountryWarGMReqMessageBuilder builder = CountryWarGMReqMessage.builder();
        builder.type(3);
        builder.mainServerId(serverConfig.getServerId());
        messageDispatcher.dispatch(builder.build());
    }

    @GMCommand(command = GMCmdCode.COUNTRY_WAR_RESET_FACTION)
    public void resetFaction(Role role, List<String> param) {
        CountryWarGMReqMessage.CountryWarGMReqMessageBuilder builder = CountryWarGMReqMessage.builder();
        builder.type(4);
        builder.mainServerId(serverConfig.getServerId());
        messageDispatcher.dispatch(builder.build());
    }

    @GMCommand(command = GMCmdCode.COUNTRY_WAR_MISSION)
    public void scoreGMMission(Role role, List<String> param) {
        CountryWar countryWar = countryWarService.get(role.getId());
        int process = Integer.valueOf(param.get(0));
        countryWarMissionSysCache.getAllType().forEach(type -> {
            List<CCountryWarMission> configs = countryWarMissionSysCache.getByRoundAndType(type, countryWar.getScoreMission().get(type).getRound());
            CountryWarScoreMission scoreMission = countryWar.getScoreMission().get(type);
            configs.forEach(config -> {
                scoreMission.getMissionCount().put(config.getIdx(), scoreMission.getMissionCount().getOrDefault(config.getIdx(), 0l) + process);
            });
            CountryWarGMsg.GResCountryWarScoreMissionUpdate.Builder builder = CountryWarGMsg.GResCountryWarScoreMissionUpdate.newBuilder();
            for (CCountryWarMission config : configs) {
                CountryWarScoreMission mission = countryWar.getScoreMission().get(config.getType());
                builder.addTask(countryWarPb.builder(mission, config));
            }

            contextManager.write(role.getId(), CmdCode._76357, builder.build());
        });


        countryWarMissionSysCache.getAllType().forEach(type -> {
            CountryWarScoreMission scoreMission = countryWar.getScoreMission().get(type);
            List<CCountryWarMission> configs = countryWarMissionSysCache.getByRoundAndType(type, scoreMission.getRound());
            configs.forEach(config -> {
                scoreMission.getMissionCount().put(config.getIdx(), scoreMission.getMissionCount().getOrDefault(config.getIdx(), 0l) + process);
            });
        });
        List<CCountryWarFlagMission> list = countryWarFlagMissionSysCache.getAll();
        for (CCountryWarFlagMission config : list) {
            countryWar.addFlagCount(config.getIdx(), process);
        }
        CountryWarGMsg.GResCountryWarFlagMissionUpdate.Builder builder = CountryWarGMsg.GResCountryWarFlagMissionUpdate.newBuilder();
        for (CCountryWarFlagMission config : list) {
            builder.addTask(countryWarPb.builderFlag(countryWar, config));
        }
        contextManager.write(role.getId(), CmdCode._76377, builder.build());

        countryWarService.update(countryWar);
    }
}
