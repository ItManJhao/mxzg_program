package com.ayjs.mxzg.gameserver.module.heroShare.handler;

import cn.hutool.core.collection.CollectionUtil;
import cn.hutool.core.util.StrUtil;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.GJsonUtils;
import com.ayjs.mxzg.config.excel.cache.NoticeSysCache;
import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.config.excel.entity.CNotice;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.chat.constant.ChatType;
import com.ayjs.mxzg.gameserver.module.chat.service.ChatService;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroMagicWandService;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.heroShare.domain.HeroShareInfo;
import com.ayjs.mxzg.gameserver.module.heroShare.service.HeroShareInfoService;
import com.ayjs.mxzg.gameserver.module.heroShare.util.ShareUtil;
import com.ayjs.mxzg.gameserver.module.mail.service.MailService;
import com.ayjs.mxzg.gameserver.module.marquee.constant.NoticeIdx;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.message.module.hero.message.ReqRemoteHeroMessage;
import com.ayjs.mxzg.message.module.hero.message.ResRemoteHeroMessage;
import com.ayjs.mxzg.message.module.hero.message.dto.RemoteEquipInfo;
import com.ayjs.mxzg.message.module.hero.message.dto.RemoteGodEquip;
import com.ayjs.mxzg.message.module.hero.message.dto.RemoteHeroInfo;
import com.ayjs.mxzg.message.module.hero.message.dto.RemoteJewelInfo;
import com.ayjs.mxzg.message.module.hero.message.dto.RemoteRuneInfo;
import com.ayjs.mxzg.message.module.hero.message.dto.RemoteTalentInfo;
import com.ayjs.mxzg.protocol.HeroShareGMsg;
import com.ayjs.mxzg.protocol.HeroShareGMsg.GResHeroBriefInfo;
import com.ayjs.mxzg.protocol.HeroShareGMsg.GResHeroShare;
import com.ayjs.mxzg.protocol.HeroShareGMsg.GResShareHeroInfo;
import com.ayjs.mxzg.protocol.HeroShareGMsg.PSHeroShare;
import com.ayjs.mxzg.protocol.HeroShareGMsg.ResHeroInfo;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.dispatcher.MessageDispatcher;
import com.ayjs.rpc.dispatcher.MessageHandler;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

/**
 * 英雄分享
 *
 * @author hyx
 */
@Slf4j
@Controller
public class HeroShareHandle extends ProtocolHandler implements MessageHandler {

    @Autowired
    private RoleService roleService;
    @Autowired
    private NoticeSysCache noticeSysCache;
    @Autowired
    private HeroService heroService;
    @Autowired
    private HeroShareInfoService heroShareInfoService;
    @Autowired
    private ChatService chatService;
    @Autowired
    private MailService mailService;
    @Autowired
    private ServerConfig serverConfig;
    @Autowired
    private MessageDispatcher messageDispatcher;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private SystemSysCache systemSysCache;
    @Autowired
    private HeroMagicWandService heroMagicWandService;

