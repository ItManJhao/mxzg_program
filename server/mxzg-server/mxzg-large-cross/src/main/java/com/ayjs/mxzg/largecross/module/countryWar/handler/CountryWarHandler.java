package com.ayjs.mxzg.largecross.module.countryWar.handler;

import com.ayjs.mxzg.battle.command.BattleCommand;
import com.ayjs.mxzg.battle.model.BattleResult;
import com.ayjs.mxzg.battle.model.BattleType;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.Faction;
import com.ayjs.mxzg.battle.model.UnitType;
import com.ayjs.mxzg.battle.model.mirror.BattlerVo;
import com.ayjs.mxzg.common.command.serivce.CommandBus;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.RandomUtil;
import com.ayjs.mxzg.common.util.gson.GsonUtils;
import com.ayjs.mxzg.config.excel.cache.countryWar.CountryWarCityRelationSysCache;
import com.ayjs.mxzg.config.excel.cache.countryWar.CountryWarCitySysCache;
import com.ayjs.mxzg.config.excel.cache.countryWar.CountryWarRandomShopSysCache;
import com.ayjs.mxzg.config.excel.cache.countryWar.CountryWarTimeSysCache;
import com.ayjs.mxzg.config.excel.entity.countrywar.CCountryWarCity;
import com.ayjs.mxzg.config.excel.entity.countrywar.CCountryWarCityRelation;
import com.ayjs.mxzg.config.excel.entity.countrywar.CCountryWarTime;
import com.ayjs.mxzg.config.excel.entity.countrywar.CountryWarStage;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.largecross.module.countryWar.dao.CountryWarRoleDao;
import com.ayjs.mxzg.largecross.module.countryWar.dao.CountryWarServerDao;
import com.ayjs.mxzg.largecross.module.countryWar.dao.CountryWarSettleDao;
import com.ayjs.mxzg.largecross.module.countryWar.dao.CountryWarTimeDao;
import com.ayjs.mxzg.largecross.module.countryWar.domain.CountryWarRole;
import com.ayjs.mxzg.largecross.module.countryWar.domain.CountryWarServer;
import com.ayjs.mxzg.largecross.module.countryWar.domain.CountryWarSettle;
import com.ayjs.mxzg.largecross.module.countryWar.domain.CountryWarTime;
import com.ayjs.mxzg.largecross.module.countryWar.event.CountryWarAttackCityEvent;
import com.ayjs.mxzg.largecross.module.countryWar.event.CountryWarBroadcastEvent;
import com.ayjs.mxzg.largecross.module.countryWar.event.CountryWarCityChangeServerEvent;
import com.ayjs.mxzg.largecross.module.countryWar.event.CountryWarDefendMaxCountEvent;
import com.ayjs.mxzg.largecross.module.countryWar.event.CountryWarDefendSuccessEvent;
import com.ayjs.mxzg.largecross.module.countryWar.event.CountryWarServerAddScoreEvent;
import com.ayjs.mxzg.largecross.module.countryWar.event.CountryWarUnionEvent;
import com.ayjs.mxzg.largecross.module.countryWar.pb.CountryWarPbConverter;
import com.ayjs.mxzg.largecross.module.countryWar.rank.AbstractCountryWarRankService;
import com.ayjs.mxzg.largecross.module.countryWar.rank.CountryWarRankHelper;
import com.ayjs.mxzg.largecross.module.countryWar.service.CountryWarConnectService;
import com.ayjs.mxzg.largecross.module.countryWar.service.CountryWarService;
import com.ayjs.mxzg.largecross.module.countryWar.struct.CountryWarCity;
import com.ayjs.mxzg.largecross.module.countryWar.struct.CountryWarCityEvent;
import com.ayjs.mxzg.largecross.module.countryWar.struct.CountryWarFaction;
import com.ayjs.mxzg.largecross.module.countryWar.struct.CountryWarGroup;
import com.ayjs.mxzg.largecross.module.countryWar.worker.WarWorker;
import com.ayjs.mxzg.message.module.chat.message.CountryWarChatMessage;
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
import com.ayjs.mxzg.message.module.countryWar.CountryWarRoleUpdateReqMessage;
import com.ayjs.mxzg.message.module.countryWar.CountryWarScanCityReqMessage;
import com.ayjs.mxzg.message.module.countryWar.CountryWarScanCityResMessage;
import com.ayjs.mxzg.message.module.countryWar.CountryWarScanSmallCityReqMessage;
import com.ayjs.mxzg.message.module.countryWar.CountryWarScanSmallCityResMessage;
import com.ayjs.mxzg.message.module.countryWar.CountryWarServerLogReqMessage;
import com.ayjs.mxzg.message.module.countryWar.CountryWarServerLogResMessage;
import com.ayjs.mxzg.message.module.countryWar.CountryWarSettleRecordReqMessage;
import com.ayjs.mxzg.message.module.countryWar.CountryWarSettleRecordResMessage;
import com.ayjs.mxzg.message.module.countryWar.CountryWarStageReqMessage;
import com.ayjs.mxzg.message.module.countryWar.CountryWarStageResMessage;
import com.ayjs.mxzg.message.module.countryWar.CountryWarUploadServerInfoReqMessage;
import com.ayjs.mxzg.message.module.countryWar.dto.CountryWarStageTimeInfo;
import com.ayjs.mxzg.message.module.floatingIslands.struct.RankData;
import com.ayjs.mxzg.message.module.rank.dto.CrossRankType;
import com.ayjs.mxzg.module.battle.BattleTemplate;
import com.ayjs.mxzg.protocol.BattleGMsg;
import com.ayjs.mxzg.protocol.CountryWarGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.ayjs.rpc.annotation.Remote;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.dispatcher.MessageHandler;
import com.ayjs.rpc.server.Connection;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2021/4/12
 **/
