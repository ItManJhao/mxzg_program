/**
 *
 */
package com.ayjs.mxzg.gameserver.module.role.handler;

import cn.hutool.core.util.StrUtil;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.LocalDateTimeUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.*;
import com.ayjs.mxzg.config.excel.entity.CArea;
import com.ayjs.mxzg.config.excel.entity.CCommentSharedReward;
import com.ayjs.mxzg.config.excel.entity.CGuideType;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.LineUpType;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.infrastructure.gm.GMCommandDispatcher;
import com.ayjs.mxzg.gameserver.infrastructure.gm.GMCommandInvoker;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.Rewards;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.border.event.RoleImageEvent;
import com.ayjs.mxzg.gameserver.module.clan.domain.Clan;
import com.ayjs.mxzg.gameserver.module.clan.service.ClanService;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroFashion;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroLineUp;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroFashionService;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroLineUpService;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.hero.struct.FashionData;
import com.ayjs.mxzg.gameserver.module.hero.struct.HeroPosition;
import com.ayjs.mxzg.gameserver.module.recharge.domain.RoleRecharge;
import com.ayjs.mxzg.gameserver.module.recharge.service.RoleRechargeService;
import com.ayjs.mxzg.gameserver.module.role.constant.CommentSharedState;
import com.ayjs.mxzg.gameserver.module.role.constant.CommentSharedType;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.domain.RoleCommentShared;
import com.ayjs.mxzg.gameserver.module.role.event.BuryingPointEvent;
import com.ayjs.mxzg.gameserver.module.role.event.GMCommandEvent;
import com.ayjs.mxzg.gameserver.module.role.event.RoleEditNickEvent;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.server.service.ServerParamService;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.message.module.role.dao.CrossRoleRedisDao;
import com.ayjs.mxzg.message.module.role.domain.CrossRole;
import com.ayjs.mxzg.protocol.HeroGMsg;
import com.ayjs.mxzg.protocol.RoleGMsg;
import com.ayjs.mxzg.protocol.RoleGMsg.*;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.google.common.collect.ImmutableList;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.tomcat.jni.Local;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

/**
 * @author YY
 *
 */
@Controller
@Slf4j
public class RoleHandler extends ProtocolHandler {

    @Autowired
    private RoleService roleService;
    @Autowired
    private HeroService heroService;
    @Autowired
    private ClanService clanService;
    @Autowired
    private HeroLineUpService heroLineUpService;
    @Autowired
    private RoleRechargeService roleRechargeService;
    @Autowired
    private GMCommandDispatcher gmCommandDispatcher;
    @Autowired
    private ServerConfig serverConfig;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private ThingService thingService;
    @Autowired
    private SystemSysCache systemSysCache;
    @Autowired
    private GuideTypeSysCache guideTypeSysCache;
    @Autowired
    private AreaSysCache areaSysCache;
    @Autowired
    private CrossRoleRedisDao crossRoleRedisDao;
    @Autowired
    private ServerParamService serverParamService;
    @Autowired
    private HeroFashionService heroFashionService;
    @Autowired
    private CommentSharedRewardSysCache commentSharedRewardSysCache;
    @Autowired
    private PeerageEmblemSysCache peerageEmblemSysCache;

