package com.ayjs.mxzg.gameserver.module.stagematch.rim.handler;

import com.ayjs.mxzg.common.command.serivce.CommandBus;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.config.excel.cache.NoticeSysCache;
import com.ayjs.mxzg.config.excel.cache.stageMatch.rim.SuperStageTokenRewardCache;
import com.ayjs.mxzg.config.excel.entity.CNotice;
import com.ayjs.mxzg.config.excel.entity.stageMatch.rim.CSuperStageTokenReward;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.chat.constant.ChatType;
import com.ayjs.mxzg.gameserver.module.chat.service.ChatService;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.mail.service.MailService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.domain.RoleStageMatch;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.service.StageMatchService;
import com.ayjs.mxzg.gameserver.module.stagematch.rim.domain.HeroMvpInfo;
import com.ayjs.mxzg.gameserver.module.stagematch.rim.domain.StageSeasonDetail;
import com.ayjs.mxzg.gameserver.module.stagematch.rim.service.StageMatchRimService;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.message.module.role.dao.CrossRoleRedisDao;
import com.ayjs.mxzg.message.module.role.domain.CrossRole;
import com.ayjs.mxzg.message.module.stagematch.SeasonDetailReqMessage;
import com.ayjs.mxzg.message.module.stagematch.SeasonDetailResMessage;
import com.ayjs.mxzg.protocol.StageMatchRimGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.dispatcher.MessageDispatcher;
import com.google.protobuf.InvalidProtocolBufferException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2020/6/16
 **/
@Component
@Slf4j
public class StageMatchRimHandler extends ProtocolHandler {

    @Autowired
    private StageMatchRimService stageMatchRimService;
    @Autowired
    private SuperStageTokenRewardCache stageMatchTokenRewardCache;
    @Autowired
    private CrossRoleRedisDao crossRoleRedisDao;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private HeroService heroService;
    @Autowired
    private CommandBus commandBus;
    @Autowired
    private RoleService roleService;
    @Autowired
    private NoticeSysCache noticeSysCache;
    @Autowired
    private MailService mailService;
    @Autowired
    private ChatService chatService;
    @Autowired
    private ThingService thingService;
    @Autowired
    private StageMatchService stageMatchService;
    @Autowired
    private ServerConfig serverConfig;
    @Autowired
    private MessageDispatcher messageDispatcher;

    @CMD(id = CmdCode._72101)
    public void getData(PlayerContext playerContext, StageMatchRimGMsg.GReqStageToken req) {
        StageSeasonDetail seasonDetail = stageMatchRimService.getSeasonDetail(playerContext.getId(), stageMatchRimService.getSeasonId());

        StageMatchRimGMsg.GResStageToken.Builder builder = StageMatchRimGMsg.GResStageToken.newBuilder();
        builder.setHadBuy(seasonDetail.isBuyStageToken());
        builder.addAllRewardId(seasonDetail.getStageRecords());
        builder.addAllTokenRewardId(seasonDetail.getStageTokenRecords());
        builder.setWinCount(seasonDetail.getNormalTotalCount() + seasonDetail.getEliteTotalCount());
        playerContext.write(CmdCode._72101, builder.build());
    }

    @CMD(id = CmdCode._72102)
    public void getReward(PlayerContext playerContext, StageMatchRimGMsg.GReqStageTokenGetReward req) {
        StageSeasonDetail seasonDetail = stageMatchRimService.getSeasonDetail(playerContext.getId(), stageMatchRimService.getSeasonId());

        CSuperStageTokenReward config = stageMatchTokenRewardCache.getOrThrow(req.getIdx());

        Asserts.isTrue(config.getWin_count() <= seasonDetail.getEliteTotalCount() + seasonDetail.getNormalTotalCount()
                , ErrorCode.STATE_TOKEN_HAD_GET.getValue(), String.format("奖励已经领取{%s}", config.getIdx()));

        Asserts.isTrue(!seasonDetail.getStageRecords().contains(config.getIdx()) || (seasonDetail.isBuyStageToken() &&
                        !seasonDetail.getStageTokenRecords().contains(config.getIdx())), ErrorCode.STATE_TOKEN_HAD_GET.getValue(),
                String.format("奖励已经领取{%s}", config.getIdx()));

        List<ImmutableThing> rewards = new ArrayList<>();
        if (!seasonDetail.getStageRecords().contains(config.getIdx())) {
            seasonDetail.getStageRecords().add(config.getIdx());
            rewards.addAll(config.getReward());
        }
        if (seasonDetail.isBuyStageToken()) {
            seasonDetail.getStageTokenRecords().add(config.getIdx());
            rewards.addAll(config.getToken_reward());
        }
        stageMatchRimService.update(seasonDetail);
        thingService.add(playerContext.getId(), rewards, GameEvent.STAGE_TOKEN_REWARD);

        StageMatchRimGMsg.GReqStageTokenGetReward.Builder builder = StageMatchRimGMsg.GReqStageTokenGetReward.newBuilder();
        builder.setIdx(config.getIdx());
        playerContext.write(CmdCode._72102, builder.build());
    }