@Remote
@Slf4j
public class CountryWarHandler implements MessageHandler {
    @Autowired
    private CountryWarServerDao countryWarServerDao;
    @Autowired
    private CountryWarCitySysCache countryWarCitySysCache;
    @Autowired
    private CountryWarPbConverter countryWarPbConverter;
    @Autowired
    private CountryWarTimeDao countryWarTimeDao;
    @Autowired
    private CountryWarSettleDao countryWarSettleDao;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private CountryWarRoleDao countryWarRoleDao;
    @Autowired
    private BattleTemplate battleTemplate;
    @Autowired
    private CommandBus commandBus;
    @Autowired
    private CountryWarCityRelationSysCache countryWarCityRelationSysCache;
    @Autowired
    private CountryWarRankHelper countryWarRankHelper;
    @Autowired
    private CountryWarTimeSysCache countryWarTimeSysCache;
    @Autowired
    private CountryWarService countryWarService;
    @Autowired
    private CountryWarRandomShopSysCache countryWarRandomShopSysCache;
    @Autowired
    private CountryWarConnectService countryWarConnectService;
    @Autowired
    private WarWorker warWorker;


    //联盟阵营的城池数
    private static int RESET_CAMP = 10;
    //最大防守次数
    private static int DEFEND_MAX_COUNT = 5;

    @RemoteMethod
    public void uploadServer(CountryWarUploadServerInfoReqMessage req) {
        CountryWarServer serverInfo = countryWarServerDao.get(req.getServerId());
        if (serverInfo == null) {
            serverInfo = new CountryWarServer();
            serverInfo.setServerId(req.getServerId());
            countryWarServerDao.add(serverInfo);
        }
        serverInfo.setActiveFighting(req.getActiveFighting());
        serverInfo.setValidServer(true);
        countryWarServerDao.update(serverInfo);
    }

    @RemoteMethod
    public void updateRole(CountryWarRoleUpdateReqMessage req) {
        CountryWarRole role = countryWarRoleDao.get(req.getRid());
        role.setCountryWarRoleInfo(req.getCountryWarRoleInfo());
        role.setBattleVo(req.getBattleVo());
        role.setMainServerId(req.getMainServerId());
        role.setOnline(req.isOnline());
        countryWarRoleDao.update(role);

        tryAddToBaseCamp(role);

    }

    private void tryAddToBaseCamp(CountryWarRole role) {
        //尝试加入到大本营
        CountryWarTime time = countryWarTimeDao.getSingle();
        if (time.getStage() != CountryWarStage.WAR.getValue() || role.getDefendCity() > 0) {
            return;
        }
        CountryWarTime countryWarTime = countryWarTimeDao.getSingle();
        CountryWarServer server = countryWarServerDao.get(role.getMainServerId());
        Integer groupId = countryWarTime.getServer2Group().get(role.getMainServerId());
        if (groupId != null) {
            synchronized (groupId) {
                CountryWarCity city = countryWarTime.getGroupData().get(groupId).getCity(server.getBaseCamp());
                CCountryWarCity config = countryWarCitySysCache.getById(city.getId());
                addDefendForCity(role, city);
                countryWarRoleDao.update(role);
                countryWarTimeDao.update(countryWarTime);
            }
        }
    }

    @RemoteMethod
    public CountryWarAttackResMessage attack(CountryWarAttackReqMessage req) {
        CCountryWarCity cityConfig = countryWarCitySysCache.getById(req.getCityId());
        Asserts.isTrue(cityConfig.getCan_attack() == 1,
                ErrorCode.SYSTEM_ERROR.getValue(),
                String.format("城池不能攻击：%s", req.getCityId()));

        CountryWarTime countryWarTime = countryWarTimeDao.getSingle();

        Asserts.isTrue(countryWarTime.getStage() != CountryWarStage.CLOSE_ING.getValue(),
                ErrorCode.COUNTRY_WAR_CLOSING.getValue(),
                String.format("活动已关闭：%s", countryWarTime.getStage()));

        Integer groupId = countryWarTime.getServer2Group().get(req.getServerId());
        Asserts.isTrue(groupId != null,
                ErrorCode.COUNTRY_WAR_NOT_JOIN.getValue(),
                String.format("服务器未参与国战：%s", req.getServerId()));

        CountryWarGroup groupData = countryWarTime.getGroupData().get(groupId);

        /***
         * 更细战斗对象
         */
        CountryWarRole attack = countryWarRoleDao.get(req.getRid());

        if (req.getBattleVo() == null) {
            log.error("请求战斗数据时，阵容数据为空");
        } else {
            attack.setBattleVo(req.getBattleVo());
            countryWarRoleDao.update(attack);
        }
        synchronized (groupId) {
            return unsafeAttack(groupData, attack, req);
        }

    }

