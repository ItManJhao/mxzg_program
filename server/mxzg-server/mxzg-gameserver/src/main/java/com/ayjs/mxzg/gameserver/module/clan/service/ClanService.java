package com.ayjs.mxzg.gameserver.module.clan.service;

import cn.hutool.core.collection.CollectionUtil;
import cn.hutool.core.util.StrUtil;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.ConcurrentHashSet;
import com.ayjs.mxzg.common.util.InternerPool;
import com.ayjs.mxzg.common.util.StringUtil;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.ClanLevelSysCache;
import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.config.excel.constant.ClanConst;
import com.ayjs.mxzg.config.excel.entity.CClanLevel;
import com.ayjs.mxzg.config.struct.ClanJobEnum;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.Language;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.clan.constant.ClanConstant;
import com.ayjs.mxzg.gameserver.module.clan.constant.ClanLock;
import com.ayjs.mxzg.gameserver.module.clan.constant.CreateClanResult;
import com.ayjs.mxzg.gameserver.module.clan.dao.ClanBossDao;
import com.ayjs.mxzg.gameserver.module.clan.dao.ClanDao;
import com.ayjs.mxzg.gameserver.module.clan.dao.ClanMemberDao;
import com.ayjs.mxzg.gameserver.module.clan.domain.Clan;
import com.ayjs.mxzg.gameserver.module.clan.domain.ClanBoss;
import com.ayjs.mxzg.gameserver.module.clan.domain.ClanMember;
import com.ayjs.mxzg.gameserver.module.clan.domain.ClanMemberDonate;
import com.ayjs.mxzg.gameserver.module.clan.event.ClanChangeEvent;
import com.ayjs.mxzg.gameserver.module.clan.event.ClanExpAddEvent;
import com.ayjs.mxzg.gameserver.module.clan.struct.ClanDungeonDamageData;
import com.ayjs.mxzg.gameserver.module.clan.struct.ClanMsgData;
import com.ayjs.mxzg.gameserver.module.clanwar.service.ClanWarService;
import com.ayjs.mxzg.gameserver.module.recharge.domain.RoleRecharge;
import com.ayjs.mxzg.gameserver.module.recharge.service.RoleRechargeService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.sensitive.service.SensitiveWordService;
import com.ayjs.mxzg.gameserver.module.server.service.ServerParamService;
import com.ayjs.mxzg.message.module.clan.UpdateCrossClanListMessage;
import com.ayjs.mxzg.message.module.clan.UpdateCrossClanMessage;
import com.ayjs.mxzg.protocol.ClanGMsg;
import com.ayjs.mxzg.protocol.ClanGMsg.GReqClanCreate;
import com.ayjs.mxzg.protocol.ClanGMsg.GResClanDonateList;
import com.ayjs.mxzg.protocol.ClanGMsg.ResClanMemberData;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.ayjs.mxzg.template.constant.GameConstant;
import com.ayjs.rpc.dispatcher.MessageDispatcher;
import com.google.protobuf.GeneratedMessage;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Slf4j
@Service
public class ClanService {
    @Autowired
    private ClanDao clanDao;
    @Autowired
    private ClanBossDao clanBossDao;
    @Autowired
    private ClanMemberDao clanMemberDao;
    @Autowired
    private RoleService roleService;
    @Autowired
    private ThingService thingService;
    @Autowired
    private ClanLevelSysCache clanLevelSysCache;
    @Autowired
    private ClanBossService clanBossService;
    @Autowired
    private SystemSysCache systemSysCache;
    @Autowired
    private RoleRechargeService roleRechargeService;
    @Autowired
    private ClanWarService clanWarService;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private ServerConfig serverConfig;
    @Autowired
    private MessageDispatcher messageDispatcher;
    @Autowired
    private ServerParamService serverParamService;
    @Autowired
    private ClanMemberDonateService clanMemberDonateService;
    @Autowired
    private SensitiveWordService sensitiveWordService;

    // 需要推送给跨服的数据
    private Set<Long> sendToCrossClans = new ConcurrentHashSet<>();

    /**
     * 根据角色ID查询公会
     *
     * @param rid
     * @return
     */
    public Clan getRole2Clan(long rid) {
        Role role = roleService.getOrThrow(rid);
        if (role.getClanId() <= 0) {
            return null;
        }
        return getOrThrow(role.getClanId());
    }

