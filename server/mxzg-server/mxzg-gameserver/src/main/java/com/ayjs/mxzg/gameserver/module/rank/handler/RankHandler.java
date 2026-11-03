/**
 *
 */
package com.ayjs.mxzg.gameserver.module.rank.handler;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.JsonUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ItemType;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.clan.service.ClanService;
import com.ayjs.mxzg.gameserver.module.rank.constant.RankType;
import com.ayjs.mxzg.gameserver.module.rank.domain.BeWorshipData;
import com.ayjs.mxzg.gameserver.module.rank.domain.Rank;
import com.ayjs.mxzg.gameserver.module.rank.domain.RankWorship;
import com.ayjs.mxzg.gameserver.module.rank.service.*;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.event.LoginEvent;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.message.module.rank.ReqCrossRankWorshipMessage;
import com.ayjs.mxzg.message.module.rank.ResCrossRankWorshipMessage;
import com.ayjs.mxzg.protocol.PvpGMsg;
import com.ayjs.mxzg.protocol.RankGMsg;
import com.ayjs.mxzg.protocol.RankGMsg.*;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.dispatcher.MessageDispatcher;
import com.ayjs.rpc.dispatcher.MessageHandler;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.List;

/**
 * @author YY
 *
 */
@Slf4j
@Controller
@Observer
public class RankHandler extends ProtocolHandler implements MessageHandler {

    @Autowired
    RankServiceProxy rankServiceProxy;
    @Autowired
    RankWorshipService rankWorshipService;
    @Autowired
    ContextManager contextManager;
    @Autowired
    SystemSysCache systemSysCache;
    @Autowired
    ThingService thingService;
    @Autowired
    RoleService roleService;
    @Autowired
    ClanService clanService;
    @Autowired
    private MessageDispatcher messageDispatcher;
    @Autowired
    private ServerConfig serverConfig;

    /**
     * 公会排行榜
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._11001)
    public void clanRankList(PlayerContext playerContext, RankGMsg.GReqClanRank msg) {
        Role role = roleService.getOrThrow(playerContext.getId());

        RankGMsg.GResClanRank.Builder builder = RankGMsg.GResClanRank.newBuilder();

        AbstractClanRankService rankService = rankServiceProxy.getClanRank(RankType.CLAN);
        builder.setPsClanRankData(rankService.selfRank(role.getClanId()));
        builder.addAllList(rankService.showRanks(50));
        playerContext.write(CmdCode._11001, builder.build());
    }

    @CMD(id = CmdCode._11003)
    public void towerRankList(PlayerContext playerContext, GReqTowerRank msg) {
        GResTowerRank.Builder builder = GResTowerRank.newBuilder();
        AbstractPlayerRankService rankService = rankServiceProxy.getPlayerRank(RankType.TOWER);
        builder.setSelfData(rankService.selfRank(playerContext.getId()));
        List<PvpGMsg.PSRankPlayerData> psRankPlayerData = rankService.showRanks(50);

        builder.addAllList(psRankPlayerData);
        playerContext.write(CmdCode._11003, builder.build());
    }


    @CMD(id = CmdCode._11004)
    public void pvpRankList(PlayerContext playerContext, GReqPvpRankList msg) {
        GResPvpRankList.Builder builder = GResPvpRankList.newBuilder();
        AbstractPlayerRankService rankService = rankServiceProxy.getPlayerRank(RankType.ARENA);
        builder.setSelfData(rankService.selfRank(playerContext.getId()));
        builder.addAllList(rankService.showRanks(50));
        playerContext.write(CmdCode._11004, builder.build());
    }

    @CMD(id = CmdCode._11005)
    public void chapterRankList(PlayerContext playerContext, RankGMsg.GReqRankChapterList msg) {
        GResPvpRankList.Builder builder = GResPvpRankList.newBuilder();
        AbstractPlayerRankService rankService = rankServiceProxy.getPlayerRank(RankType.ROLE_MISSION);
        builder.setSelfData(rankService.selfRank(playerContext.getId()));
        builder.addAllList(rankService.showRanks(50));
        playerContext.write(CmdCode._11005, builder.build());
    }

    @CMD(id = CmdCode._11006)
    public void fightingRankList(PlayerContext playerContext, GReqFightingRankList msg) {
        GResFightingRankList.Builder builder = GResFightingRankList.newBuilder();
        AbstractPlayerRankService rankService = rankServiceProxy.getPlayerRank(RankType.FIGTH_ING);
        builder.setSelfData(rankService.selfRank(playerContext.getId()));
        builder.addAllList(rankService.showRanks(50));
        playerContext.write(CmdCode._11006, builder.build());
    }


    /**
     * 地牢排行榜
     */
    @CMD(id = CmdCode._11011)
    public void dungeonRankList(PlayerContext playerContext, GReqDungeonRankList msg) {
        GResDungeonRankList.Builder builder = GResDungeonRankList.newBuilder();
        AbstractPlayerRankService rankService = rankServiceProxy.getPlayerRank(RankType.DUNGEON);
        builder.setSelfData(rankService.selfRank(playerContext.getId()));
        builder.addAllList(rankService.showRanks(50));
        playerContext.write(CmdCode._11011, builder.build());
    }