    @CMD(id = CmdCode._2001)
    public void getRoleInfo(PlayerContext playerContext, GReqRoleInfo msg) {

        Role role = roleService.getOrThrow(playerContext.getId());

        GResRoleInfo.Builder builder = GResRoleInfo.newBuilder();
        builder.setGem(role.getGem());
        builder.setGold(role.getGold());
        builder.setExp(role.getExp());
        builder.setCup(role.getArenaScore());
        builder.setLevel(role.getLevel());
        builder.setHeadId(role.getHeadId());
        builder.setBorderId(role.getBorderId());

        builder.setNick(role.getNick());
        builder.setLastRequestTime((int) (role.getLastLoginTime() / 1000));
        builder.setLang(role.getLang());
        builder.setCreateTime((int) (role.getCreateTime() / 1000));
        builder.setClanId(role.getClanId());
        builder.setIsEditName(role.getIsEditName());
        builder.addAllSerial(role.getSerial());
        builder.addAllSerialStr(role.getSerialStr());

        builder.setImageId(role.getImageId());
        builder.setGoddessVip(role.getGoddessVip());
        builder.setHeroExp(role.getHeroExp());
        //TODO 重算一次战斗力？
        builder.setFighting(role.getFighting());
        builder.setAreaId(role.getAreaId());
        builder.setSuperGem(role.getSuperGem());

        builder.setClergyExp(role.getClergyExp());
        builder.setClergyLevel(role.getClergyLevel());

        builder.setServerCreateTime(serverParamService.getServerStartTime());
        builder.setServerLang(serverConfig.getServerLang());

        RoleRecharge roleRecharge = roleRechargeService.getRoleRecharge(role.getId());
        if (roleRecharge != null) {
            builder.setRecharge(roleRecharge.getTotalRecharge());
            builder.setPeerageLevel(peerageEmblemSysCache.getPeerageLevel(roleRecharge.getTotalRecharge()));
        }
        builder.setPeerageStatus(role.getPeerageChatStatus());
        builder.setRechargePopup(role.getRechargePopup());

        playerContext.write(CmdCode._2001, builder.build());
    }

    @CMD(id = CmdCode._2003)
    public void roleEditNick(PlayerContext playerContext, GReqRoleEditNick msg) {

        String nick = msg.getNick().trim();
        nick = nick.replaceAll("\r|\n", "");
        // 判断是否已经改过名字
        Role role = roleService.getOrThrow(playerContext.getId());
        //名字验证
        roleService.checkNick(nick,role);

        String oldNick = role.getNick();
        if (role.getIsEditName() != 0) {
            playerContext.writeError(ErrorCode.ROLE_EDITED_NICK);
            return;
        }
        if (roleService.hasSameName(nick)) {
            playerContext.writeError(ErrorCode.ROLE_NICK_EXISTS, nick);
            return;
        }
        role.setIsEditName(1);
        role.setNick(nick);
        roleService.updateRole(role);

        GResRoleEditNick.Builder builder = GResRoleEditNick.newBuilder();
        playerContext.write(CmdCode._2003, builder.build());

        eventBus.post(RoleEditNickEvent.of(role.getId(), role.getNick(), oldNick));
        // 发送创号信息给平台？
        // DHRole.userServer(role.getServer_id(), role.getUser_id(),
        // role.getNick(), role.getHead_id(), role.getLevel(), player.vip);
    }

    /**
     * 查看其它玩家的信息
     */
    @CMD(id = CmdCode._2004)
    public void playerDetaile(PlayerContext playerContext, GReqPlayerDetaile msg) {
        long rid = msg.getRid();
        if (rid <= 0) {
            // 参数错误
            playerContext.writeError(ErrorCode.ERROR_PARAM, rid);
            return;
        }
        int serverId = msg.getServerId();
        GResPlayerDetaile.Builder builder = GResPlayerDetaile.newBuilder();
        // 本服还是跨服数据
        if (serverId == 0 || serverConfig.matchServerId(serverId)) {
            Role otherRole = roleService.getOrThrow(rid);
            builder.setPlayerId(otherRole.getId());
            builder.setClanId(otherRole.getClanId());
            builder.setLevel(otherRole.getLevel());
            builder.setRank(otherRole.getArenaScore());
            builder.setServerId(otherRole.getServerId());
            builder.setHeadId(otherRole.getHeadId());
            builder.setBorderId(otherRole.getBorderId());
            builder.setNick(otherRole.getNick());
            if (otherRole.getClanId() > 0) {
                Clan clan = clanService.getOrThrow(otherRole.getClanId());
                if (clan != null) {
                    builder.setClanName(clan.getClanName());
                }
            }
            builder.setFighting(otherRole.getFighting());

            HeroLineUp heroLineUp = heroLineUpService.getLineUpByType(otherRole.getId(), LineUpType.MAIN);
            for (HeroPosition hpos : heroLineUp.getFormationMap().values()) {
                Hero hero = heroService.getHero(otherRole.getId(), hpos.getHeroId());
                if (hero != null) {
                    builder.addHeroData(heroService.serializeBriefData(hero, hpos.getPos()));
                }
            }
            builder.setFormationId(heroLineUp.getFormationId());
            builder.setAssistanceUnlock(otherRole.isAssistanceUnlock());
        } else {
            CrossRole crossRole = crossRoleRedisDao.get(rid);
            Asserts.isTrue(Objects.nonNull(crossRole) && crossRole.getId() > 0,
                    ErrorCode.ROLE_NOT_EXIST.getValue(),
                    () -> String.format("cross role is null rid:%s serverId:%s", rid, serverId));
            builder.setPlayerId(rid);
            builder.setHeadId(crossRole.getHeadId());
            builder.setClanId(crossRole.getClanId());
            builder.setNick(crossRole.getNick());
            builder.setLevel(crossRole.getLevel());
            builder.setServerId(crossRole.getServerId());
            if (Objects.nonNull(crossRole.getClanName())) {
                builder.setClanName(crossRole.getClanName());
            }
            builder.setRank(crossRole.getArenaScore());
            builder.setFighting(crossRole.getFighting());
            if (Objects.nonNull(crossRole.getHeroBrief())) {
                List<HeroGMsg.ResHeroBriefData> heroBriefList = crossRole.getHeroBrief().stream()
                        .map(heroBriefData -> heroService.serializeBriefData(heroBriefData))
                        .collect(Collectors.toList());
                builder.addAllHeroData(heroBriefList);
            }
            builder.setBorderId(crossRole.getBorderId());
            builder.setFormationId(crossRole.getFormationId());
        }

        playerContext.write(CmdCode._2004, builder.build());
    }