    /**
     * 给公会加经验
     *
     * @param immutableThing
     * @param clan
     */
    public long addClanExp(long rid, Clan clan, List<ImmutableThing> immutableThing, GameEvent gameEvent) {
        long clanExp = 0;
        for (ImmutableThing thing : immutableThing) {
            clanExp = clanExp + thing.getItem_num();
        }
        int oldLv = clan.getClanLevel();
        synchronized (InternerPool.intern(ClanLock.CLAN_ADD_EXP_LOCK)) {
            clan.setClanExp(clan.getClanExp() + clanExp);
            CClanLevel config = null;
            while (clanLevelSysCache.getMaxLv() > clan.getClanLevel()) {
                config = clanLevelSysCache.getOrThrow(clan.getClanLevel());
                if (config.getNeed_clan_exp() > clan.getClanExp()) {
                    break;
                }
                clan.setClanLevel(clan.getClanLevel() + 1);
                clan.setClanExp(clan.getClanExp() - config.getNeed_clan_exp());
            }
        }
        updateClan(clan);
        eventBus.post(ClanExpAddEvent.of(clan.getId(), rid, clanExp, clan.getClanExp(), oldLv, clan.getClanLevel(), gameEvent));
        return clanExp;
    }


    /**
     * 更新公会
     *
     * @param clan
     */
    public void updateClan(Clan clan) {
        clanDao.update(clan);
    }

    public void updateClanList(List<Clan> list) {
        clanDao.update(list);
    }

    /**
     * 查询公会
     *
     * @param clanId
     * @return
     */
    public Clan getOrThrow(long clanId) {
        Clan clan = clanDao.get(clanId);
        Asserts.notNull(clan, ErrorCode.CLAN_NOT_EXIST.getValue(), () -> String.format("clan{%s} not found", clanId));
        return clan;
    }

    /**
     * 查询所有公会
     *
     * @return
     */
    public List<Clan> selectAll() {
        return clanDao.listAll();
    }

    /**
     * 查询公会成员列表
     *
     * @return
     */
    public List<ClanMember> selectClanMember(long clanId) {
        return clanMemberDao.selectClanMember(clanId);
    }

    public List<Long> getMemberIds(long clanId) {
        return selectClanMember(clanId).stream().map(member -> member.getRid()).collect(Collectors.toList());
    }

    /**
     * 查询成员信息
     *
     * @param clanId
     * @param rid
     * @return
     */
    public ClanMember selectClanMemberOne(long clanId, long rid) {
        ClanMember modle = null;
        List<ClanMember> list = selectClanMember(clanId);
        for (ClanMember member : list) {
            if (member.getRid() == rid) {
                modle = member;
            }
        }
        if (modle != null) {
            if (TimeDateUtil.getCurrentTimeInt() > modle.getDailyTime()) {
                modle.setDailyTime(TimeDateUtil.getTomorrowZeroTimeInt());
                modle.setTodayDonate(0);
                updateClanMember(modle);
            }
        }

        return modle;
    }

    /**
     * 删除公会成员
     *
     * @param clanMember
     */
    public void remakeClanMember(ClanMember clanMember) {
        clanMemberDao.remove(clanMember);
    }

    /**
     * 更新公会成员
     *
     * @param clanMember
     */
    public void updateClanMember(ClanMember clanMember) {
        clanMemberDao.update(clanMember);
    }


    /**
     * 创建公会
     *
     * @param clanName
     * @param clanDesc
     * @param clanIco
     * @param clanHerdId
     * @param clanHeadName
     * @return
     */
    public Clan insertClan(String clanName, String clanDesc, int clanIco, long clanHerdId,
                           String clanHeadName) {
        Clan clan = new Clan();
        clan.setClanName(clanName);
        clan.setClanDesc(clanDesc);
        clan.setCreateTime(TimeDateUtil.getCurrentTime());
        clan.setClanLevel(1);
        clan.setClanExp(0);
        clan.setClanIcon(clanIco);
        clan.setClanHeadRid(clanHerdId);
        clan.setClanHeadName(clanHeadName);
        clan.setServerId(serverConfig.getServerId());
        clanDao.add(clan);
        return clan;
    }

    /**
     * 是否重名
     *
     * @param name
     * @return
     */
    public boolean hasSameName(String name) {
        for (Clan role : clanDao.listAll()) {
            if (name.equals(role.getClanName())) {
                return true;
            }
        }
        return false;
    }