    @RemoteMethod
    public CountryWarMoveResMessage move(CountryWarMoveReqMessage req) {
        CCountryWarCity cityConfig = countryWarCitySysCache.getById(req.getCityId());

        CountryWarTime countryWarTime = countryWarTimeDao.getSingle();

        Asserts.isTrue(countryWarTime.getStage() != CountryWarStage.CLOSE_ING.getValue(),
                ErrorCode.COUNTRY_WAR_CLOSING.getValue(),
                String.format("活动已关闭：%s", countryWarTime.getStage()));

        Integer groupId = countryWarTime.getServer2Group().get(req.getServerId());
        Asserts.isTrue(groupId != null,
                ErrorCode.COUNTRY_WAR_NOT_JOIN.getValue(),
                String.format("服务器未参与国战：%s", req.getServerId()));
        CountryWarRole role = countryWarRoleDao.get(req.getRid());

        Asserts.isTrue(role.getDefendCity() != req.getCityId(),
                ErrorCode.COUNTRY_WAR_HAD_IN_CITY.getValue(),
                String.format("当前已在该城市：%s", req.getCityId()));

        CountryWarGroup groupData = countryWarTime.getGroupData().get(groupId);
        CountryWarCity city = groupData.getCity(req.getCityId());

        Asserts.isTrue(city.getServerId() > 0,
                ErrorCode.COUNTRY_WAR_NOT_OCCUPY.getValue(),
                String.format("当前已在该城市：%s", req.getCityId()));

        LocalDateTime lastBattleTime = city.getBattleTime() == null ? LocalDateTime.of(1970, 1, 1, 0, 0) : city.getBattleTime();
        LocalDateTime cdWar = lastBattleTime.plusSeconds(cityConfig.getWar_duration());
        CountryWarCity old = null;
        synchronized (groupId) {
            CountryWarServer attackServer = countryWarServerDao.get(req.getServerId());
            CountryWarServer cityServer = countryWarServerDao.get(city.getServerId());
            Asserts.isTrue((attackServer.getFaction() & cityServer.getFaction()) > 0,
                    ErrorCode.COUNTRY_WAR_DIFF_FACTION.getValue(),
                    String.format("阵营不同：%s-%s", attackServer.getFaction(), cityServer.getFaction()));

            Asserts.isTrue(cdWar.isBefore(LocalDateTime.now()) || req.isHadItem(),
                    ErrorCode.ITEM_NUM_LOW.getValue(),
                    String.format("道具不足：%s", req.getCityId()));

            Asserts.isTrue(!city.isIsolate(),
                    ErrorCode.COUNTRY_WAR_ISOLATE.getValue(),
                    String.format("城池处于孤立状态：%s", city.isIsolate()));

            if (role.getDefendCity() > 0) {
                old = groupData.getCity(role.getDefendCity());
                old.removeDefend(req.getRid());
            }
            addDefendForCity(role, city);
            countryWarTimeDao.update(countryWarTime);
        }

        CountryWarMoveResMessage message = new CountryWarMoveResMessage();
        CountryWarGMsg.GResCountryWarMoveCity.Builder builder = CountryWarGMsg.GResCountryWarMoveCity.newBuilder();

        builder.addCities(countryWarPbConverter.build(city, groupData));
        if (old != null) {
            builder.addCities(countryWarPbConverter.build(old, groupData));
        }
        builder.setIdx(req.getCityId());
        builder.setCurrId(role.getDefendCity());
        message.setData(builder.build().toByteArray());
        message.setCostItem(cdWar.isAfter(LocalDateTime.now()));

        if (old != null) {
            eventBus.post(CountryWarBroadcastEvent.of(groupId, Arrays.asList(req.getCityId(), old.getId())));
        } else {
            eventBus.post(CountryWarBroadcastEvent.of(groupId, Arrays.asList(req.getCityId())));
        }
        return message;

    }

    @RemoteMethod
    public CountryWarScanSmallCityResMessage scanSmallCity(CountryWarScanSmallCityReqMessage req) {
        CountryWarTime countryWarTime = countryWarTimeDao.getSingle();
        Asserts.isTrue(countryWarTime.getStage() != CountryWarStage.CLOSE_ING.getValue(),
                ErrorCode.COUNTRY_WAR_CLOSING.getValue(),
                String.format("活动已关闭：%s", countryWarTime.getStage()));

        Integer groupId = countryWarTime.getServer2Group().get(req.getServerId());
        Asserts.isTrue(groupId != null,
                ErrorCode.COUNTRY_WAR_NOT_JOIN.getValue(),
                String.format("服务器未参与国战：%s", req.getServerId()));

        CountryWarGroup groupData = countryWarTime.getGroupData().get(groupId);

        CountryWarScanSmallCityResMessage message = new CountryWarScanSmallCityResMessage();
        message.setSmallCity(countryWarPbConverter.buildSmall(groupData.getCity(req.getCityId())).toByteArray());
        return message;
    }