    @CMD(id = CmdCode._2005)
    public void guideSerial(PlayerContext playerContext, GReqGuideSerial msg) {
        Role role = roleService.getOrThrow(playerContext.getId());

        boolean needUpdate = false;
        for (Integer subType : msg.getSerialList()) {
            if (guideTypeSysCache.isGuide(subType) && !role.getSerial().contains(subType)) {
                role.getSerial().add(subType);
                needUpdate = true;
            }
        }
        for (String subType : msg.getSerialStrList()) {
            if (guideTypeSysCache.isGuide(subType) && !role.getSerialStr().contains(subType)) {
                role.getSerialStr().add(subType);
                needUpdate = true;
            }
        }
        if (needUpdate) {
            roleService.updateRole(role);
        }
    }

    @CMD(id = CmdCode._2011)
    public void roleChangeHead(PlayerContext playerContext, RoleGMsg.GReqRoleChangeHead msg) {
        RoleGMsg.GResRoleChangeHead.Builder builder = RoleGMsg.GResRoleChangeHead.newBuilder();

        //使用皮肤做形象id，1亿为前端非皮肤形象计算单位，要写死。
        if (msg.getImageId() < 100000000) {
            //获取已解锁的皮肤（皮肤id即为皮肤形象id）
            List<Integer> fashionIds = new ArrayList<>();
            HeroFashion heroFashion = heroFashionService.selectAndRefresh(playerContext.getId());

            for (FashionData fashionData : heroFashion.getFashionList()) {
                fashionIds.add(fashionData.getFashionId());

            }

            Asserts.isTrue(fashionIds.contains(msg.getImageId()), ErrorCode.HERO_FASHION_NOT_ACTIVE.getValue(),
                    "当前皮肤形象尚未解锁或已过期， fashionId:" + msg.getImageId());
        }

        Role role = roleService.getOrThrow(playerContext.getId());
        role.setImageId(msg.getImageId());
        roleService.updateRole(role);

        playerContext.write(CmdCode._2011, builder.build());

        eventBus.post(RoleImageEvent.of(role.getId(), role.getImageId()));
    }

    @CMD(id = CmdCode._2013)
    public void roleRandNick(PlayerContext playerContext, GReqRoleRandNick msg) {
        GResRoleRandNick.Builder builder = GResRoleRandNick.newBuilder();
        String nick = roleService.randomNick(null, playerContext.getId());
        builder.setNick(nick);

        playerContext.write(CmdCode._2013, builder.build());
    }