    /**
     * 增加某个公会成员信息
     *
     * @param clanId
     * @param clanName
     * @param rid
     * @param position 职位
     */
    public void insertClanMember(long clanId, String clanName, long rid, int position) {
        ClanMember clanMember = new ClanMember();
        clanMember.setRid(rid);
        clanMember.setClanId(clanId);
        clanMember.setPosition(position);
        clanMember.setJoinTime(TimeDateUtil.getCurrentTime());
        clanMemberDao.add(clanMember);
        // 修改玩家信息
        Role role = roleService.getOrThrow(rid);
        role.setClanId(clanId);
        roleService.updateRole(role);
        //删除该成员的其他公会申请
        for (Clan otherClan : this.selectAll()) {
            if (otherClan.getApplyIds().remove(rid)) {
                this.updateClan(otherClan);
                broadcastToClan(otherClan.getId(), CmdCode._7009, ClanGMsg.GResUpdateAllClanInfo.newBuilder().build());
            }
        }
        //公会成员变动事件
        eventBus.post(ClanChangeEvent.of(rid, clanId, 0l, false));
    }

    /**
     * 转换公会成员数据格式
     *
     * @param members
     * @return
     */
    public List<ResClanMemberData> transformClanMemberData(List<ClanMember> members) {
        List<ResClanMemberData> list = new ArrayList<>();
        int rank = 1;
        for (ClanMember clanMember : members) {
            ResClanMemberData.Builder model = ResClanMemberData.newBuilder();
            model.setRid(clanMember.getRid());
            model.setPosition(clanMember.getPosition());
            Role role = roleService.getOrThrow(clanMember.getRid());
            model.setPhoto(role.getHeadId());
            model.setBorderId(role.getBorderId());
            model.setLevel(role.getLevel());
            model.setNick(role.getNick());
            model.setRank(rank);
            model.setDamage(role.getFighting());
            model.setOnlineStatus(role.getOnline());
            model.setOfflineTime((int) (role.getLastOfflineTime() / 1000));
            if (clanMember.getDailyTime() < TimeDateUtil.getCurrentTimeInt()) {
                //只是显示为已经重置数据，实际的数据修改在玩家捐献的时候处理
                model.setTodayDonate(0);
            } else {
                model.setTodayDonate(clanMember.getTodayDonate());
            }
            model.setTotalDonate(clanMember.getTotalDonate());
            list.add(model.build());
            rank++;
        }
        //排序
        list.sort(Comparator.comparing(ClanGMsg.ResClanMemberData::getPosition).reversed()
                .thenComparing(ClanGMsg.ResClanMemberData::getDamage));
        return list;
    }

    /**
     * 公会创建验证
     *
     * @param role
     * @param msg
     */
    public int createClanCheck(Role role, GReqClanCreate msg) {
        if (role.getClanId() > 0) {
            return CreateClanResult.JOIN_CLAN.getType();
        }

        //韩版不作充值验证
        if (serverConfig.getServerLang() != Language.KOR.getCode()) {
            RoleRecharge roleRecharge = roleRechargeService.getRoleRecharge(role.getId());
            if (roleRecharge.getTotalRecharge() < systemSysCache.getCreateClanTotalChargeRequire()) {
                return CreateClanResult.RECHARGE.getType();
            }

        }

        for (Clan clan : selectAll()) {
            if (clan.getClanName().equals(msg.getClanName())) {
                return CreateClanResult.REPETITION_CLAN_NAME.getType();
            }
        }
        thingService.cost(role.getId(), systemSysCache.getCreateClanGem(), GameEvent.CLAN_CREATE);
        return CreateClanResult.VERIFYING_PASS.getType();
    }

