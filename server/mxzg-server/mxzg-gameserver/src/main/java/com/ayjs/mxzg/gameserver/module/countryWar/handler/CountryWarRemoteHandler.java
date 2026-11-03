package com.ayjs.mxzg.gameserver.module.countryWar.handler;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.util.gson.GsonUtils;
import com.ayjs.mxzg.common.util.time.LocalDateTimeUtil;
import com.ayjs.mxzg.config.excel.cache.MailSysCache;
import com.ayjs.mxzg.config.excel.cache.countryWar.CountryWarConst;
import com.ayjs.mxzg.config.excel.cache.countryWar.CountryWarDamageRankRewardSysCache;
import com.ayjs.mxzg.config.excel.cache.countryWar.CountryWarHeroRankRewardSysCache;
import com.ayjs.mxzg.config.excel.cache.countryWar.CountryWarKillRankRewardSysCache;
import com.ayjs.mxzg.config.excel.cache.countryWar.CountryWarScoreRankRewardSysCache;
import com.ayjs.mxzg.config.excel.entity.CMail;
import com.ayjs.mxzg.config.excel.entity.countrywar.CCountryWarDamageRankReward;
import com.ayjs.mxzg.config.excel.entity.countrywar.CCountryWarHeroRankReward;
import com.ayjs.mxzg.config.excel.entity.countrywar.CCountryWarKillRankReward;
import com.ayjs.mxzg.config.excel.entity.countrywar.CCountryWarScoreRankReward;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.chat.constant.ChatType;
import com.ayjs.mxzg.gameserver.module.chat.service.ChatService;
import com.ayjs.mxzg.gameserver.module.countryWar.domain.CountryWar;
import com.ayjs.mxzg.gameserver.module.countryWar.domain.CountryWarSystem;
import com.ayjs.mxzg.gameserver.module.countryWar.event.CountryWarDefendEvent;
import com.ayjs.mxzg.gameserver.module.countryWar.service.CountryWarService;
import com.ayjs.mxzg.gameserver.module.mail.constant.MailScene;
import com.ayjs.mxzg.gameserver.module.mail.domain.Mail;
import com.ayjs.mxzg.gameserver.module.mail.service.MailService;
import com.ayjs.mxzg.gameserver.module.mail.service.MailSomeService;
import com.ayjs.mxzg.gameserver.module.mail.struct.MailParams;
import com.ayjs.mxzg.gameserver.module.marquee.service.MarqueeService;
import com.ayjs.mxzg.gameserver.module.marquee.struct.ObjParam;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.message.module.countryWar.CountryWarCityBroadcastMessage;
import com.ayjs.mxzg.message.module.countryWar.CountryWarDefendResMessage;
import com.ayjs.mxzg.message.module.countryWar.CountryWarMarqueeResMessage;
import com.ayjs.mxzg.message.module.countryWar.CountryWarMatchFailReqMessage;
import com.ayjs.mxzg.message.module.countryWar.CountryWarRewardRecordResMessage;
import com.ayjs.mxzg.message.module.countryWar.CountryWarSettleRecordResMessage;
import com.ayjs.mxzg.message.module.countryWar.CountryWarSmallCityBroadcastMessage;
import com.ayjs.mxzg.message.module.countryWar.CountryWarStageResMessage;
import com.ayjs.mxzg.message.module.floatingIslands.struct.RankData;
import com.ayjs.mxzg.protocol.CountryWarGMsg;
import com.ayjs.rpc.annotation.Remote;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.dispatcher.MessageHandler;
import com.google.protobuf.InvalidProtocolBufferException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Author: CWJ
 * @Date: 2021/4/19
 **/
@Remote
@Observer
@Slf4j
public class CountryWarRemoteHandler implements MessageHandler {