    @CMD(id = CmdCode._72103)
    public void getTotalSeason(PlayerContext playerContext, StageMatchRimGMsg.GResTotalSeason req) {
        StageSeasonDetail totalSeason = stageMatchRimService.getSeasonDetail(playerContext.getId(), StageMatchRimService.TOTAL_SEASON_ID);

        StageMatchRimGMsg.GResTotalSeason.Builder builder = StageMatchRimGMsg.GResTotalSeason.newBuilder();
        builder.setTotalSeason(builderSeason(totalSeason));
        playerContext.write(CmdCode._72103, builder.build());
    }

    private StageMatchRimGMsg.PSSeasonUnit builderSeason(StageSeasonDetail seasonDetail) {
        if (seasonDetail == null) {
            return StageMatchRimGMsg.PSSeasonUnit.getDefaultInstance();
        }
        StageMatchRimGMsg.PSSeasonUnit.Builder builder = StageMatchRimGMsg.PSSeasonUnit.newBuilder();

        builder.setSeasonId(seasonDetail.getSeasonId());
        builder.setHistoryStageId(seasonDetail.getStageId());
        builder.setHistoryScore(seasonDetail.getMaxScore());

        RoleStageMatch roleStageMatch = stageMatchService.getOrCreate(seasonDetail.getRid(), false);
        builder.setCurrStageId(roleStageMatch.getStageId());
        builder.setCurrScore(roleStageMatch.getEliteIntegral());

        builder.setNormalWinCount(seasonDetail.getNormalWinCount());
        builder.setNormalWinRate((int) (seasonDetail.getNormalWinCount() * 100f / seasonDetail.getNormalTotalCount()));

        builder.setEliteWinCount(seasonDetail.getEliteWinCount());
        builder.setEliteWinRate((int) (seasonDetail.getEliteWinCount() * 100f / seasonDetail.getEliteTotalCount()));

        builder.setHistoryMaxDmg(seasonDetail.getMaxDmg());
        builder.setHistoryWinningStreak(seasonDetail.getMaxWinningStreak());

        HeroMvpInfo mvpHero = seasonDetail.getMvpHero();
        if (mvpHero.getHeroType() > 0) {
            StageMatchRimGMsg.PSMvpHero.Builder mvpBuilder = StageMatchRimGMsg.PSMvpHero.newBuilder();
            mvpBuilder.setFashionId(mvpHero.getFashionId());
            mvpBuilder.setHeroType(mvpHero.getHeroType());
            mvpBuilder.setStar(mvpHero.getStar());
            mvpBuilder.setLevel(mvpHero.getLevel());
            if (mvpHero.getEvolve() != null) {
                mvpBuilder.setEvolve(PbUtil.builderEvolve(mvpHero.getEvolve().getType(), mvpHero.getEvolve().getLevel()));
            }
            builder.setMvpHero(mvpBuilder.build());
        }

        if (seasonDetail.getStrongestOpponentRid() > 0) {
            CrossRole crossRole = crossRoleRedisDao.get(seasonDetail.getStrongestOpponentRid());
            if (crossRole != null) {
                StageMatchRimGMsg.PSOpponent.Builder opponentBuilder = StageMatchRimGMsg.PSOpponent.newBuilder();
                opponentBuilder.setFighting(seasonDetail.getStrongestOpponentFighting());
                opponentBuilder.setFighting2(seasonDetail.getStrongestOpponentFighting2());
                opponentBuilder.setRid(seasonDetail.getStrongestOpponentRid());
                opponentBuilder.setServer(crossRole.getServerId());
                opponentBuilder.setBorderId(crossRole.getBorderId());
                opponentBuilder.setHeadId(crossRole.getHeadId());
                opponentBuilder.setName(crossRole.getNick());
                opponentBuilder.setLevel(crossRole.getLevel());
                builder.setStrongestOpponent(opponentBuilder.build());
            }
        }
        return builder.build();
    }