    /**
     * 跨服战力榜
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._11012)
    public void crossFightingRankList(PlayerContext playerContext, RankGMsg.GReqCrossFightingRankList msg) {
        RankGMsg.GResCrossFightingRankList.Builder builder = RankGMsg.GResCrossFightingRankList.newBuilder();
        AbstractPlayerRankService rankService = rankServiceProxy.getPlayerRank(RankType.CROSS_FIGHTING);
        builder.setSelfData(rankService.selfRank(playerContext.getId()));
        builder.addAllList(rankService.showRanks(50));
        playerContext.write(CmdCode._11012, builder.build());
    }

    /**
     * 跨服公会排行榜
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._11013)
    public void crossClanRankList(PlayerContext playerContext, RankGMsg.GReqCrossClanRank msg) {
        Role role = roleService.getOrThrow(playerContext.getId());

        RankGMsg.GResCrossClanRank.Builder builder = RankGMsg.GResCrossClanRank.newBuilder();

        AbstractClanRankService rankService = rankServiceProxy.getClanRank(RankType.CROSS_CLAN);
        builder.setPsClanRankData(rankService.selfRank(role.getClanId()));
        builder.addAllList(rankService.showRanks(50));
        playerContext.write(CmdCode._11013, builder.build());
    }

    /**
     * 跨服公会排行榜
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._11014)
    public void godRelicRankList(PlayerContext playerContext, RankGMsg.GReqGodRelicRank msg) {
        Role role = roleService.getOrThrow(playerContext.getId());

        RankGMsg.GResGodRelicRank.Builder builder = RankGMsg.GResGodRelicRank.newBuilder();

        AbstractPlayerRankService rankService = rankServiceProxy.getPlayerRank(RankType.GOD_RELIC);
        builder.setSelf(rankService.selfRank(playerContext.getId()));
        builder.addAllList(rankService.showRanks(50));
        playerContext.write(CmdCode._11014, builder.build());
    }

    @CMD(id = CmdCode._11100)
    public void rankWorshipList(PlayerContext playerContext, RankGMsg.GReqRankWorshipList req) {
        RankGMsg.GResRankWorshipList.Builder builder = RankGMsg.GResRankWorshipList.newBuilder();
        RankWorship rankWorship = rankWorshipService.get(playerContext.getId());
        builder.addAllList(rankWorship.getWorshipTypes());
        playerContext.write(CmdCode._11100, builder.build());
    }

    @CMD(id = CmdCode._11101)
    public void rankWorship(PlayerContext playerContext, GReqRankWorship req) {
        RankWorship rankWorship = rankWorshipService.get(playerContext.getId());

        Asserts.isTrue(!rankWorship.getWorshipTypes().contains(req.getType()), ErrorCode.RANK_TYPE_HAD_WORSHIP.getValue(),
                String.format("该榜已经膜拜!{%s}-{%s}", JsonUtil.toJson(rankWorship.getWorshipTypes()), req.getType()));

        RankType rankType = RankType.typeOf(req.getType());
        AbstractRankService<?> rankService = rankServiceProxy.getRankService(rankType);

        Rank rank = rankService.getRankEntity(1);
        Asserts.notNull(rank, ErrorCode.RANK_TYPE_CANT_WORSHIP.getValue(), String.format("不存在膜拜对象!type:{%s}", req.getType()));

        rankWorship.addWorship(req.getType());
        rankWorship.setWorshipTime(TimeDateUtil.getCurrentTimeInt());
        rankWorshipService.update(rankWorship);

        //玩家的排行榜才有发送对象
        if (rankService instanceof AbstractPlayerRankService) {
            if (!rankType.isCross()) {
                RankWorship beWorship = rankWorshipService.get(rank.getRankId());
                PlayerContext beWorshipPlayer = contextManager.getOnline(rank.getRankId());
                if (beWorshipPlayer == null) {
                    beWorship.setCount(beWorship.getCount() + 1);
                    //被膜拜对象离线时，记录数据库
                    beWorship.addBeWorshipRecordOffline(req.getType(), playerContext.getId());
                    rankWorshipService.update(beWorship);
                } else {
                    //被膜拜对象在线时，推送通知
                    ResRankWorshipOffline.Builder beWorshipNotice = ResRankWorshipOffline.newBuilder();
                    ResRankWorshipData.Builder worshipData = ResRankWorshipData.newBuilder();
                    worshipData.setType(req.getType());
                    worshipData.setNick(roleService.getOrThrow(playerContext.getId()).getNick());
                    beWorshipNotice.addList(worshipData);
                    beWorshipPlayer.write(CmdCode._11102, beWorshipNotice.build());
                }
            } else {
                messageDispatcher.dispatch(ReqCrossRankWorshipMessage.createOf(rankType.getType(), rankWorship.getRid(), serverConfig.getServerId()));
            }
        }

        ImmutableThing immutableThing = ImmutableThing.of(ItemType.IT_GOLD, systemSysCache.getWorshipGetGold());
        thingService.add(playerContext.getId(), immutableThing, GameEvent.RANK_WORSHIP, NoticeType.TIPS);
    }

    /***
     * 跨服被膜拜
     * @param message
     */
    @RemoteMethod
    public void beWorship(ResCrossRankWorshipMessage message) {
        Role role = roleService.getOrThrow(message.getBeWorshipId());
        RankWorship rankWorship = rankWorshipService.get(role.getId());
        PlayerContext beWorshipPlayer = contextManager.getOnline(role.getId());
        if (beWorshipPlayer == null) {
            //被膜拜对象离线时，记录数据库
            rankWorship.setCount(rankWorship.getCount() + 1);
            if (!rankWorship.getCrossBeWorship().stream().anyMatch(data1 -> data1.getRid() == message.getWorshiperRid())) {
                BeWorshipData data = new BeWorshipData();
                data.setNick(message.getWorshiperName());
                data.setRid(message.getWorshiperRid());
                data.setType(message.getType());
                rankWorship.getCrossBeWorship().add(data);
                if (rankWorship.getCrossBeWorship().size() > 100) {
                    rankWorship.getCrossBeWorship().remove(0);
                }
            }
            rankWorshipService.update(rankWorship);
        } else {
            //被膜拜对象在线时，推送通知
            ResRankWorshipOffline.Builder beWorshipNotice = ResRankWorshipOffline.newBuilder();
            ResRankWorshipData.Builder worshipData = ResRankWorshipData.newBuilder();
            worshipData.setType(message.getType());
            worshipData.setNick(message.getWorshiperName());
            beWorshipNotice.addList(worshipData);
            beWorshipPlayer.write(CmdCode._11102, beWorshipNotice.build());
        }
    }