    @RemoteMethod
    public CountryWarScanCityResMessage scanCity(CountryWarScanCityReqMessage req) {
        CountryWarTime countryWarTime = countryWarTimeDao.getSingle();
//        Asserts.isTrue(countryWarTime.getStage() != CountryWarStage.CLOSE_ING.getValue(),
//                ErrorCode.SYSTEM_ERROR.getValue(),
//                String.format("活动已关闭：%s", countryWarTime.getStage()));

        Integer groupId = countryWarTime.getServer2Group().get(req.getServerId());
        Asserts.isTrue(groupId != null,
                ErrorCode.COUNTRY_WAR_NOT_JOIN.getValue(),
                String.format("服务器未参与国战：%s", req.getServerId()));

        CountryWarRole role = countryWarRoleDao.get(req.getRid());
        if (role == null) {
            //玩家数据没有上传
            log.info("玩家：{}，数据没有上传", req.getRid());
            return CountryWarScanCityResMessage.of(CountryWarGMsg.GResCountryWarCity.getDefaultInstance().toByteArray());
        }
        tryAddToBaseCamp(role);
        CountryWarGMsg.GResCountryWarCity.Builder builder = countryWarService.builderScanCity(req.getServerId(), req.getRid());
        return CountryWarScanCityResMessage.of(builder.build().toByteArray());
    }

    @RemoteMethod
    public CountryWarRankListResMessage rank(CountryWarRankListReqMessage req) {
        CountryWarTime time = countryWarTimeDao.getSingle();
        Integer groupId = time.getServer2Group().get(req.getServerId());
        CountryWarGMsg.GResCountryWarRank.Builder builder = CountryWarGMsg.GResCountryWarRank.newBuilder();
        builder.setRankType(req.getRankType());
        if (groupId == null) {
            return CountryWarRankListResMessage.of(builder.build().toByteArray());
        }
        CrossRankType rankType = CrossRankType.typeOf(req.getRankType());
        AbstractCountryWarRankService rankService = countryWarRankHelper.getByRankType(rankType);
        List<CountryWarGMsg.PSCountryWarRank> list = rankService.getAll(groupId);
        CountryWarGMsg.PSCountryWarRank self;
        if (rankType == CrossRankType.COUNTRY_WAR_SCORE) {
            self = rankService.getOne(groupId, req.getServerId());
        } else {
            self = rankService.getOne(groupId, req.getRid());
        }

        builder.addAllRanks(list);
        builder.setSelf(self);

        return CountryWarRankListResMessage.of(builder.build().toByteArray());
    }

    @RemoteMethod
    public void settleRecord(CountryWarSettleRecordReqMessage req, Connection connection) {
        List<CountryWarSettle> settles = countryWarSettleDao.listAll();
        CountryWarSettle settle = settles.stream().max(Comparator.comparingInt(CountryWarSettle::getRound)).orElse(null);

        CountryWarSettleRecordResMessage res = new CountryWarSettleRecordResMessage();
        int maxRound = req.getStartRound();
        if (settle != null && settle.getRound() > maxRound) {
            maxRound = settle.getRound();
            Integer groupId = settle.getServer2Group().get(req.getServerId());
            if (groupId != null) {
                List<RankData> damageRank = settle.getDamageRank().get(groupId);
                if (damageRank != null) {
                    res.getDamageRank().addAll(damageRank);
                }
                List<RankData> killRank = settle.getKillRank().get(groupId);
                if (killRank != null) {
                    res.getKillRank().addAll(killRank);
                }
                List<RankData> herRank = settle.getHeroRank().get(groupId);
                if (herRank != null) {
                    res.getHeroRank().addAll(herRank);
                }
                List<RankData> scoreRank = settle.getScoreRank().get(groupId);
                if (scoreRank != null) {
                    res.getScoreRank().addAll(scoreRank);
                }
            }
        }
        res.setMaxRound(maxRound);
        connection.send(res);
        log.info("推送结算信息：{},{}", req.getServerId(), GsonUtils.toJson(res));
    }

    @RemoteMethod
    public void stage(CountryWarStageReqMessage req, Connection connection) {
        CountryWarTime countryWarTime = countryWarTimeDao.getSingle();
        CCountryWarTime nextStage = countryWarTimeSysCache.getById(countryWarTime.getConfigIdx() + 1);
        LocalDateTime nextStageTime = nextStage == null ? LocalDateTime.of(2030, 1, 1, 0, 0) : nextStage.getStart_time();
        CountryWarStageTimeInfo timeInfo = CountryWarStageTimeInfo.of(countryWarTime.getStage(), countryWarTime.getStageStartTime(),
                nextStageTime, countryWarTime.getRound(), countryWarTime.getConfigIdx(),
                countryWarTime.getServer2Group().containsKey(req.getServerId()));
        CountryWarStageResMessage message = CountryWarStageResMessage.of(timeInfo);
        connection.send(message);
    }