    @CMD(id = CmdCode._72104)
    public void detailSeason(PlayerContext playerContext, StageMatchRimGMsg.GReqDetailSeason req) {
        Asserts.isTrue(stageMatchRimService.getSeasonId() >= req.getSeasonId() && (req.getSeasonId() > 0
                        || req.getSeasonId() == StageMatchRimService.TOTAL_SEASON_ID),
                ErrorCode.STATE_SEASON_ID_ERROR.getValue(), String.format("赛季id:{%s}错误", req.getSeasonId()));

        if (serverConfig.matchServerId(req.getServerId())) {
            StageSeasonDetail detailSeason = stageMatchRimService.getSeasonDetail(req.getRid(), req.getSeasonId());
            StageMatchRimGMsg.GResDetailSeason.Builder builder = StageMatchRimGMsg.GResDetailSeason.newBuilder();
            builder.setMaxSeasonId(stageMatchRimService.getSeasonId());
            builder.setSeason(builderSeason(detailSeason));
            playerContext.write(CmdCode._72104, builder.build());
        } else {
            messageDispatcher.dispatch(SeasonDetailReqMessage.of(req.getServerId(), req.getRid(), req.getSeasonId()), res -> {
                SeasonDetailResMessage response = (SeasonDetailResMessage) res;
                try {
                    StageMatchRimGMsg.GResDetailSeason builder = StageMatchRimGMsg.GResDetailSeason.parseFrom(response.getData());
                    playerContext.write(CmdCode._72104, builder);
                } catch (InvalidProtocolBufferException e) {
                    log.error(String.format("请求赛季错误，{%s}，{%s}，{%s}", req.getServerId(), req.getRid(), req.getSeasonId()), e);
                }
            });
        }
    }

    @RemoteMethod
    public SeasonDetailResMessage getSeason(SeasonDetailReqMessage req) {
        StageSeasonDetail detailSeason = stageMatchRimService.getSeasonDetail(req.getRid(), req.getSeasonId());
        StageMatchRimGMsg.GResDetailSeason.Builder builder = StageMatchRimGMsg.GResDetailSeason.newBuilder();
        builder.setMaxSeasonId(stageMatchRimService.getSeasonId());
        builder.setSeason(builderSeason(detailSeason));
        return SeasonDetailResMessage.of(builder.build().toByteArray());
    }

    @CMD(id = CmdCode._72105)
    public void sendSeasonShare(PlayerContext playerContext, StageMatchRimGMsg.GReqDetailSeasonShare msg) {

        ChatType chatType = ChatType.valueOf(msg.getChatType());
        Asserts.notNull(chatType, ErrorCode.CHAT_TYPE_NOT_EXIST.getValue(), "不存在聊天频道 " + msg.getChatType());
        Asserts.isTrue(chatType.isShareSeason(), ErrorCode.STATE_SEASON_SHARE_NOT_CHAT_TYPE.getValue(), "至尊段位赛战绩不允许分享在此频道");

        Role role = roleService.getOrThrow(playerContext.getId());

        long receiveId = 0;
        if (chatType == ChatType.CLAN) {
            Asserts.isTrue(role.getClanId() != 0, ErrorCode.CLAN_NOT_EXIST.getValue(), "未加入任何公会，不可分享至尊段位赛战绩在公会频道。");
            receiveId = role.getClanId();
        }

        CNotice cNotice = noticeSysCache.getOrThrow(chatType.getSeasonNoticeIdx());

        //编缉参数
        List<String> paramList = new ArrayList<>();
        paramList.add(String.valueOf(role.getServerId()));
        paramList.add(String.valueOf(role.getId()));

        //发送聊天信息
        String finalChat = mailService.formatParamStr(cNotice.getChat_lang(), cNotice.getParam(), paramList);

        ErrorCode errorCode = chatService.send(chatType, finalChat, playerContext.getId(), receiveId, true, cNotice.getIdx(), paramList);
        if (errorCode != ErrorCode.NO_ERROR) {
            playerContext.writeError(errorCode);
        }

    }


}