    /**
     * 加入公会验证
     *
     * @param role
     * @param clanId
     */
    public void joinClanCheck(Role role, Long clanId) {

        Clan clan = getOrThrow(clanId);

        // 玩家是否已加公会
        if (role.getClanId() > 0) {

            clan.getApplyIds().remove(role.getId());
            updateClan(clan);

            //清楚本条申请并刷新前端申请列表
            ClanGMsg.GResClanReqMsgInfo.Builder builder = clanApplyList(clanId);
            for (ClanMember clanMember : selectClanMember(clanId)) {
                if (clanMember.getPosition() == ClanJobEnum.CLAN_VICE_PRESIDENT.getJobKey() || clanMember.getPosition() == ClanJobEnum.CLAN_PRESIDENT.getJobKey()) {
                    contextManager.write(clanMember.getRid(), CmdCode._7007, builder.build());
                }
            }

        }
        Asserts.isTrue(role.getClanId() == 0, ErrorCode.CLAN_NOW_JOIN.getValue(), "已加入公会不可重复申请加入，rid: " + role.getId());

        CClanLevel cClanLevel = clanLevelSysCache.getOrThrow(clan.getClanLevel());
        List<ClanMember> memberList = selectClanMember(clanId);
        Asserts.isTrue(memberList.size() < cClanLevel.getMember(), ErrorCode.CLAN_MAX_MENBER.getValue(), "该公会成员已满");

        Asserts.isTrue(clanMemberDonateService.getQuitClanTime(role.getId()) < DateTimeUtil.currentSecond(), ErrorCode.CLAN_JOIN_TIME_CD.getValue(),
                String.format("quit clan time:%s ,rid:%s", clanMemberDonateService.getQuitClanTime(role.getId()), role.getId()));

    }

    /**
     * 将玩家移除公会
     *
     * @param role
     * @param clanMember
     * @param type       0：主动退出; 1:被踢出公会;
     * @param clanId
     * @param isTrue     true:公会解散; false:公会未解散;
     */
    public void dismissClanMember(Role role, ClanMember clanMember, int type, long clanId, boolean isTrue) {
        // 删除玩家公会成员表数据
        remakeClanMember(clanMember);
        // 删除玩家公会副本排行榜数据
        Clan clan = getOrThrow(role.getClanId());
        List<ClanDungeonDamageData> list = clan.getClanDungeonDamageList().stream().filter(model -> model.getRid() != role.getId()).collect(Collectors.toList());
        clan.setClanDungeonDamageList(list);
        updateClan(clan);
        // 修改公会副本排行
        clanBossService.updateClanDamageRank(clan);
        //修改玩家公会id
        role.setClanId(0);
        roleService.updateRole(role);
        //修改退出公会时间
        if (type == 0) {
            clanMemberDonateService.updateQuitClanTime(role.getId(), DateTimeUtil.currentSecond() + systemSysCache.getClanRejoinTime());
        } else if (type == 1) {
            clanMemberDonateService.updateQuitClanTime(role.getId(), DateTimeUtil.currentSecond() + systemSysCache.getClanSecedeTime());
        }
        //发送下一次允许加入公会时间协议
        clanMemberDonateService.sendQuitClanTime(role.getId());
        //公会成员变动改变公会战力事件
        eventBus.post(ClanChangeEvent.of(role.getId(), 0l, clanId, isTrue));
    }

    /**
     * 删除公会及公会相关数据
     *
     * @param clan
     */
    public void removeClan(Clan clan) {
        //删除BOSS记录
        ClanBoss clanBoss = clanBossService.selectClanBoss(clan.getId());
        clanBossDao.remove(clanBoss);
        //删除公会
        clanDao.remove(clan);
    }

    /**
     * 增加公会历史记录
     *
     * @param clan
     * @param info_type
     * @param position
     */
    public void insertClanMsg(Clan clan, int info_type, int position, Role member, Role manager) {
        ClanMsgData clanMsg = new ClanMsgData();
        clanMsg.setInfoType(info_type);
        clanMsg.setPosition(position);
        clanMsg.setTime(TimeDateUtil.getCurrentTime());

        clanMsg.setMemberId(member == null ? 0 : member.getId());
        clanMsg.setMemberName(member == null ? "" : member.getNick());
        clanMsg.setManagerId(manager.getId());
        clanMsg.setManagerName(manager.getNick());

        clan.getClanMsgList().add(clanMsg);
        while (clan.getClanMsgList().size() > 30) {
            clan.getClanMsgList().remove(0);
        }
        updateClan(clan);
    }

    /**
     * 计算公会战力
     *
     * @param clanId
     * @return
     */
    public long clanFightingAll(long clanId) {
        Clan clan = this.getOrThrow(clanId);
        long fighting = 0;
        List<ClanMember> clanMemberList = clanMemberDao.selectClanMember(clanId);
        for (ClanMember clanMember : clanMemberList) {
            Role role = roleService.getOrThrow(clanMember.getRid());
            fighting += role.getMaxFighting();
        }
        clan.setClanFighting(fighting);
        this.updateClan(clan);
        return fighting;
    }