    @Subscribe
    public void loginSend(LoginEvent event) {
        RankWorship rankWorship = rankWorshipService.get(event.getRid());
        RankGMsg.ResRankWorshipOffline.Builder beWorshipNotice = RankGMsg.ResRankWorshipOffline.newBuilder();
        if (TimeDateUtil.isToday(rankWorship.getBeWorshipTime()) && !rankWorship.getBeWorshipRecord().isEmpty()) {
            rankWorship.getBeWorshipRecord().entrySet().forEach(entry -> {
                entry.getValue().forEach(worshipId -> {
                    RankGMsg.ResRankWorshipData.Builder worshipData = RankGMsg.ResRankWorshipData.newBuilder();
                    worshipData.setType(entry.getKey());
                    worshipData.setNick(roleService.getOrThrow(worshipId).getNick());
                    beWorshipNotice.addList(worshipData);
                });
            });
        }
        if (!rankWorship.getCrossBeWorship().isEmpty()) {
            rankWorship.getCrossBeWorship().forEach(data -> {
                RankGMsg.ResRankWorshipData.Builder worshipData = RankGMsg.ResRankWorshipData.newBuilder();
                worshipData.setType(data.getType());
                worshipData.setNick(data.getNick());
                beWorshipNotice.addList(worshipData);
            });

        }
        if (beWorshipNotice.getListCount() > 0)
            contextManager.write(event.getRid(), CmdCode._11102, beWorshipNotice.build());
        rankWorship.getBeWorshipRecord().clear();
        rankWorship.getCrossBeWorship().clear();
        rankWorshipService.update(rankWorship);
    }
}