    @RemoteMethod
    public CountryWarServerLogResMessage scanServerLog(CountryWarServerLogReqMessage req) {
        CountryWarGMsg.GResCountryWarServerLog.Builder builder = CountryWarGMsg.GResCountryWarServerLog.newBuilder();
        CountryWarServer server = countryWarServerDao.get(req.getServerId());
        server.getLogs().forEach(log -> {
            builder.addLogs(countryWarPbConverter.build(log));
        });
        return CountryWarServerLogResMessage.of(builder.build().toByteArray());
    }

    @RemoteMethod
    public CountryWarRoleLogResMessage CountryWarRoleLogResMessage(CountryWarRoleLogReqMessage req) {
        CountryWarGMsg.GResCountryWarRoleLog.Builder builder = CountryWarGMsg.GResCountryWarRoleLog.newBuilder();
        CountryWarRole countryWarRole = countryWarRoleDao.get(req.getRid());
        countryWarRole.getLogs().forEach(log -> {
            builder.addLogs(countryWarPbConverter.build(log));
        });
        return CountryWarRoleLogResMessage.of(builder.build().toByteArray());
    }

    @RemoteMethod
    public CountryWarRandomShopBuyResMessage randomShopBuy(CountryWarRandomShopBuyReqMessage req) {
        CountryWarTime countryWarTime = countryWarTimeDao.getSingle();

        Asserts.isTrue(countryWarTime.getStage() != CountryWarStage.CLOSE_ING.getValue(),
                ErrorCode.COUNTRY_WAR_CLOSING.getValue(),
                String.format("活动已关闭：%s", countryWarTime.getStage()));

        Integer groupId = countryWarTime.getServer2Group().get(req.getServerId());
        Asserts.isTrue(groupId != null,
                ErrorCode.COUNTRY_WAR_NOT_JOIN.getValue(),
                String.format("服务器未参与国战：%s", req.getServerId()));

        CountryWarGroup groupData = countryWarTime.getGroupData().get(groupId);
        CountryWarCity shopCity = groupData.getCity(groupData.getShopCityId());
        CountryWarServer shopServer = null;
        if (shopCity.getServerId() > 0) {
            shopServer = countryWarServerDao.get(shopCity.getServerId());
        }
        CountryWarServer buyServer = countryWarServerDao.get(req.getServerId());

        Asserts.isTrue(shopCity != null && shopCity.getServerId() > 0 && (buyServer.getFaction() & shopServer.getFaction()) > 0,
                ErrorCode.COUNTRY_WAR_DIFF_FACTION.getValue(),
                String.format("阵营不同：%s-%s", req.getServerId(), shopCity.getServerId()));

        return CountryWarRandomShopBuyResMessage.of(true);
    }

    @RemoteMethod
    public void chat(CountryWarChatMessage req) {
        CountryWarTime countryWarTime = countryWarTimeDao.getSingle();
        Integer groupId = countryWarTime.getServer2Group().get(req.getMainServerId());
        Asserts.isTrue(groupId != null,
                ErrorCode.COUNTRY_WAR_NOT_JOIN.getValue(),
                String.format("服务器未参与国战：%s", req.getServerId()));
        countryWarConnectService.push(groupId, req);
    }


    @RemoteMethod
    public void gm(CountryWarGMReqMessage req) {
        log.info("GM:{}", GsonUtils.toJson(req));
        if (req.getType() == 0) {
            CountryWarTime countryWarTime = countryWarTimeDao.getSingle();
            countryWarService.setNewStage(countryWarTimeSysCache.getById(countryWarTime.getConfigIdx() + 1));
        } else if (req.getType() == 1) {

        } else if (req.getType() == 2) {
            List<CountryWarRole> roles = countryWarRoleDao.listAll();
            CountryWarTime countryWarTime = countryWarTimeDao.getSingle();
            countryWarTime.getGroupData().values().forEach(groupData -> {
                groupData.getCityMap().values().forEach(city -> {
                    if (countryWarCitySysCache.getById(city.getId()).getType() != 1) {
                        city.getDefendRid().clear();
                        city.setServerId(0);
                        city.setBattleTime(LocalDateTime.of(1970, 1, 1, 0, 0));
                        city.setLastRewardTime(LocalDateTime.of(1970, 1, 1, 0, 0));
                    }
                });
            });
            roles.forEach(role -> {
                if (role.getDefendCity() > 0 && role.getRound() == countryWarTime.getRound()) {
                    CountryWarServer server = countryWarServerDao.get(role.getMainServerId());
                    CountryWarGroup groupData = countryWarTime.getGroupData().get(countryWarTime.getServer2Group().get(server.getServerId()));
                    CountryWarCity city = groupData.getCity(server.getBaseCamp());
                    addDefendForCity(role, city);
                }
            });
            countryWarRoleDao.update(roles);
            countryWarTimeDao.update(countryWarTime);
        } else if (req.getType() == 3) {
            CountryWarTime countryWarTime = countryWarTimeDao.getSingle();
            if (countryWarTime.getStage() != CountryWarStage.WAR.getValue()) {
                return;
            }
            countryWarTime.getGroupData().clear();
            countryWarTime.getServer2Group().clear();
            List<CountryWarRole> roles = countryWarRoleDao.listAll();
            for (CountryWarRole role : roles) {
                role.setDefendCity(0);
            }
            countryWarRoleDao.update(roles);
            warWorker.tryAnother(true);
            warWorker.pushStageChange(countryWarTime);
        } else if (req.getType() == 4) {
            List<CountryWarServer> countryWarServer = countryWarServerDao.listAll();
            countryWarServer.forEach(server -> server.setFaction(server.getFaction() & (CountryWarFaction.FACTION_ALL.getValue() - 1)));
            CountryWarTime countryWarTime = countryWarTimeDao.getSingle();
            countryWarTime.getGroupData().values().forEach(group -> group.setStrongestId(0));
            countryWarTimeDao.update(countryWarTime);
            countryWarServerDao.update(countryWarServer);
        }
    }