    @Autowired
    private CountryWarScoreRankRewardSysCache countryWarScoreRankRewardSysCache;
    @Autowired
    private CountryWarKillRankRewardSysCache countryWarKillRankRewardSysCache;
    @Autowired
    private CountryWarHeroRankRewardSysCache countryWarHeroRankRewardSysCache;
    @Autowired
    private CountryWarDamageRankRewardSysCache countryWarDamageRankRewardSysCache;
    @Autowired
    private RoleService roleService;
    @Autowired
    private MailService mailService;
    @Autowired
    private ServerConfig serverConfig;
    @Autowired
    private CountryWarService countryWarService;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private MarqueeService marqueeService;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private CountryWarConst countryWarConst;
    @Autowired
    private ChatService chatService;
    @Autowired
    private MailSomeService mailSomeService;
    @Autowired
    private MailSysCache mailSysCache;

    @RemoteMethod
    public void settleRecord(CountryWarSettleRecordResMessage message) {
        List<Mail> mails = new ArrayList<>();
        CountryWarSystem countryWarSystem = countryWarService.getCountryWarSystem();
        if (countryWarSystem.getRewardRound() == message.getMaxRound()) {
            log.info("当前轮次已在这一轮，不重复结算");
            return;
        }
        countryWarSystem.setRewardRound(message.getMaxRound());
        countryWarService.update(countryWarSystem);

        drawScoreRankReward(mails, message.getScoreRank());

        drawHeroRank(mails, message.getHeroRank());

        drawKillRank(mails, message.getKillRank());

        drawDamageRank(mails, message.getDamageRank());

        mailService.insertMails(mails);
    }

    @RemoteMethod
    public void defend(CountryWarDefendResMessage message) {
        eventBus.post(CountryWarDefendEvent.of(message.getDefendId(), message.isDefendSuccess()));
    }

    private void drawDamageRank(List<Mail> mails, List<RankData> rankDataList) {
        for (int i = 0; i < rankDataList.size(); i++) {
            RankData rankData = rankDataList.get(i);
            if (roleService.isRole(rankData.getRankId())) {
                CCountryWarDamageRankReward config = countryWarDamageRankRewardSysCache.getByRank(i + 1);
                Mail mail = mailService.newMailNoTitle(rankData.getRankId(), MailScene.COUNTRY_WAR_DAMAGE,
                        MailParams.build(i + 1), config.getReward(), GameEvent.COUNTRY_WAR_RANK);
                mails.add(mail);
            }
        }
    }

    private void drawKillRank(List<Mail> mails, List<RankData> rankDataList) {
        for (int i = 0; i < rankDataList.size(); i++) {
            RankData rankData = rankDataList.get(i);
            if (roleService.isRole(rankData.getRankId())) {
                CCountryWarKillRankReward config = countryWarKillRankRewardSysCache.getByRank(i + 1);
                Mail mail = mailService.newMailNoTitle(rankData.getRankId(), MailScene.COUNTRY_WAR_KILL, MailParams.build(i + 1),
                        config.getReward(), GameEvent.COUNTRY_WAR_RANK);
                mails.add(mail);
            }
        }
    }

    private void drawHeroRank(List<Mail> mails, List<RankData> rankDataList) {
        for (int i = 0; i < rankDataList.size(); i++) {
            RankData rankData = rankDataList.get(i);
            if (roleService.isRole(rankData.getRankId())) {
                CCountryWarHeroRankReward config = countryWarHeroRankRewardSysCache.getByRank(i + 1);
                Mail mail = mailService.newMailNoTitle(rankData.getRankId(), MailScene.COUNTRY_WAR_HERO, MailParams.build(i + 1),
                        config.getReward(), GameEvent.COUNTRY_WAR_RANK);
                mails.add(mail);
            }
        }
    }

    private void drawScoreRankReward(List<Mail> mails, List<RankData> rankDataList) {
        for (int i = 0; i < rankDataList.size(); i++) {
            RankData rankData = rankDataList.get(i);
            if (serverConfig.getServerId() == rankData.getRankId()) {
                List<CountryWar> countryWars = countryWarService.list();
                CCountryWarScoreRankReward config = countryWarScoreRankRewardSysCache.getByRank(i + 1);
                int finalI = i;
                countryWars.forEach(countryWar -> {
                    Mail mail = mailService.newMailNoTitle(countryWar.getRid(), MailScene.COUNTRY_WAR_SCORE,
                            MailParams.build(finalI + 1), config.getReward(), GameEvent.COUNTRY_WAR_RANK);
                    mails.add(mail);
                });
                continue;
            }
        }
    }