    @CMD(id = CmdCode._2015)
    public void gmCommandNew(PlayerContext playerContext, RoleGMsg.GReqGMCommandNew msg) {
        String command = msg.getCommand();
        try {
            // 是否开启了GM命名接口
            if (!serverConfig.isGmCmdOpen()) {
                return;
            }
            GMCommandInvoker invoker = gmCommandDispatcher.getInvoker(command);
            if (Objects.isNull(invoker)) {
                log.error("gm command:{} not invoker", command);
                return;
            }
            Role role = roleService.getOrThrow(playerContext.getId());
            invoker.getMethod().invoke(invoker.getInvoker(), role, msg.getParamList());

            eventBus.post(GMCommandEvent.of(role.getId(), command, msg.getParamList()));
        } catch (Exception e) {
            log.error("cmd error :" + command, e);
        }
    }

    /**
     * 领取新手指引奖励
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._2016)
    public void getNewbieReward(PlayerContext playerContext, GReqGetNewbieReward msg) {
        Role role = roleService.getOrThrow(playerContext.getId());

        Asserts.isTrue(role.getNewbieReward() == 0, ErrorCode.ROLE_NEWBIE_REWARD.getValue(),
                "新手奖励重复领取" + role.getId());

        role.setNewbieReward(1);
        roleService.updateRole(role);

        Rewards reward = thingService.add(playerContext.getId(), systemSysCache.getGuideInitialReward(), GameEvent.NEWBIE_REWARD, NoticeType.SLIENT);

        GResGetNewbieReward.Builder builder = GResGetNewbieReward.newBuilder();
        builder.addAllList(PbUtil.buildReward(reward.getThingSet().asList()));
        playerContext.write(CmdCode._2016, builder.build());
    }

    /**
     * 修改省市
     */
    @CMD(id = CmdCode._2019)
    public void updateAreaId(PlayerContext playerContext, RoleGMsg.GReqUpdateAreaId msg) {

        Role role = roleService.getOrThrow(playerContext.getId());

        CArea cArea = areaSysCache.getOrThrow(msg.getAreaId());

        role.setAreaId(cArea.getIdx());
        role.setProvince(cArea.getProvince());
        roleService.updateRole(role);
        RoleGMsg.GResUpdateAreaId.Builder res = RoleGMsg.GResUpdateAreaId.newBuilder();
        res.setAreaId(role.getAreaId());

        playerContext.write(CmdCode._2019, res.build());
    }