    /**
     * 英雄分享
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._4033)
    public void heroShare(PlayerContext playerContext, HeroShareGMsg.GReqHeroShare msg) {

        Role role = roleService.getOrThrow(playerContext.getId());

        int channelType = msg.getChannelType() == 1 ? ChatType.CROSS_CHAT.getValue() : msg.getChannelType();

        ChatType chatType = ChatType.valueOf(channelType);
        Asserts.notNull(chatType, ErrorCode.CHAT_TYPE_NOT_EXIST.getValue(), () -> String.format("chat type is null:%s", msg.getChannelType()));

        Asserts.isTrue(chatType == ChatType.CLAN || chatType == ChatType.WORLD || chatType == ChatType.CROSS_CHAT,
                ErrorCode.HERO_SHARE_NOT_CHAT_TYPE.getValue(), "英雄不允许分享此频道");

        CNotice cNotice = null;
        long receiveId = 0;
        if (chatType == ChatType.CLAN) {
            cNotice = noticeSysCache.getOrThrow(NoticeIdx.HERO_SHARE_CLAN);
            receiveId = role.getClanId();
            Asserts.isTrue(role.getClanId() != 0, ErrorCode.CLAN_NOT_EXIST.getValue(), "未加入任何公会,不可分享英雄在公会频道。");
        } else if (chatType == ChatType.WORLD) {
            cNotice = noticeSysCache.getOrThrow(NoticeIdx.HERO_SHARE_WORLD);
        } else {
            cNotice = noticeSysCache.getOrThrow(NoticeIdx.HERO_SHARE_KF);
        }

        Asserts.notNull(cNotice, ErrorCode.HERO_NOT_EXIST.getValue(), "英雄分享公告不存在。");

        Hero hero = heroService.getHero(playerContext.getId(), msg.getHeroId());
        Asserts.notNull(hero, ErrorCode.HERO_NOT_EXIST.getValue(),
                "英雄分享失败，没找到该英雄，rid:" + playerContext.getId() + ",heroId" + msg.getHeroId());

        //保存分享英雄镜像
        HeroShareInfo heroShareInfo = heroShareInfoService.add(playerContext.getId(), msg.getHeroId());

        //编缉参数
        List<String> paramList = new ArrayList<>();
        paramList.add(String.valueOf(hero.getType()));
        paramList.add(String.valueOf(role.getServerId()));
        paramList.add(heroShareInfo.getId());

        log.info("************************************分享参数:{}", paramList);

        //发送聊天信息
        String finalChat = mailService.formatParamStr(cNotice.getChat_lang(), cNotice.getParam(), paramList);
        ErrorCode errorCode = chatService.send(chatType, finalChat, playerContext.getId(), receiveId, true, cNotice.getIdx(), paramList);
        if (errorCode != ErrorCode.NO_ERROR) {
            playerContext.writeError(errorCode);
        } else {
            GResHeroShare.Builder builder = GResHeroShare.newBuilder();
            builder.setStatus(1);
            playerContext.write(CmdCode._4033, builder.build());
        }

    }

    //
    private PSHeroShare buildHeroShare(HeroShareInfo heroShareInfo) {
        PSHeroShare.Builder builder = PSHeroShare.newBuilder();

        ResHeroInfo.Builder heroBuilder = ResHeroInfo.newBuilder();
        heroBuilder.setHeroType(heroShareInfo.getHeroType());
        heroBuilder.setStar(heroShareInfo.getHeroStar());
        heroBuilder.setStage(heroShareInfo.getHeroStage());
        heroBuilder.setLevel(heroShareInfo.getHeroLevel());
        heroBuilder.setFighting(heroShareInfo.getHeroFighting());
        heroBuilder.setHp(heroShareInfo.getHeroHp());
        heroBuilder.setDef(heroShareInfo.getHeroDef());
        heroBuilder.setAtk(heroShareInfo.getHeroAtk());
        heroBuilder.setAgl(heroShareInfo.getHeroAgl());
        heroBuilder.setFashionId(heroShareInfo.getFashionId());
        heroBuilder.addAllReikiPlaces(heroShareInfo.getReikiPlaces());
        //宠物信息
        heroBuilder.setPet(PbUtil.builderPet(heroShareInfo.getPetInfo()));
        //图腾信息
        heroBuilder.setTotems(PbUtil.builderTotems(heroShareInfo.getTotemsInfo()));
        heroBuilder.setEvolve(PbUtil.builderEvolve(heroShareInfo.getHeroEvolve()));

        builder.setHero(heroBuilder);

        heroShareInfo.getEquipInfoList().forEach(equipInfo -> {
            builder.addEquipList(ShareUtil.buildEquip(equipInfo));
        });

        heroShareInfo.getRuneInfoList().forEach(runeInfo -> {
            builder.addRuneList(ShareUtil.buildRune(runeInfo));
        });

        heroShareInfo.getJewels().forEach(jewelInfo -> {
            builder.addJewelList(ShareUtil.buildJewel(jewelInfo));
        });

        heroShareInfo.getTalents().forEach(talent -> {
            builder.addTalentList(PbUtil.serializeTalent(talent));
        });

        heroShareInfo.getGodEquips().forEach(godEquip -> {
            builder.addGodEquipList(PbUtil.buildGodEquip(godEquip));
        });

        builder.addAllReikiEquipList(heroShareInfo.getReikiEquips());
        builder.setMagicInfo(heroMagicWandService.convertItemInfo(heroShareInfo.getHeroMagicWand()));

        return builder.build();
    }


    private PSHeroShare buildHeroShare(ResRemoteHeroMessage resRemoteHero) {
        PSHeroShare.Builder builder = PSHeroShare.newBuilder();

        RemoteHeroInfo hero = resRemoteHero.getHeroInfo();
        ResHeroInfo.Builder heroBuilder = ResHeroInfo.newBuilder();
        heroBuilder.setHeroType(hero.getHeroType());
        heroBuilder.setStar(hero.getStar());
        heroBuilder.setStage(hero.getStage());
        heroBuilder.setLevel(hero.getLevel());
        heroBuilder.setFighting(hero.getFighting());
        heroBuilder.setHp(hero.getHp());
        heroBuilder.setDef(hero.getDef());
        heroBuilder.setAtk(hero.getAtk());
        heroBuilder.setAgl(hero.getAgl());
        heroBuilder.setFashionId(hero.getFashionId());
        if (CollectionUtil.isNotEmpty(hero.getReiki_places())) {
            heroBuilder.addAllReikiPlaces(hero.getReiki_places());
        }
        if (hero.getPet() != null) {
            heroBuilder.setPet(PbUtil.builderPet(hero.getPet()));
        }
        if(hero.getTotemsInfo() !=null){
            heroBuilder.setTotems(PbUtil.builderTotems(hero.getTotemsInfo()));
        }
        builder.setHero(heroBuilder.build());

        List<RemoteEquipInfo> equipInfos = resRemoteHero.getEquipInfos();
        if (CollectionUtil.isNotEmpty(equipInfos)) {
            equipInfos.forEach(heroEquip -> {
                builder.addEquipList(ShareUtil.buildEquip(heroEquip));
            });
        }
        List<RemoteRuneInfo> runeInfos = resRemoteHero.getRuneInfos();
        if (CollectionUtil.isNotEmpty(runeInfos)) {
            runeInfos.forEach(runeInfo -> {
                builder.addRuneList(ShareUtil.buildRune(runeInfo));
            });
        }
        List<RemoteJewelInfo> jewels = resRemoteHero.getJewels();
        if (CollectionUtil.isNotEmpty(jewels)) {
            jewels.forEach(jewel -> {
                builder.addJewelList(ShareUtil.buildJewel(jewel));
            });
        }
        List<RemoteTalentInfo> talents = resRemoteHero.getTalents();
        if (CollectionUtil.isNotEmpty(talents)) {
            talents.forEach(talent -> {
                builder.addTalentList(ShareUtil.buildTalent(talent));
            });
        }
        List<RemoteGodEquip> godEquips = resRemoteHero.getGodEquips();
        if (CollectionUtil.isNotEmpty(godEquips)) {
            godEquips.forEach(godEquip -> {
                builder.addGodEquipList(ShareUtil.buildGodEquip(godEquip));
            });
        }
        List<Integer> reikiEquips = resRemoteHero.getReikiEquips();
        if (CollectionUtil.isNotEmpty(reikiEquips)) {
            builder.addAllReikiEquipList(reikiEquips);
        }

        return builder.build();
    }

    /**
     * 查看分享英雄信息
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._4034)
    public void heroShareInfo(PlayerContext playerContext, HeroShareGMsg.GReqShareHeroInfo msg) {
        log.info("***************************分享id:{}", msg.getShareId());
        HeroShareInfo heroShareInfo = heroShareInfoService.get(msg.getShareId());

        GResShareHeroInfo.Builder builder = GResShareHeroInfo.newBuilder();
        builder.setHero(buildHeroShare(heroShareInfo));
        playerContext.write(CmdCode._4034, builder.build());
    }

    /**
     * 通过个人信息页面查看英雄简要信息
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._4035)
    public void roleHeroInfo(PlayerContext playerContext, HeroShareGMsg.GReqHeroBriefInfo msg) {
        int serverId = msg.getServerId();
        Asserts.isTrue(msg.getHeroId() > 0, ErrorCode.HERO_NOT_EXIST.getValue(),
                () -> StrUtil.format("heroId:{}", msg.getHeroId()));

        if (serverId == 0 || serverConfig.matchServerId(serverId)) {// 同服
            HeroShareInfo heroShareInfo = heroShareInfoService.buildShare(msg.getRid(), msg.getHeroId());

            GResHeroBriefInfo.Builder builder = GResHeroBriefInfo.newBuilder();
            builder.setHero(buildHeroShare(heroShareInfo));
            playerContext.write(CmdCode._4035, builder.build());
        } else {//不同服
            ReqRemoteHeroMessage reqCrossHeroMessage = new ReqRemoteHeroMessage();
            reqCrossHeroMessage.setServerId(serverId);
            reqCrossHeroMessage.setReqRid(playerContext.getId());
            reqCrossHeroMessage.setRespRid(msg.getRid());
            reqCrossHeroMessage.setRespHeroId(msg.getHeroId());
            messageDispatcher.dispatch(reqCrossHeroMessage, v -> {
                try {
                    ResRemoteHeroMessage resRemoteHero = (ResRemoteHeroMessage) v;
                    if (Objects.isNull(resRemoteHero) || Objects.isNull(resRemoteHero.getHeroInfo())
                            || resRemoteHero.getHeroInfo().getFighting() <= 0) {
                        String message = StrUtil.format("remote hero info error serverId:{}, respRid:{}, heroId:{}",
                                serverId, msg.getRid(), msg.getHeroId());
                        log.debug(message);
                        contextManager.writeError(playerContext.getId(), ErrorCode.HERO_NOT_EXIST, message);
                        return;
                    }

                    if (log.isDebugEnabled()) {
                        log.debug("remote hero:{}", GJsonUtils.toJson(resRemoteHero));
                    }
                    GResHeroBriefInfo.Builder builder = GResHeroBriefInfo.newBuilder();
                    builder.setHero(buildHeroShare(resRemoteHero));
                    contextManager.write(playerContext.getId(), CmdCode._4035, builder.build());
                } catch (Exception e) {
                    contextManager.writeError(playerContext.getId(), ErrorCode.HERO_NOT_EXIST,
                            StrUtil.format("remote hero info exception serverId:{}, respRid:{}, heroId:{}",
                                    serverId, msg.getRid(), msg.getHeroId()));
                    e.printStackTrace();
                }
            });
        }
    }


    /***
     * 返回英雄给跨服(跨服再返回给请求服务器)
     */
    @RemoteMethod
    public ResRemoteHeroMessage returnHeroToCross(ReqRemoteHeroMessage message) {
        ResRemoteHeroMessage resCrossHeroMessage = new ResRemoteHeroMessage();
        try {

            Hero hero = heroService.getHero(message.getRespRid(), message.getRespHeroId());

            if (Objects.isNull(hero)) {
                log.warn("get hero is null rid:{}, heroId:{}", message.getRespRid(), message.getRespHeroId());
                return resCrossHeroMessage;
            }
            resCrossHeroMessage.setHeroInfo(heroShareInfoService.getRemoteHeroInfo(hero));
            resCrossHeroMessage.setEquipInfos(heroShareInfoService.getRemoteEquipInfos(message.getRespRid(), message.getRespHeroId()));
            resCrossHeroMessage.setRuneInfos(heroShareInfoService.getRemoteRuneInfos(message.getRespRid(), message.getRespHeroId()));
            resCrossHeroMessage.setJewels(heroShareInfoService.getRemoteJewelInfo(message.getRespRid(), message.getRespHeroId()));
            resCrossHeroMessage.setTalents(heroShareInfoService.getRemoteTalentInfo(message.getRespRid(), message.getRespHeroId()));
            resCrossHeroMessage.setGodEquips(heroShareInfoService.getRemoteGodEquip(message.getRespRid(), message.getRespHeroId()));
            resCrossHeroMessage.setReikiEquips(heroShareInfoService.getReikiEquip(message.getRespRid(), message.getRespHeroId()));

            log.debug("return hero to remote:{}", GJsonUtils.toJson(resCrossHeroMessage));
        } catch (Exception e) {
            log.warn("get hero exception rid:{}, heroId:{}", message.getRespRid(), message.getRespHeroId());
            e.printStackTrace();
        }
        return resCrossHeroMessage;
    }
}