    @RemoteMethod
    public void updateStage(CountryWarStageResMessage res) {
        countryWarService.setCountryWarStageTimeInfo(res.getCountryWarStageTimeInfo());
        if (log.isDebugEnabled()) {
            chatService.send(ChatType.WORLD, "国战状态改变:" + res.getCountryWarStageTimeInfo().getStage()
                            + ",是否参与国战：" + res.getCountryWarStageTimeInfo().isJoin() + ",时间配置：" + res.getCountryWarStageTimeInfo().getIdx(),
                    0, 0);
        }
        log.info("国战状态改变：{}", GsonUtils.toJson(res.getCountryWarStageTimeInfo()));
    }

    @RemoteMethod
    public void warReward(CountryWarRewardRecordResMessage res) {
        CountryWarSystem countryWarSystem = countryWarService.getCountryWarSystem();
        countryWarSystem.getCityRewardCount().putAll(res.getCityReward());
        countryWarSystem.getEventRewardCount().putAll(res.getEventReward());
        countryWarService.update(countryWarSystem);
    }

    @RemoteMethod
    public void marquee(CountryWarMarqueeResMessage res) {
        marqueeService.addMarquee(res.getIdx(), 0, ObjParam.build(res.getParam().toArray()));
    }

    @RemoteMethod
    public void broadcastCities(CountryWarCityBroadcastMessage res) {
        if (res == null || res.getData() == null) {
            log.error("跨服广播了一条空协议:{}", GsonUtils.toJson(res));
            return;
        }
        CountryWar countryWar = countryWarService.get(res.getRid());
        CountryWarSystem countryWarSystem = countryWarService.getCountryWarSystem();
        try {
            CountryWarGMsg.GResCountryWarCity.Builder data = CountryWarGMsg.GResCountryWarCity.parseFrom(res.getData()).toBuilder();
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
            boolean hadReward = mapSub(countryWarSystem.getCityRewardCount(), countryWar.getCityRewardCount()).size() > 0 ||
                    mapSub(countryWarSystem.getEventRewardCount(), countryWar.getEventRewardCount()).size() > 0;
            data.setHadReward(hadReward);
            data.setMoveItemNum(countryWar.getMoveItemNum());
            data.setAttackItemNum(countryWar.getAttackItemNum());
            contextManager.write(res.getRid(), CmdCode._76351, data.build());
        } catch (InvalidProtocolBufferException e) {
            e.printStackTrace();
        }
    }

    @RemoteMethod
    public void broadcastSmallCities(CountryWarSmallCityBroadcastMessage res) {
        if (res == null || res.getData() == null || res.getData().size() == 0) {
            log.error("跨服广播了一条空协议:{}", GsonUtils.toJson(res));
            return;
        }
        res.getData().forEach(data -> {
            try {
                CountryWarGMsg.GResCountryWarSmallCity builder = CountryWarGMsg.GResCountryWarSmallCity.parseFrom(data);
                contextManager.write(res.getRid(), CmdCode._76352, builder);
            } catch (InvalidProtocolBufferException e) {
                e.printStackTrace();
            }
        });

    }

    @RemoteMethod
    public void matchFail(CountryWarMatchFailReqMessage req) {
        CMail cmail = mailSysCache.getOrThrow(MailScene.COUNTRY_WAR_MATCH_FAIL.getId());
        String title = "";
        String context = "";
        if (cmail != null) {
            title = mailService.formatParamStr(cmail.getTitle_lang(), cmail.getTitle_param(), null);
            context = mailService.formatParamStr(cmail.getContent_lang(), cmail.getContent_param(), null);
        }
        mailSomeService.saveNewMail(1, title, context, null, GsonUtils.toJson(countryWarConst.getMatchFailReward()));
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


}