    /**
     *  花费道具二次改名
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._2020)
    public void renameRole(PlayerContext playerContext, RoleGMsg.GReqRoleRename msg) {
        RoleGMsg.GResRoleRename.Builder builder = RoleGMsg.GResRoleRename.newBuilder();

        String roleNick = msg.getNick().trim();
        //改名类型 1：钻石  2：道具
        int type = msg.getType();

        roleNick = roleNick.replaceAll("\r|\n", "");
        Role role = roleService.getOrThrow(playerContext.getId());
        //昵称验证
        roleService.checkNick(roleNick,role);

        final String roleNameTemp = roleNick;

        final String oldNick = role.getNick();

        //判断输入是否合法
        Asserts.isTrue(type == 1 || type == 2, ErrorCode.ROLE_NICK_EXISTS.getValue(),
                () -> StrUtil.format("角色名字重复 nick:{}", roleNameTemp));

        //判断名字是否重复
        Asserts.isTrue(!roleService.hasSameName(roleNick), ErrorCode.ROLE_NICK_EXISTS.getValue(),
                () -> StrUtil.format("角色名字重复 nick:{}", roleNameTemp));

//        Asserts.isTrue(!role.getNick().equals(nick), ErrorCode.ROLE_NICK_SAME.getValue(), "改名前后昵称相同。");

        //判断改名前后名字是否重复
        Asserts.isTrue(!role.getNick().equals(roleNick), ErrorCode.ROLE_CHANGE_OF_NAME.getValue(),
                () -> StrUtil.format("改名前后昵称相同 nick:{}", "改名前名称" + oldNick + "   改名后名称" + roleNameTemp));
        ImmutableList immutableList = null;
        if (type == 1) {
            immutableList = systemSysCache.getConsumptionProps();
            thingService.cost(playerContext.getId(), systemSysCache.getNickChangeCost(), GameEvent.RENAME_NICK);
        } else if (type == 2) {
            immutableList = systemSysCache.getConsumptionProps();
            thingService.cost(playerContext.getId(), systemSysCache.getConsumptionProps(), GameEvent.RENAME_PROP);
        }

        role.setNick(roleNick);
        roleService.updateRole(role);

        builder.setNick(roleNick);
        playerContext.write(CmdCode._2020, builder.build());

        eventBus.post(RoleEditNickEvent.of(role.getId(), role.getNick(), oldNick));

        roleService.sendRoleInfoToCross(role);
    }

    /**
     * 第三方评论点评分享奖励查询
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._2021)
    public void commentSharedState(PlayerContext playerContext, RoleGMsg.GReqCommentSharedState msg) {
        Map<Integer, RoleCommentShared> allCommentShared = roleService.getAllCommentShared(playerContext.getId());

        RoleGMsg.GResCommentSharedState.Builder builder = RoleGMsg.GResCommentSharedState.newBuilder();
        builder.addAllList(roleService.toRoleCommentSharedState(allCommentShared));

        playerContext.write(CmdCode._2021, builder.build());
    }

    /**
     * 第三方评论点评分享完成
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._2022)
    public void commentSharedComment(PlayerContext playerContext, RoleGMsg.GReqCommentSharedComment msg) {

        Map<Integer, RoleCommentShared> roleCommentSharedMap = roleService.getAllCommentShared(playerContext.getId());

        RoleCommentShared commentShared = roleCommentSharedMap.get(msg.getType());
        if (Objects.isNull(commentShared)) {
            // 不存在新增
            RoleCommentShared state = new RoleCommentShared();
            state.setType(msg.getType());
            state.setState(CommentSharedState.COMPLETED.getState());
            roleService.addOrUpdateRoleCommentShared(playerContext.getId(), state);
        } else {
            // fb分享一周一次，不能重复领奖
            if (commentShared.getType() == CommentSharedType.FB_SHARED.getType()
                    && commentShared.getState() == CommentSharedState.RECEIVED.getState()
                    && !TimeDateUtil.isCurrentWeek(commentShared.getDatetime())) {
                // 不是本周可以重新分享
                commentShared.setState(CommentSharedState.COMPLETED.getState());
            }
            //twitter分享,0点重置
            if (commentShared.getType() == CommentSharedType.TWITTER_SHARED.getType()
                    && commentShared.getState() == CommentSharedState.RECEIVED.getState()
                    && commentShared.getDatetime() < DateTimeUtil.dayBreak()) {
                //隔天凌晨可以重新分享和领取
                commentShared.setState(CommentSharedState.COMPLETED.getState());
            }
            if (commentShared.getState() == CommentSharedState.UNDONE.getState()) {
                commentShared.setState(CommentSharedState.COMPLETED.getState());
            }
            roleService.addOrUpdateRoleCommentShared(playerContext.getId(), commentShared);
        }

        RoleGMsg.GResCommentSharedComment.Builder builder = RoleGMsg.GResCommentSharedComment.newBuilder();

        builder.addAllList(roleService.toRoleCommentSharedState(roleService.getAllCommentShared(playerContext.getId())));
        playerContext.write(CmdCode._2022, builder.build());
    }

    /**
     * 第三方评论点评分享奖励领取
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._2023)
    public void commentSharedReward(PlayerContext playerContext, RoleGMsg.GReqCommentSharedReward msg) {

        Map<Integer, RoleCommentShared> roleCommentSharedMap = roleService.getAllCommentShared(playerContext.getId());

        RoleCommentShared commentShared = roleCommentSharedMap.get(msg.getType());

        Asserts.isTrue(Objects.nonNull(commentShared), ErrorCode.ROLE_COMMENT_SHARED_COMPLETED.getValue(),
                () -> StrUtil.format("评论分享未完成 type:{}", msg.getType()));

        Asserts.isTrue(commentShared.getState() == CommentSharedState.COMPLETED.getState(),
                ErrorCode.ROLE_COMMENT_SHARED_COMPLETED.getValue(),
                () -> StrUtil.format("评论分享未完成或已领取 type:{} state:{}", msg.getType(), commentShared.getType()));

        if (commentShared.getType() == CommentSharedType.FB_SHARED.getType()
                || commentShared.getType() == CommentSharedType.TWITTER_SHARED.getType()) {
            commentShared.setDatetime(DateTimeUtil.currentSecond());
        }
        commentShared.setState(CommentSharedState.RECEIVED.getState());
        roleService.addOrUpdateRoleCommentShared(playerContext.getId(), commentShared);

        CCommentSharedReward cCommentSharedReward = commentSharedRewardSysCache.getOrThrow(commentShared.getType());
        // 增加奖励
        thingService.add(playerContext.getId(), cCommentSharedReward.getReward(), GameEvent.COMMENT_SHARED_REWARD);

        RoleGMsg.GResCommentSharedReward.Builder builder = RoleGMsg.GResCommentSharedReward.newBuilder();
        builder.addAllList(roleService.toRoleCommentSharedState(roleService.getAllCommentShared(playerContext.getId())));
        playerContext.write(CmdCode._2023, builder.build());
    }

    /**
     * 修改贵族标识展示状态
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._2025)
    public void updatePeerageStatus(PlayerContext playerContext, RoleGMsg.GReqUpdatePeerageStatus msg) {

        Role role = roleService.getOrThrow(playerContext.getId());
        role.setPeerageChatStatus(role.getPeerageChatStatus() == 0 ? 1 : 0);
        roleService.updateRole(role);

        RoleGMsg.GResUpdatePeerageStatus.Builder builder = RoleGMsg.GResUpdatePeerageStatus.newBuilder();
        builder.setStatus(role.getPeerageChatStatus());
        playerContext.write(CmdCode._2025, builder.build());
    }

    /**
     *  修改（日本版本）充值弹窗状态
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._2026)
    public void updateRechargePopup(PlayerContext playerContext, RoleGMsg.GReqUpdateRechargePopup msg) {

        Role role = roleService.getOrThrow(playerContext.getId());
        role.setRechargePopup(1);
        roleService.updateRole(role);

        RoleGMsg.GResUpdateRechargePopup.Builder builder = RoleGMsg.GResUpdateRechargePopup.newBuilder();
        builder.setRechargePopup(role.getRechargePopup());
        playerContext.write(CmdCode._2026, builder.build());
    }

    /**
     *  推送开关获取
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._2027)
    public void pushOnOffGet(PlayerContext playerContext, RoleGMsg.GReqPushOnOffGet msg) {
        Role role = roleService.getOrThrow(playerContext.getId());

        RoleGMsg.GResPushOnOffGet.Builder builder = RoleGMsg.GResPushOnOffGet.newBuilder();
        builder.addAllOffIds(role.getPushOffIds());

        playerContext.write(CmdCode._2027, builder.build());
    }

    /**
     *  推送开关更新
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._2028)
    public void pushOnOffGet(PlayerContext playerContext, RoleGMsg.GReqPushOnOffUpdate msg) {

        Role role = roleService.getOrThrow(playerContext.getId());

        Set<Integer> pushOffIds = role.getPushOffIds();
        if (CollectionUtils.isNotEmpty(msg.getOffIdsList())) {
            pushOffIds.clear();
            pushOffIds.addAll(msg.getOffIdsList());

            roleService.updateRole(role);
        }

        RoleGMsg.GResPushOnOffUpdate.Builder builder = RoleGMsg.GResPushOnOffUpdate.newBuilder();
        builder.addAllOffIds(pushOffIds);
        playerContext.write(CmdCode._2028, builder.build());
    }

    /**
     * 玩家指引数据埋点请求
     */
    @CMD(id = CmdCode._2029)
    public void reqBuryingPoint(PlayerContext playerContext, GReqBuryingPoint msg) {
        long rid = playerContext.getId();
        LocalDateTime lastGuideTime = roleService.getLastGuideTime(rid);
        eventBus.post(BuryingPointEvent.of(rid, msg.getIdx(), lastGuideTime));
        roleService.updateLastGuideTime(rid, LocalDateTime.now());
        playerContext.write(CmdCode._2029, GResBuryingPoint.getDefaultInstance());
    }

}
