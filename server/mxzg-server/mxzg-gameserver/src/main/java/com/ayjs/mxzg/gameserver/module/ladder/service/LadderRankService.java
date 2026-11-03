package com.ayjs.mxzg.gameserver.module.ladder.service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.config.excel.cache.LadderRankRewardSysCache;
import com.ayjs.mxzg.config.excel.entity.CLadderRankReward;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.module.clan.domain.Clan;
import com.ayjs.mxzg.gameserver.module.clan.service.ClanService;
import com.ayjs.mxzg.gameserver.module.ladder.event.LadderEndEvent;
import com.ayjs.mxzg.gameserver.module.mail.constant.MailScene;
import com.ayjs.mxzg.gameserver.module.mail.domain.Mail;
import com.ayjs.mxzg.gameserver.module.mail.service.MailService;
import com.ayjs.mxzg.gameserver.module.mail.struct.MailParams;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.server.struct.LadderData;
import com.ayjs.mxzg.gameserver.remote.cross.event.CrossConnectedEvent;
import com.ayjs.mxzg.message.module.ladder.message.CrossLadderRank;
import com.ayjs.mxzg.message.module.ladder.message.CrossLadderRankReqMessage;
import com.ayjs.mxzg.message.module.ladder.message.CrossLadderRankResMessage;
import com.ayjs.mxzg.protocol.PvpGMsg;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.dispatcher.MessageDispatcher;
import com.ayjs.rpc.dispatcher.MessageHandler;
import com.google.common.collect.ImmutableList;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

/**
 * @Author: CWJ
 * @Date: 2020/1/2
 **/
@Service
@Slf4j
@Observer
public class LadderRankService implements MessageHandler {

    private List<CrossLadderRank> list = new ArrayList<>(1000);

    private ConcurrentMap<Long, Integer> roleRankMap = new ConcurrentHashMap<>();

    @Autowired
    private RoleService roleService;
    @Autowired
    private ServerConfig serverConfig;
    @Autowired
    private ClanService clanService;
    @Autowired
    private MailService mailService;
    @Autowired
    private LadderRankRewardSysCache ladderRankRewardSysCache;
    @Autowired
    private LadderService ladderService;
    @Autowired
    private MessageDispatcher messageDispatcher;
    @Autowired
    private EventBus eventBus;


    @RemoteMethod
    public void replaceRank(CrossLadderRankResMessage message) {
        try {
            if (list.size() == 0) {
                List<CrossLadderRank> list_ = new ArrayList<>();
                for (int i = 0; i < 1000; i++) {
                    list_.add(new CrossLadderRank());
                }
                list = list_;
            }
            Map<Integer, CrossLadderRank> rankMap = message.getRankMap() == null ? new HashMap<>() : message.getRankMap();
            if (message.isReplaceAll()) {
                List<CrossLadderRank> list_ = new ArrayList<>();
                for (int i = 0; i < 1000; i++) {
                    list_.add(new CrossLadderRank());
                }
                ConcurrentMap<Long, Integer> roleRankMap_ = new ConcurrentHashMap<>();
                rankMap.forEach((key, value) -> {
                    if (key != 0) {
                        value.setRank(key);
                        list_.set(key - 1, value);
                        roleRankMap_.put(value.getRankId(), key);
                    }
                });
                list = list_;
                roleRankMap = roleRankMap_;

                LadderData ladderData = ladderService.getLadderData();
                ladderData.setStartTime(message.getCrossLadderDateTime().getTheWeekStartDateTime());
                ladderData.setEndTime(message.getCrossLadderDateTime().getTheWeekEndDateTime());
                ladderData.setLastEndDateTime(message.getCrossLadderDateTime().getLastEndDateTime());
                ladderService.updateLadderData(ladderData);

                ladderComputer();

            } else {
                rankMap.forEach((key, value) -> {
                    if (key != 0) {
                        CrossLadderRank old = list.set(key - 1, value);
                        roleRankMap.put(value.getRankId(), key);
                        if (old.getRank() == roleRankMap.getOrDefault(old.getRankId(), 0)) {//排名已经改变，不能移除
                            roleRankMap.remove(old.getRankId());
                        }
                        value.setRank(key);
                    }
                });
            }
        } catch (Exception e) {
            log.error("重载天梯榜异常", e);
        }
    }