    public CountryWarAttackResMessage unsafeAttack(CountryWarGroup groupData, CountryWarRole attack, CountryWarAttackReqMessage req) {
//        CountryWarTime countryWarTime = countryWarTimeDao.getSingle();
        CountryWarCity city = groupData.getCity(req.getCityId());
        CCountryWarCity cityConfig = countryWarCitySysCache.getById(req.getCityId());
        int oldServerId = city.getServerId();
        boolean battleWin = true;
        Set<CountryWarCity> updateToClient = new HashSet<>();
        BattleGMsg.BattleReport report = null;

        CCountryWarCityRelation relationConfig = countryWarCityRelationSysCache.getById(city.getId());

        CountryWarServer attackServer = countryWarServerDao.get(req.getServerId());
        CountryWarCity old = groupData.getCity(attack.getDefendCity());
        Asserts.isTrue(old != null && relationConfig.getConnect_city_id().contains(old.getId()),
                ErrorCode.COUNTRY_WAR_CAN_NOT_CONNECTION.getValue(),
                String.format("没有驻扎在相邻城市：%s", req.getCityId()));

        CountryWarRole defend = null;
        boolean triggerExtraSkill = false;

        if (oldServerId > 0) {
            CountryWarServer defendServer = countryWarServerDao.get(oldServerId);
            Asserts.isTrue((attackServer.getFaction() & defendServer.getFaction()) == 0,
                    ErrorCode.COUNTRY_WAR_SAME_FACTION.getValue(),
                    String.format("相同阵营不能攻击：%s", city.getServerId()));

            if (city.getDefendRid().size() > 0) {
                Collection<Long> defendRids = city.getDefendRid().keySet();
                Long defendRid = defendRids.stream().findAny().orElse(null);
                defend = countryWarRoleDao.get(defendRid);
                BattlerDo defendDo = createDefendDo(city, cityConfig, defend);

                BattlerVo attackVO = GsonUtils.fromJson(attack.getBattleVo(), BattlerVo.class);
                BattlerDo attackDo = battleTemplate.queryBattler(attackVO, attack.getCountryWarRoleInfo().getName(),
                        Faction.ATTACKER, UnitType.HERO);

                //判定342属性秒杀
                long attrValue = attackDo.getHeros().stream().mapToLong(heroDo -> heroDo.getAttribute(AttributeType.CAPTURE_KING)).sum();
                long damageValue = 0;
                if (triggerExtraSkill = RandomUtil.rand(1, 10000) <= attrValue) {
                    battleWin = true;//触发必杀
                    damageValue = attackDo.getHeros().stream().mapToLong(heroDo -> heroDo.getAttribute(AttributeType.MAX_HP)).sum();
                } else {
                    BattleCommand battleCommand = BattleCommand.createOf(BattleType.COUNTRY_WAR, attackDo, defendDo);
                    commandBus.invoke(battleCommand);
                    BattleResult battleResult = battleCommand.getResult();
                    report = battleResult.getReport();
                    battleWin = battleResult.isWin();
                    damageValue = battleResult.getTotalDamage(Faction.ATTACKER);
                }

                if (battleWin) {
                    city.removeDefend(defend.getRid());
                    addDefendForCity(defend, groupData.getCity(defendServer.getBaseCamp()));
                } else {
                    int oldValue = city.getDefendCount().getOrDefault(defend.getRid(), 0);
                    if (oldValue == DEFEND_MAX_COUNT - 1) {
                        city.removeDefend(defend.getRid());
                        addDefendForCity(defend, groupData.getCity(defendServer.getBaseCamp()));
                        eventBus.post(CountryWarDefendMaxCountEvent.of(defend));
                        updateToClient.add(city);
                    } else {
                        city.getDefendCount().put(defend.getRid(), oldValue + 1);
                    }
                    eventBus.post(CountryWarDefendSuccessEvent.of(defend, attack, city.getId()));
                }

                if (battleWin) {
                    attack.setKillCount(attack.getKillCount() + 1);
                    attack.setKillCountRankTime(LocalDateTime.now());
                }
                attack.setDamage(attack.getDamage() + damageValue);
                attack.setDamageRankTime(LocalDateTime.now());
                countryWarRoleDao.update(attack);

                eventBus.post(CountryWarAttackCityEvent.of(groupData.getGroupId(), req.getAttackId(), battleWin));
            }
        }

        boolean occupy = city.getDefendRid().size() == 0 && battleWin;
        if (occupy) {
            updateToClient.add(city);
            boolean fistOccupy = false;
            old.removeDefend(attack.getRid());
            updateToClient.add(old);

            if (city.getServerId() == 0) {
                fistOccupy = true;
                attackServer.setScore(cityConfig.getFirst_score() + attackServer.getScore());
                countryWarServerDao.update(attackServer);
                eventBus.post(CountryWarServerAddScoreEvent.of(attackServer.getServerId(), groupData.getGroupId()));
            }

            city.setServerId(req.getServerId());
            city.setLastRewardTime(LocalDateTime.now());
            city.setOccupyTime(LocalDateTime.now());
            if (groupData.getEvent().getCityId() == city.getId()) {
                groupData.getEvent().setRewardTime(LocalDateTime.now());
            }

            addDefendForCity(attack, city);

            attack.setOccupyCity(attack.getOccupyCity() + 1);
            attack.setDefeatCityRankTime(LocalDateTime.now());
            //重组阵营
            tryResetFaction(groupData, oldServerId, city.getServerId());

            updateToClient.addAll(resetAllCityIsolate(groupData));

            countryWarRoleDao.update(attack);
            eventBus.post(CountryWarCityChangeServerEvent.of(groupData.getGroupId(), req.getCityId(), attack, defend, fistOccupy));
        }
        city.setBattleTime(LocalDateTime.now());
        city.setLastRewardTime(LocalDateTime.now());
        CountryWarCityEvent event = groupData.getEvent();
        if (event.getCityId() == city.getId()) {
            event.setRewardTime(LocalDateTime.now());
        }
        countryWarTimeDao.updateSingle();

        CountryWarAttackResMessage message = new CountryWarAttackResMessage();

        CountryWarGMsg.GResCountryWarAttackCity.Builder builder = CountryWarGMsg.GResCountryWarAttackCity.newBuilder();
        if (report != null) {
            builder.setReport(report);
        }
        updateToClient.forEach(update -> {
            builder.addCities(countryWarPbConverter.build(update, groupData));
        });
        List<Integer> list = groupData.getServerIds();
        for (Integer serverTemp : list) {
            builder.addFaction(countryWarPbConverter.build(countryWarServerDao.get(serverTemp)));
        }
        builder.setCurrId(attack.getDefendCity());
        builder.setIdx(req.getCityId());
        message.setData(builder.build().toByteArray());
        message.setOccupy(occupy);
        message.setTriggerExtraSkill(triggerExtraSkill);

        eventBus.post(CountryWarBroadcastEvent.of(groupData.getGroupId(), updateToClient.stream().mapToInt(CountryWarCity::getId)
                .boxed().collect(Collectors.toList())));

        return message;
    }