    /**
     * 公会捐献列表返回包
     *
     * @return
     */
    public GResClanDonateList donateList(long rid, Clan clan) {
        ClanMemberDonate clanMemberDonate = clanMemberDonateService.getDonate(rid);
        GResClanDonateList.Builder builder = GResClanDonateList.newBuilder();
        builder.setTotalDonateNum(clan.getClanDonate());
        builder.setDonateThing(clanMemberDonate.getDonateThing());
        builder.addAllTotalDonateList(clanMemberDonate.getDonateReward());
        return builder.build();
    }

    /**
     * 获取公会申请列表
     *
     * @param clanId
     * @return
     */
    public ClanGMsg.GResClanReqMsgInfo.Builder clanApplyList(long clanId) {
        ClanGMsg.GResClanReqMsgInfo.Builder builder = ClanGMsg.GResClanReqMsgInfo.newBuilder();
        Clan clan = getOrThrow(clanId);
        clan.getApplyIds().forEach(applyId -> {
            ClanGMsg.ResClanReqMsgData.Builder res = ClanGMsg.ResClanReqMsgData.newBuilder();
            Role applyRole = roleService.getOrThrow(applyId);
            res.setRoleId(applyRole.getId());
            res.setDamage(applyRole.getFighting());
            res.setLevel(applyRole.getLevel());
            res.setNick(applyRole.getNick());
            res.setPhoto(applyRole.getHeadId());
            res.setBorderId(applyRole.getBorderId());
            builder.addList(res);
        });
        return builder;
    }

    /**
     * 验证当前时间能否退出分会
     *
     * @return
     */
    public boolean clanWarRunning(long clanId) {
        return clanWarService.isDuringClanWar() && clanWarService.isJoinClanWar(clanId);
    }


    public String getClanName(Role role) {
        if (role.getClanId() <= 0) {
            return "";
        }
        Clan clan = getOrThrow(role.getClanId());
        return clan.getClanName();
    }

    /***
     * 推送变化到客户端
     * @param clanId
     */
    public void broadcastToClan(long clanId, int cmd, GeneratedMessage msg) {
        List<Long> memberIds = this.selectClanMember(clanId).stream().map(ClanMember::getRid).collect(Collectors.toList());
        contextManager.writeSome(memberIds, cmd, msg);
    }

    public void addToSendCrossList(long clanId) {
        sendToCrossClans.add(clanId);
    }

    /**
     * 发送数据给跨服
     */
    public synchronized void sendToCross() {

        Iterator<Long> iterator = sendToCrossClans.iterator();
        List<UpdateCrossClanMessage> updateList = new ArrayList<>();
        while (iterator.hasNext()) {
            Long clanId = iterator.next();
            iterator.remove();
            Clan clan = null;
            try {
                clan = getOrThrow(clanId);
            } catch (Exception e) {
                log.debug("" + clanId, e);
            }
            updateList.add(buildUpdateCrossClanMessage(clan, clanId));
        }
        if (CollectionUtil.isNotEmpty(updateList)) {
            messageDispatcher.dispatch(UpdateCrossClanListMessage.of(updateList));
        }
    }


    public UpdateCrossClanMessage buildUpdateCrossClanMessage(Clan clan, long clanId) {
        UpdateCrossClanMessage.UpdateCrossClanMessageBuilder builder = UpdateCrossClanMessage.builder();
        builder.id(clanId);
        if (clan == null) {
            builder.remove(true);
            builder.serverId(serverConfig.getServerId());
        } else {
            Role role = roleService.getOrThrow(clan.getClanHeadRid());
            builder.clanFighting(clan.getClanFighting());
            builder.clanHeadName(role.getNick());
            builder.clanIcon(clan.getClanIcon());
            builder.clanLevel(clan.getClanLevel());
            builder.createTime(clan.getCreateTime());
            builder.clanHeadRid(clan.getClanHeadRid());
            builder.clanName(clan.getClanName());
            builder.serverId(clan.getServerId());
        }
        builder.serverOpenTime(serverParamService.getServerStartTime());
        return builder.build();

    }