    public List<CrossLadderRank> getAllList() {
        return ImmutableList.copyOf(list);
    }

    /**
     * 获取某个榜的第一名
     *
     * @return
     */
    @Subscribe(async = Subscribe.AsyncType.Async)
    public void getCrossRank(CrossConnectedEvent event) {
        messageDispatcher.dispatch(CrossLadderRankReqMessage.of(serverConfig.getServerId()), v -> {
            replaceRank((CrossLadderRankResMessage) v);
        });
    }


    public List<PvpGMsg.PSRankPlayerData> showPage(int page) {
        int from = (page - 1) * 50 + 1;
        int to = page * 50 + 1;
        List<CrossLadderRank> ranks = list.subList(from, to);

        List<PvpGMsg.PSRankPlayerData> result = new ArrayList<>();
        ranks.forEach(rank -> {
            result.add(builder(rank));
        });
        return result;
    }

    public int getRank(long rid) {
        return roleRankMap.getOrDefault(rid, -1);
    }

    public PvpGMsg.PSRankPlayerData builder(CrossLadderRank rankData) {
        PvpGMsg.PSRankPlayerData.Builder builder = PvpGMsg.PSRankPlayerData.newBuilder();
        builder.setLevel(rankData.getLevel());
        if (rankData.getRoleName() != null) {
            builder.setName(rankData.getRoleName());
        }
        builder.setPlayerId(rankData.getRankId());
        builder.setRank(rankData.getRank());
//        builder.setScore((int) rank.getRankValue());
        builder.setCombatNum((int) rankData.getFighting());
        builder.setHeadId(rankData.getHeadId());
        builder.setBorderId(rankData.getBorderId());
        builder.setServerId(rankData.getServerId());
        if (rankData.getClanName() != null) {
            builder.setClanName(rankData.getClanName());
        }
        return builder.build();
    }

    public PvpGMsg.PSRankPlayerData self(long rid) {

        Integer rank = roleRankMap.get(rid);
        if (rank == null) {

            PvpGMsg.PSRankPlayerData.Builder builder = PvpGMsg.PSRankPlayerData.newBuilder();
            Role role = roleService.getOrThrow(rid);
            builder.setLevel(role.getLevel());
            builder.setName(role.getNick());
            builder.setPlayerId(rid);
            builder.setRank(-1);
//        builder.setScore((int) rank.getRankValue());
            builder.setCombatNum((int) role.getFighting());
            builder.setHeadId(role.getHeadId());
            builder.setBorderId(role.getBorderId());
            builder.setServerId(serverConfig.getServerId());

            if (role.getClanId() > 0) {
                Clan clan = clanService.getOrThrow(role.getClanId());
                builder.setClanName(clan.getClanName());
            }
            return builder.build();
        } else {
            return builder(list.get(rank - 1));
        }
    }

    public void ladderComputer() {
        LadderData ladderData = ladderService.getLadderData();
        if (ladderData.getLastEndDateTime() != 0 && ladderData.getLastEndDateTime() != ladderData.getRankMailTime()) {
            List<Mail> mails = new ArrayList<>();
            log.debug("排名邮件发放{}", LocalDateTime.now());
            ladderData.setRankMailTime(ladderData.getLastEndDateTime());
            ladderService.updateLadderData(ladderData);

            ImmutableList<CrossLadderRank> crossLadderRanks = ImmutableList.copyOf(list);

            crossLadderRanks.forEach(crossLadderRank -> {
                if (crossLadderRank.isReallyPlayer() && serverConfig.matchServerId(crossLadderRank.getServerId())) {
                    CLadderRankReward config = ladderRankRewardSysCache.getConfigByRank(crossLadderRank.getRank());
                    if (config != null) {
                        Mail mail = mailService.newMailNoTitle(crossLadderRank.getRankId(), MailScene.LADDER_RANK,
                                MailParams.build(crossLadderRank.getRank()), config.getRank_reward(), GameEvent.LADDER_RANK);
                        mails.add(mail);
                    }
                }
            });

            mailService.insertMails(mails);
            //天梯结算事件
            eventBus.post(LadderEndEvent.of(crossLadderRanks));
        }
    }


}