    /***
     * 创建DefendDO
     * @param city
     * @param cityConfig
     * @param defend
     * @return
     */
    private BattlerDo createDefendDo(CountryWarCity city, CCountryWarCity cityConfig, CountryWarRole defend) {
        BattlerDo battleDo = battleTemplate.queryBattler(defend.getBattlerVoObj(), defend.getCountryWarRoleInfo().getName(),
                Faction.DEFENDER, UnitType.HERO);
        if (!city.isIsolate()) {
            cityConfig.getAdd_attr().forEach(attributeKind -> {
                battleDo.getHeros().forEach(heroDo -> heroDo.getAttributeInfo().addAttributeKind(attributeKind));
            });
        } else {
            cityConfig.getReduce_attr().forEach(attributeKind -> {
                battleDo.getHeros().forEach(heroDo -> heroDo.getAttributeInfo().addAttributeKind(attributeKind));
            });
        }
        return battleDo;
    }


    public void addDefendForCity(CountryWarRole role, CountryWarCity city) {
        CCountryWarCity config = countryWarCitySysCache.getOrThrow(city.getId());
        role.setDefendCity(city.getId());
        for (int i = 0; i < config.getAccommodate_count(); i++) {
            if (!city.getDefendRid().containsValue(i)) {
                city.getDefendRid().put(role.getRid(), i);
                break;
            }
        }

    }

    /***
     * 尝试重组阵营
     * @param groupData
     * @param reduceNumServer
     *          城池数量减少的服务器
     * @param addNumServer
     *          城池数量增加的服务器
     */
    private boolean tryResetFaction(CountryWarGroup groupData, int reduceNumServer, int addNumServer) {

        //最强服务器增加占领城池，不重算联盟
        if (groupData.getStrongestId() == addNumServer) {
            return false;
        }

        Map<Integer, CountryWarCity> allCities = groupData.getCityMap();
        Map<Integer, List<CountryWarCity>> serverCities = allCities.values().stream().collect(Collectors.groupingBy(CountryWarCity::getServerId));

        boolean result = false;
        int addOccupyCount = serverCities.getOrDefault(addNumServer, Collections.emptyList()).size();
        int strongestOccupyCount = 0;
        if (groupData.getStrongestId() > 0) {
            strongestOccupyCount = serverCities.getOrDefault(groupData.getStrongestId(), Collections.emptyList()).size();
        }

        if (groupData.getStrongestId() > 0 && (addOccupyCount > strongestOccupyCount || strongestOccupyCount <= RESET_CAMP)) {
            dissolveUnion(groupData);
        }

        if (addOccupyCount > RESET_CAMP && addOccupyCount > strongestOccupyCount) {
            unionServer(groupData, addNumServer);
            result = true;
        }

        return result;
    }