    /**
     * 会长转让
     */
    public void clanJob() {
        List<Clan> clanList = this.selectAll();
        List<Long> clanIds = new ArrayList<>();
        clanList.forEach(clan -> {
            Role president = roleService.getOrThrow(clan.getClanHeadRid());
            //转让会长
            if (DateTimeUtil.millisTime() > getOnlineTime(president, ClanConst.CLAN_MAKE_OVER_TIME)) {

                ClanMember newPresident = this.selectClanMember(clan.getId()).stream().filter(member -> {
                    Role memberRole = roleService.getOrThrow(member.getRid());
                    return DateTimeUtil.millisTime() <= getOnlineTime(memberRole, ClanConst.CLAN_MEMBER_TIME);
                }).min(clanMemberComparator).orElse(null);

                if (newPresident != null) {
                    Role role = roleService.getOrThrow(newPresident.getRid());
                    //更新公会
                    synchronized (InternerPool.intern(ClanLock.CLAN_CHANGE_LOCK, clan.getId())) {
                        clan.setClanHeadRid(role.getId());
                        this.updateClan(clan);
                        //操作的公会
                        clanIds.add(clan.getId());
                        //更改成员职位
                        ClanMember clanMember = this.selectClanMemberOne(clan.getId(), role.getId());
                        clanMember.setPosition(ClanJobEnum.CLAN_PRESIDENT.getJobKey());
                        this.updateClanMember(clanMember);

                        clanMember = this.selectClanMemberOne(clan.getId(), president.getId());
                        clanMember.setPosition(ClanJobEnum.CLAN_MEMBER.getJobKey());
                        this.updateClanMember(clanMember);
                        //增加公会日志
                        this.insertClanMsg(clan, ClanConstant.CLAN_JOB, newPresident.getPosition(), president, role);
                    }
                }
            }
        });
        for (long clanId : clanIds) {
            this.broadcastToClan(clanId, CmdCode._7009, ClanGMsg.GResUpdateAllClanInfo.newBuilder().build());
        }
    }

    private long getOnlineTime(Role role, int time) {
        long onlineTime = Math.max(role.getLastOfflineTime(), role.getLastLoginTime());
        return onlineTime + time * TimeDateUtil.ONESECOND;
    }

    private Comparator<ClanMember> clanMemberComparator = new Comparator<ClanMember>() {
        @Override
        public int compare(ClanMember o1, ClanMember o2) {
            int result = Integer.compare(o1.getPosition(), o2.getPosition());
            if (result == 0) {
                Role memberRole1 = roleService.getOrThrow(o1.getRid());
                Role memberRole2 = roleService.getOrThrow(o2.getRid());
                result = Long.compare(memberRole2.getFighting(), memberRole1.getFighting());
            }
            return result;
        }
    };

    /**
     * 公会名称验证
     *
     * @param clanName
     */
    public void clanCheckNick(String clanName, Role role) {

        //长度
        int size = StringUtil.getShowLength(clanName);

        //公会名字太长
        Asserts.isTrue(size >= 1 && size <= systemSysCache.getClanNameLength(),
                ErrorCode.CLAN_NAME_TOO_LONG.getValue(), () -> String.format("clan name:%s", clanName));

        //判断公会名字是否有特殊字符
        Asserts.isTrue(GameConstant.NAME_PATTERN.matcher(clanName).matches(), ErrorCode.CLAN_NAME_UNAVAILABLE.getValue(),
                () -> String.format("商会名格式不对!name:%s", clanName));

        // 敏感字符验证
        Asserts.isTrue(sensitiveWordService.wordCanUse(clanName, role), ErrorCode.CLAN_NAME_UNAVAILABLE.getValue(),
                () -> String.format("clan name:%s contains sensitive word :%s", clanName,
                        sensitiveWordService.findConfigSensitiveWord(clanName, role)));

        //是否重名
        /*if (clanService.hasSameName(clanName)) {
            playerContext.writeError(ErrorCode.CLAN_REPEA_NAME, clanName);
            return;
        }*/
        Asserts.isTrue(!this.hasSameName(clanName), ErrorCode.CLAN_REPEA_NAME.getValue(),
                () -> StrUtil.format("公会名字重复 clanName:{}", clanName));

        /*Asserts.isTrue(!clan.getClanName().equals(clanName), ErrorCode.CLAN_CHANGE_OF_NAME.getValue(),
                () -> StrUtil.format("改名前后昵称相同:{}", clan.getClanName()));*/

        // 屏蔽字过滤
        Asserts.isTrue(sensitiveWordService.checkMaskedWord(clanName, role),ErrorCode.ROLE_NICK_EXIST_MASKED_WORD.getValue(),
                String.format("工会昵称{%s}存在屏蔽字", clanName));
    }
}