    private void unionServer(CountryWarGroup groupData, int strongestServer) {
        groupData.getServerIds().forEach(serverId -> {
            if (serverId != strongestServer) {
                CountryWarServer serverTemp = countryWarServerDao.get(serverId);
                serverTemp.setFaction(serverTemp.getFaction() | CountryWarFaction.FACTION_ALL.getValue());
                countryWarServerDao.update(serverTemp);
                log.info("新的阵营：{}-{}", serverTemp.getServerId(), serverTemp.getFaction());
            }
        });
        groupData.setStrongestId(strongestServer);

        log.info("联盟成立，最强服务器:{}", groupData.getStrongestId());
        eventBus.post(CountryWarUnionEvent.of(groupData.getServerIds(), false, strongestServer));
    }

    private void dissolveUnion(CountryWarGroup groupData) {
        List<Integer> allServerIds = groupData.getServerIds();
        allServerIds.forEach(serverId -> {
            CountryWarServer serverTemp = countryWarServerDao.get(serverId);
            if ((serverTemp.getFaction() & CountryWarFaction.FACTION_ALL.getValue()) > 0) {
                serverTemp.setFaction(serverTemp.getFaction() & (CountryWarFaction.FACTION_ALL.getValue() - 1));
                log.info("新的阵营：{}-{}", serverTemp.getServerId(), serverTemp.getFaction());
                countryWarServerDao.update(serverTemp);
            }
        });
        //解散阵营的时候，将玩家迁回大本营
        groupData.getCityMap().values().forEach(city -> {
            Set<CountryWarRole> returnCamp = new HashSet<>();
            if (groupData.getStrongestId() != city.getServerId()) {
                city.getDefendRid().keySet().forEach(rid -> {
                    CountryWarRole role = countryWarRoleDao.get(rid);
                    if (role.getMainServerId() != city.getServerId()) {
                        returnCamp.add(role);
                    }
                });
            }
            returnCamp.forEach(role -> {
                city.getDefendRid().remove(role.getRid());
                int campCityId = countryWarServerDao.get(role.getMainServerId()).getBaseCamp();
                addDefendForCity(role, groupData.getCity(campCityId));
            });


        });

        log.info("联盟解散，旧的最强服务器:{}", groupData.getStrongestId());
        groupData.setStrongestId(0);
        eventBus.post(CountryWarUnionEvent.of(allServerIds, true, groupData.getStrongestId()));
    }

    private Set<CountryWarCity> resetAllCityIsolate(CountryWarGroup groupData) {
        Set<CountryWarCity> update = new HashSet<>();
        Map<Integer, CountryWarCity> allCities = groupData.getCityMap();

        List<CountryWarServer> servers = new ArrayList<>();
        groupData.getServerIds().forEach(serverId -> servers.add(countryWarServerDao.get(serverId)));

        Set<Integer> connectIds = new HashSet<>(allCities.size());
        servers.forEach(server -> {
            List<Integer> checkSet = new ArrayList<>();
            List<Integer> hadCheckSet = new ArrayList<>();
            connectIds.add(server.getBaseCamp());
            checkSet.add(server.getBaseCamp());
            while (!checkSet.isEmpty()) {
                Integer sourceCityId = checkSet.remove(0);
                hadCheckSet.add(sourceCityId);
                List<Integer> ids = countryWarCityRelationSysCache.getOrThrow(sourceCityId).getConnect_city_id();
                ids.forEach(id -> {
                    CountryWarCity relationCity = groupData.getCity(id);
                    if (relationCity.getServerId() > 0) {
                        CountryWarServer relationServer = countryWarServerDao.get(relationCity.getServerId());
                        if ((server.getFaction() & relationServer.getFaction()) <= 0) {
                            return;
                        }
                    }
                    connectIds.add(id);
                    //将id添加到原本所属的服务器联通集合里面
                    if (!hadCheckSet.contains(id)) {
                        checkSet.add(id);
                    }
                });
            }
        });


        allCities.values().forEach(city -> {
            if (city.getServerId() > 0) {
                city.setIsolate(!connectIds.contains(city.getId()));
            }
        });
        return update;
    }

//    private boolean calcIsolate(CountryWarGroup groupData, CountryWarCity city) {
//        boolean isolate = true;
//        CCountryWarCityRelation relationConfig = countryWarCityRelationSysCache.getById(city.getId());
//        CountryWarServer cityServer = countryWarServerDao.get(city.getServerId());
//        for (Integer cityId : relationConfig.getConnect_city_id()) {
//            int serverId = groupData.getCity(cityId).getServerId();
//            if ()
//                releationServer countryWarServerDao.get(serverId);
//            if (serverId == 0 || (countryWarServerDao.get(serverId).getFaction() &
//                    cityServer.getFaction()) > 0) {
//                isolate = false;
//                continue;
//            }
//        }
//        return isolate;
//    }


}
