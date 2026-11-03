package com.ayjs.mxzg.gameserver.module.clan.handler;


import cn.hutool.core.util.StrUtil;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.InternerPool;
import com.ayjs.mxzg.common.util.RandomUtil;
import com.ayjs.mxzg.common.util.StringUtil;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.ClanDonateSysCache;
import com.ayjs.mxzg.config.excel.cache.ClanLevelSysCache;
import com.ayjs.mxzg.config.excel.cache.ClandonateactivitySysCache;
import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.config.excel.entity.CClanDonate;
import com.ayjs.mxzg.config.excel.entity.CClanLevel;
import com.ayjs.mxzg.config.excel.entity.CClandonateactivity;
import com.ayjs.mxzg.config.struct.ClanJobEnum;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.clan.constant.ClanConstant;
import com.ayjs.mxzg.gameserver.module.clan.constant.ClanLock;
import com.ayjs.mxzg.gameserver.module.clan.constant.CreateClanResult;
import com.ayjs.mxzg.gameserver.module.clan.domain.Clan;
import com.ayjs.mxzg.gameserver.module.clan.domain.ClanMember;
import com.ayjs.mxzg.gameserver.module.clan.domain.ClanMemberDonate;
import com.ayjs.mxzg.gameserver.module.clan.event.ClanCreateEvent;
import com.ayjs.mxzg.gameserver.module.clan.event.ClanDonateEvent;
import com.ayjs.mxzg.gameserver.module.clan.event.ClanEditNickEvent;
import com.ayjs.mxzg.gameserver.module.clan.event.ClanJobChangeEvent;
import com.ayjs.mxzg.gameserver.module.clan.event.ClanMemberJoinEvent;
import com.ayjs.mxzg.gameserver.module.clan.service.ClanMemberDonateService;
import com.ayjs.mxzg.gameserver.module.clan.service.ClanService;
import com.ayjs.mxzg.gameserver.module.clan.struct.ClanMsgData;
import com.ayjs.mxzg.gameserver.module.role.constant.EntryType;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.sensitive.service.SensitiveWordService;
import com.ayjs.mxzg.protocol.ClanGMsg;
import com.ayjs.mxzg.protocol.ClanGMsg.GReqClanChangInfo;
import com.ayjs.mxzg.protocol.ClanGMsg.GReqClanChangePos;
import com.ayjs.mxzg.protocol.ClanGMsg.GReqClanCreate;
import com.ayjs.mxzg.protocol.ClanGMsg.GReqClanDonate;
import com.ayjs.mxzg.protocol.ClanGMsg.GReqClanDonateList;
import com.ayjs.mxzg.protocol.ClanGMsg.GReqClanInfo;
import com.ayjs.mxzg.protocol.ClanGMsg.GReqClanJoin;
import com.ayjs.mxzg.protocol.ClanGMsg.GReqClanMsgInfo;
import com.ayjs.mxzg.protocol.ClanGMsg.GReqClanQuit;
import com.ayjs.mxzg.protocol.ClanGMsg.GReqClanReqAgree;
import com.ayjs.mxzg.protocol.ClanGMsg.GReqClanReqMsgInfo;
import com.ayjs.mxzg.protocol.ClanGMsg.GReqClanSearch;
import com.ayjs.mxzg.protocol.ClanGMsg.GReqClanTotalDonateReward;
import com.ayjs.mxzg.protocol.ClanGMsg.GResClanChangInfo;
import com.ayjs.mxzg.protocol.ClanGMsg.GResClanChangePos;
import com.ayjs.mxzg.protocol.ClanGMsg.GResClanCreate;
import com.ayjs.mxzg.protocol.ClanGMsg.GResClanJoin;
import com.ayjs.mxzg.protocol.ClanGMsg.GResClanQuit;
import com.ayjs.mxzg.protocol.ClanGMsg.GResClanReqAgree;
import com.ayjs.mxzg.protocol.ClanGMsg.GResClanReqMsgInfo;
import com.ayjs.mxzg.protocol.ClanGMsg.GResClanSearch;
import com.ayjs.mxzg.protocol.ClanGMsg.GResClanTotalDonateReward;
import com.ayjs.mxzg.protocol.ClanGMsg.GResUpdateAllClanInfo;
import com.ayjs.mxzg.protocol.ClanGMsg.ResClanSearchData;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.ayjs.mxzg.template.constant.GameConstant;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.regex.Pattern;

/**
 * @author HYX
 */

@Controller
public class ClanHandler extends ProtocolHandler {

    /**
     * 中文，符号，数字，空白符
     * \p{Graph} 字母数字标点符号
     * \p{Space} 空白字符
     * \p{Blank} 空格制表符
     * \p{P} 中文标点符
     * 已经不用了\u4e00-\u9fef 汉字
     * \u1100-\uFE4F 包含中日韩字符，还有些特殊字符
     */
    private static final Pattern CLAN_DESC_PATTERN = Pattern.compile("[\\p{Graph}\\p{Space}\\p{Blank}\\p{P}\\u1100-\\uFE4F]+");

    @Autowired
    private ClanService clanService;
    @Autowired
    private RoleService roleService;
    @Autowired
    private ClanDonateSysCache clanDonateSysCache;
    @Autowired
    private ClandonateactivitySysCache clandonateactivitySysCache;
    @Autowired
    private ThingService thingService;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private SensitiveWordService sensitiveWordService;
    @Autowired
    private ClanLevelSysCache clanLevelSysCache;
    @Autowired
    private ClanMemberDonateService clanMemberDonateService;
    @Autowired
    private SystemSysCache systemSysCache;

    private final static int CLAN_LIST_NUMBER = 10;

    /**
     * 获取上一次退出公会的时间
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._7000)
    public void quitClanTime(PlayerContext playerContext, ClanGMsg.GReqQuitClanTime msg) {
        clanMemberDonateService.sendQuitClanTime(playerContext.getId());
    }

    /**
     * 公会信息
     */
    @CMD(id = CmdCode._7001)
    public void clanInfo(PlayerContext playerContext, GReqClanInfo msg) {
        Role role = roleService.getOrThrow(playerContext.getId());
        ClanGMsg.GResClanInfo.Builder builder = ClanGMsg.GResClanInfo.newBuilder();
        if (role.getClanId() > 0) {
            Clan clan = clanService.getOrThrow(role.getClanId());
            builder.setClanId(clan.getId());
            builder.setClanPhoto(clan.getClanIcon());
            builder.setClanLevel(clan.getClanLevel());
            builder.setClanExp((int) clan.getClanExp());
            builder.setClanDesc(clan.getClanDesc());
            builder.setClanName(clan.getClanName());
            //公会成员信息
            List<ClanGMsg.ResClanMemberData> list = clanService.transformClanMemberData(clanService.selectClanMember(role.getClanId()));
            builder.addAllList(list);
        }
        playerContext.write(CmdCode._7001, builder.build());
    }

    /**
     * 公会创建
     */
    @CMD(id = CmdCode._7002, entry = EntryType.MAIN_CLAN)
    public void clanCreate(PlayerContext playerContext, GReqClanCreate msg) {
        GResClanCreate.Builder builder = GResClanCreate.newBuilder();

        String clanName = msg.getClanName().trim();
        clanName = clanName.replaceAll("\r|\n", "");
        Asserts.isTrue(StringUtils.isNotBlank(clanName), ErrorCode.CLAN_NAME_UNAVAILABLE.getValue(),
                () -> String.format("clan name is blank"));

        /*Asserts.isTrue(clanService.getQuitClanTime(playerContext.getId()) + systemSysCache.getClanRejoinTime()
                        < DateTimeUtil.currentSecond(), ErrorCode.CLAN_JOIN_TIME_CD.getValue(),
                String.format("quit clan time:%s ,rid:%s", clanService.getQuitClanTime(playerContext.getId()), playerContext.getId()));*/

        long rid = playerContext.getId();
        Role role = roleService.getOrThrow(rid);

        //长度
        int size = StringUtil.getShowLength(clanName);
        final String clanNameTemp = clanName;
        Asserts.isTrue(size >= 1 && size <= systemSysCache.getClanNameLength(),
                ErrorCode.CLAN_NAME_TOO_LONG.getValue(), () -> String.format("clan name:%s", clanNameTemp));

        Asserts.isTrue(GameConstant.NAME_PATTERN.matcher(clanName).matches(), ErrorCode.CLAN_NAME_UNAVAILABLE.getValue(),
                () -> String.format("商会名格式不对!name:%s", clanNameTemp));

        // 敏感字符验证
        Asserts.isTrue(sensitiveWordService.wordCanUse(clanName, role), ErrorCode.CLAN_NAME_UNAVAILABLE.getValue(),
                () -> String.format("clan name:%s contains sensitive word :%s", clanNameTemp,
                        sensitiveWordService.findConfigSensitiveWord(clanNameTemp, role)));

        // 屏蔽字过滤
        Asserts.isTrue(sensitiveWordService.checkMaskedWord(clanName, role),ErrorCode.ROLE_NICK_EXIST_MASKED_WORD.getValue(),
                String.format("工会名称{%s}存在屏蔽字", clanName));

        String clanNotice = msg.getClanNotice();
        if (StringUtils.isNotBlank(clanNotice)) {
            Asserts.isTrue(sensitiveWordService.wordCanUse(clanNotice, role), ErrorCode.CLAN_NOTICE_UNAVAILABLE.getValue(),
                    String.format("clan notice:%s contains sensitive word :%s", clanNotice,
                            sensitiveWordService.findConfigSensitiveWord(clanNotice, role)));

            Asserts.isTrue(CLAN_DESC_PATTERN.matcher(clanNotice).matches(), ErrorCode.CLAN_NOTICE_UNAVAILABLE.getValue(),
                    String.format("clan notice contains Special characters !notice:%s", clanNotice));

            clanNotice = sensitiveWordService._filterSensitiveWord(clanNotice, role);
        }


        //创建公会验证
        int code = clanService.createClanCheck(role, msg);
        if (code != CreateClanResult.VERIFYING_PASS.getType()) {//验证不通过
            builder.setErrorCode(code);
            playerContext.write(CmdCode._7002, builder.build());

            if (code == CreateClanResult.JOIN_CLAN.getType()) {
                //广播公会变化
                clanService.broadcastToClan(role.getClanId(), CmdCode._7009, GResUpdateAllClanInfo.newBuilder().build());
            }

            return;
        }
        // 创建公会
        Clan clan = clanService.insertClan(clanName, clanNotice, msg.getClanPhoto(), rid, role.getNick());
        // 记录新公会成员信息
        clanService.insertClanMember(clan.getId(), clan.getClanName(), rid, ClanJobEnum.CLAN_PRESIDENT.getJobKey());
        builder.setErrorCode(0);
        builder.setClanId(clan.getId());
        playerContext.write(CmdCode._7002, builder.build());

        eventBus.post(ClanCreateEvent.of(rid, clan.getId()));
    }

    /**
     * 公会搜索
     */
    @CMD(id = CmdCode._7003)
    public void clanSearch(PlayerContext playerContext, GReqClanSearch msg) {
        GResClanSearch.Builder builder = GResClanSearch.newBuilder();
        builder.setSearchType(msg.getSearchType());
        List<Clan> clanList = new ArrayList<>();

        List<Clan> allClan = clanService.selectAll();
        // 不是模糊查找，优先给可以进入的工会，有模糊条件查找不过滤是否可以进入
        if (StringUtils.isBlank(msg.getClanName())) {
            List<Clan> fullClan = new ArrayList<>();
            for (Clan clan : allClan) {
                CClanLevel cClanLevel = clanLevelSysCache.getOrThrow(clan.getClanLevel());
                List<ClanMember> memberList = clanService.selectClanMember(clan.getId());
                if (memberList.size() < cClanLevel.getMember()) {
                    clanList.add(clan);
                } else {
                    fullClan.add(clan);
                }
            }
            if (clanList.size() < CLAN_LIST_NUMBER) {
                clanList.addAll(RandomUtil.randomList(fullClan, CLAN_LIST_NUMBER - clanList.size()));
            }
        } else {
            for (Clan clan : allClan) {
                if (clan.getClanName().contains(msg.getClanName())) {
                    clanList.add(clan);
                }
            }
        }
        clanList = RandomUtil.randomList(clanList, CLAN_LIST_NUMBER);
        Collections.shuffle(clanList);
        clanList.forEach(clan -> {
            ResClanSearchData.Builder model = ResClanSearchData.newBuilder();
            model.setClanId(clan.getId());
            model.setClanName(clan.getClanName());
            model.setClanLevel(clan.getClanLevel());
            model.setClanPhoto(clan.getClanIcon());
            model.setClanMemberNum(clanService.selectClanMember(clan.getId()).size());
            builder.addList(model);
        });
        playerContext.write(CmdCode._7003, builder.build());
    }

    /**
     * 申请加入公会
     */
    @CMD(id = CmdCode._7004, entry = EntryType.MAIN_CLAN)
    public void applyClan(PlayerContext playerContext, GReqClanJoin msg) {

        Asserts.isTrue(clanMemberDonateService.getQuitClanTime(playerContext.getId()) < DateTimeUtil.currentSecond(), ErrorCode.CLAN_JOIN_TIME_CD.getValue(),
                String.format("quit clan time:%s ,rid:%s", clanMemberDonateService.getQuitClanTime(playerContext.getId()), playerContext.getId()));

        GResClanJoin.Builder builder = GResClanJoin.newBuilder();
        builder.setClanId(msg.getClanId());
        Role role = roleService.getOrThrow(playerContext.getId());


        //申请加入公会验证
        clanService.joinClanCheck(role, msg.getClanId());

        //是否有该公会的申请记录
        Clan clan = clanService.getOrThrow(msg.getClanId());
        if (clan.getApplyIds().contains(role.getId())) {
            builder.setJoinType(1);
            playerContext.write(CmdCode._7004, builder.build());
            return;
        }

        //添加进公会申请表
        clan.getApplyIds().add(role.getId());
        clanService.updateClan(clan);
        builder.setJoinType(1);
        playerContext.write(CmdCode._7004, builder.build());

        //广播公会变化
        clanService.broadcastToClan(msg.getClanId(), CmdCode._7009, GResUpdateAllClanInfo.newBuilder().build());
    }


    /**
     * 退出公会
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._7005)
    public void clanQuit(PlayerContext playerContext, GReqClanQuit msg) {
        GResClanQuit.Builder builder = GResClanQuit.newBuilder();
        Role role = roleService.getOrThrow(playerContext.getId());
        long clanId = role.getClanId();
        Asserts.isTrue(clanId != 0, ErrorCode.CLAN_NOT_EXIST.getValue(), "未加入任何公会。");

        Asserts.isTrue(!clanService.clanWarRunning(clanId), ErrorCode.CLAN_BATTLE_RUNNING.getValue(), "Can't quit the clan");

        Clan clan = clanService.getOrThrow(clanId);
        synchronized (InternerPool.intern(ClanLock.CLAN_CHANGE_LOCK, clan.getId())) {
            ClanMember clanMember = clanService.selectClanMemberOne(role.getClanId(), role.getId());
            int size = clanService.selectClanMember(role.getClanId()).size();
            if (size == 1) {//一个人的时候,不判定职位
                //将玩家踢出公会
                clanService.dismissClanMember(role, clanMember, 0, clanId, true);
                clanService.removeClan(clanService.getOrThrow(clanId));
            } else {
                if (clanMember.getPosition() == ClanJobEnum.CLAN_PRESIDENT.getJobKey()) {//公会长不能退出公会
                    playerContext.writeError(ErrorCode.CLAN_PRESIDENT_NOT_QUIT);
                    return;
                }
                //将玩家踢出公会
                clanService.dismissClanMember(role, clanMember, 0, clanId, false);
                //增加公会历史记录
                clanService.insertClanMsg(clan, ClanConstant.CLAN_EXIT,
                        0, null, role);
            }
        }

        builder.setQuitType(0);
        playerContext.write(CmdCode._7005, builder.build());
        clanService.broadcastToClan(clanId, CmdCode._7009, GResUpdateAllClanInfo.newBuilder().build());
    }

    /**
     * 公会日志列表
     */
    @CMD(id = CmdCode._7006)
    public void clanLogList(PlayerContext playerContext, GReqClanMsgInfo msg) {
        Role role = roleService.getOrThrow(playerContext.getId());
        if (role.getClanId() != 0) {
            ClanGMsg.GResClanMsgInfo.Builder builder = ClanGMsg.GResClanMsgInfo.newBuilder();
            Clan clan = clanService.getOrThrow(role.getClanId());
            for (ClanMsgData model : clan.getClanMsgList()) {
                ClanGMsg.ResClanMsgInfoData.Builder res = ClanGMsg.ResClanMsgInfoData.newBuilder();
                res.setManagerId(model.getManagerId());
                res.setManagerName(model.getManagerName());
                res.setInfoType(model.getInfoType());
                res.setMemberId(model.getMemberId());
                res.setMemberName(model.getMemberName());
                res.setTime(TimeDateUtil.getCurrentTimeInt(model.getTime()));
                res.setValue(model.getPosition());
                builder.addList(res);
            }
            playerContext.write(CmdCode._7006, builder.build());
        }
    }

    /**
     * 公会申请列表
     */
    @CMD(id = CmdCode._7007)
    public void clanApplyList(PlayerContext playerContext, GReqClanReqMsgInfo msg) {
        GResClanReqMsgInfo.Builder builder = GResClanReqMsgInfo.newBuilder();
        Role role = roleService.getOrThrow(playerContext.getId());
        if (role.getClanId() > 0) {
            builder = clanService.clanApplyList(role.getClanId());
        }
        playerContext.write(CmdCode._7007, builder.build());
    }

    /**
     * 公会申请处理
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._7008)
    public void clanReqAgree(PlayerContext playerContext, GReqClanReqAgree msg) {
        GResClanReqAgree.Builder builder = GResClanReqAgree.newBuilder();
        Role role = roleService.getOrThrow(playerContext.getId());
        Clan clan = clanService.getOrThrow(role.getClanId());
        ClanMember clanMember = clanService.selectClanMemberOne(role.getClanId(), role.getId());

        Asserts.isTrue(clanMember.getPosition() != ClanJobEnum.CLAN_MEMBER.getJobKey(), ErrorCode.CLAN_POSITION.getValue(),
                "普通成员不具有处理申请权限 ");

        Role role2 = roleService.getOrThrow(msg.getMemberId());
        synchronized (InternerPool.intern(ClanLock.CLAN_CHANGE_LOCK, clan.getId())) {
            synchronized (InternerPool.intern(ClanLock.CLAN_ROLE_LOCK, role2.getId())) {
                Asserts.notNull(clan.getApplyIds().contains(role2.getId()), ErrorCode.CLAN_POSITION.getValue(), "玩家没有申请改操作");
                if (msg.getAgreeStatus() == 1) {
                    //加入公会验证
                    clanService.joinClanCheck(role2, role.getClanId());
                    //加入公会
                    clanService.insertClanMember(role.getClanId(), clan.getClanName(), role2.getId(),
                            ClanJobEnum.CLAN_MEMBER.getJobKey());
                    //增加公会历史记录
                    clanService.insertClanMsg(clan, ClanConstant.CLAN_APPLY, clanMember.getPosition(), role2, role);
                    //向申请者发送加入成功builder
                    builder.setClanId(role.getClanId());
                    contextManager.write(role2.getId(), CmdCode._7008, builder.build());

                    eventBus.post(ClanMemberJoinEvent.of(role2.getId(), clan.getId()));
                }
                clan.getApplyIds().remove(role2.getId());
                clanService.updateClan(clan);
            }
        }

        ClanGMsg.GResClanAgree.Builder builder2 = ClanGMsg.GResClanAgree.newBuilder();
        builder2.setStatus(msg.getAgreeStatus());
        builder2.setNick(role2.getNick());
        playerContext.write(CmdCode._7012, builder2.build());

        clanService.broadcastToClan(role.getClanId(), CmdCode._7009, GResUpdateAllClanInfo.newBuilder().build());

    }

    /**
     * 公会宣言修改
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._7010)
    public void clanChangInfo(PlayerContext playerContext, GReqClanChangInfo msg) {
        GResClanChangInfo.Builder builder = GResClanChangInfo.newBuilder();
        Role role = roleService.getOrThrow(playerContext.getId());
        ClanMember clanMember = clanService.selectClanMemberOne(role.getClanId(), role.getId());
        Asserts.isTrue(clanMember.getPosition() != ClanJobEnum.CLAN_MEMBER.getJobKey(), ErrorCode.CLAN_POSITION.getValue(),
                "普通成员不具有修改公会宣言权根");
        // 验证敏感字符
        String clanNotice = msg.getClanDesc();

        if (StringUtils.isNotBlank(clanNotice)) {

            Asserts.isTrue(sensitiveWordService.wordCanUse(clanNotice, role), ErrorCode.CLAN_NOTICE_UNAVAILABLE.getValue(),
                    String.format("clan notice:%s contains sensitive word :%s", clanNotice,
                            sensitiveWordService.findConfigSensitiveWord(clanNotice, role)));

            Asserts.isTrue(CLAN_DESC_PATTERN.matcher(clanNotice).matches(), ErrorCode.CLAN_NOTICE_UNAVAILABLE.getValue(),
                    String.format("clan notice contains Special characters !notice:%s", clanNotice));

            clanNotice = sensitiveWordService._filterSensitiveWord(clanNotice, role);
        }


        Clan clan = clanService.getOrThrow(role.getClanId());
        clan.setClanDesc(clanNotice);
        clan.setClanIcon(msg.getClanPhoto());
        clanService.updateClan(clan);
        playerContext.write(CmdCode._7010, builder.build());

        clanService.broadcastToClan(role.getClanId(), CmdCode._7009, GResUpdateAllClanInfo.newBuilder().build());
    }

    /**
     * 升职或降职操作
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._7011)
    public void clanChangePos(PlayerContext playerContext, GReqClanChangePos msg) {
        GResClanChangePos.Builder builder = GResClanChangePos.newBuilder();
        Role manager = roleService.getOrThrow(playerContext.getId());
        Role otherRole = roleService.getOrThrow(msg.getMemberId());
        long clanId = manager.getClanId();
        synchronized (InternerPool.intern(ClanLock.CLAN_CHANGE_LOCK, manager.getId())) {
            Asserts.isTrue(manager.getClanId() == otherRole.getClanId(),
                    ErrorCode.CLAN_NOT_EXIST.getValue(), String.format("不在同一个公会{%s},{%s}", manager.getClanId(), otherRole.getClanId()));
            Clan clan = clanService.getOrThrow(clanId);
            Asserts.notNull(clan, ErrorCode.CLAN_NOT_EXIST.getValue(), "公会不存在");

            ClanMember managerMember = clanService.selectClanMemberOne(clanId, manager.getId());
            //被操作者成员信息
            ClanMember otherMember = clanService.selectClanMemberOne(clanId, msg.getMemberId());
            //所有公会成员
            List<ClanMember> memberList = clanService.selectClanMember(clanId);
            //公会
            //操作验证
            if (managerMember.getPosition() == ClanJobEnum.CLAN_MEMBER.getJobKey()) {
                //不是会长或副会长不具有此权限
                builder.setStatus(ClanOperatorStatus.FIAR.getType());
                playerContext.write(CmdCode._7011, builder.build());
                return;
            }
            if (otherMember.getPosition() == ClanJobEnum.CLAN_PRESIDENT.getJobKey() ||
                    (otherMember.getPosition() == managerMember.getPosition())) {
                //被操作者是会长或是同级操作
                builder.setStatus(ClanOperatorStatus.FIAR.getType());
                playerContext.write(CmdCode._7011, builder.build());
                return;
            }
            if ((msg.getType() == ClanOperatorType.RISE.getType() || msg.getType() == ClanOperatorType.DOWN.getType()) &&
                    managerMember.getPosition() != ClanJobEnum.CLAN_PRESIDENT.getJobKey()) {
                //只有会长有升降职权限
                builder.setStatus(ClanOperatorStatus.FIAR.getType());
                playerContext.write(CmdCode._7011, builder.build());
                return;
            }
            //执行操作
            if (msg.getType() == ClanOperatorType.KICK_OUT.getType()) {//踢人操作
                Asserts.isTrue(!clanService.clanWarRunning(clanId), ErrorCode.CLAN_BATTLE_RUNNING.getValue(), "Can't quit the clan");
                //将玩家踢出公会
                clanService.dismissClanMember(otherRole, otherMember, 1, clanId, false);
                //公会历史记录
                clanService.insertClanMsg(clan, ClanConstant.CLAN_KICK_OUT, managerMember.getPosition(),
                        otherRole, manager);
                builder.setStatus(ClanOperatorStatus.BE_KICK_OUT.getType());
                contextManager.write(otherRole.getId(), CmdCode._7011, builder.build());
            } else if (msg.getType() == ClanOperatorType.RISE.getType()) {//升职
                if (otherMember.getPosition() == ClanJobEnum.CLAN_MEMBER.getJobKey()) {
                    //副公长人数
                    int vicePresidentNum = (int) memberList.stream().filter(entity -> entity.getPosition() == ClanJobEnum.CLAN_VICE_PRESIDENT.getJobKey()).count();

                    //副会长人数不能超过大值
                    CClanLevel cClanLevel = clanLevelSysCache.getOrThrow(clan.getClanLevel());
                    if (vicePresidentNum >= cClanLevel.getLeader_num()) {
                        builder.setStatus(ClanOperatorStatus.POS_NUM_MAX.getType());
                        playerContext.write(CmdCode._7011, builder.build());
                        return;
                    } else {//升职
                        otherMember.setPosition(ClanJobEnum.CLAN_VICE_PRESIDENT.getJobKey());
                        clanService.updateClanMember(otherMember);
                    }
                    eventBus.post(ClanJobChangeEvent.of(clanId, playerContext.getId(), msg.getMemberId(),
                            ClanJobEnum.CLAN_MEMBER, ClanJobEnum.CLAN_VICE_PRESIDENT, DateTimeUtil.currentSecond()));
                } else if (otherMember.getPosition() == ClanJobEnum.CLAN_VICE_PRESIDENT.getJobKey()) {
                    //副会长升会长。会长降为副会长
                    managerMember.setPosition(ClanJobEnum.CLAN_VICE_PRESIDENT.getJobKey());
                    clanService.updateClanMember(managerMember);
                    otherMember.setPosition(ClanJobEnum.CLAN_PRESIDENT.getJobKey());
                    clanService.updateClanMember(otherMember);
                    //修改公会信息
                    clan.setClanHeadRid(otherRole.getId());
                    clan.setClanHeadName(otherRole.getNick());
                    clanService.updateClan(clan);

                    eventBus.post(ClanJobChangeEvent.of(clanId, playerContext.getId(), msg.getMemberId(),
                            ClanJobEnum.CLAN_VICE_PRESIDENT, ClanJobEnum.CLAN_PRESIDENT, DateTimeUtil.currentSecond()));

                    eventBus.post(ClanJobChangeEvent.of(clanId, playerContext.getId(), playerContext.getId(),
                            ClanJobEnum.CLAN_PRESIDENT, ClanJobEnum.CLAN_VICE_PRESIDENT, DateTimeUtil.currentSecond()));
                }
                //公会历史记录
                clanService.insertClanMsg(clan, ClanConstant.CLAN_PROMOTION, otherMember.getPosition(),
                        otherRole, manager);
            } else if (msg.getType() == ClanOperatorType.DOWN.getType()) {//降职
                otherMember.setPosition(ClanJobEnum.CLAN_MEMBER.getJobKey());
                clanService.updateClanMember(otherMember);
                //公会历史记录
                clanService.insertClanMsg(clan, ClanConstant.CLAN_DEMOTION, otherMember.getPosition(), otherRole,
                        manager);

                eventBus.post(ClanJobChangeEvent.of(clanId, playerContext.getId(), msg.getMemberId(),
                        ClanJobEnum.CLAN_VICE_PRESIDENT, ClanJobEnum.CLAN_MEMBER, DateTimeUtil.currentSecond()));
            }
        }
        //操作成功
        builder.setStatus(1);
        playerContext.write(CmdCode._7011, builder.build());

        clanService.broadcastToClan(clanId, CmdCode._7009, GResUpdateAllClanInfo.newBuilder().build());
    }

    /**
     * 公会捐献列表
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._7041)
    public void clanDonateList(PlayerContext playerContext, GReqClanDonateList msg) {
        Role role = roleService.getOrThrow(playerContext.getId());
        Clan clan = clanService.getOrThrow(role.getClanId());
        Asserts.notNull(clan, ErrorCode.CLAN_NOT_EXIST.getValue(), "公会不存在");
        playerContext.write(CmdCode._7041, clanService.donateList(playerContext.getId(), clan));
    }


    /**
     * 捐献
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._7042)
    public void clanDonate(PlayerContext playerContext, GReqClanDonate msg) {
        CClanDonate cModel = clanDonateSysCache.getOrThrow(msg.getOrderType());
        Asserts.isTrue(cModel != null, ErrorCode.CONFIG_DATA_ERROR.getValue(), "配置信息为空：" + msg.getOrderType());

        Role role = roleService.getOrThrow(playerContext.getId());
        ClanMemberDonate clanMemberDonate = clanMemberDonateService.getDonate(playerContext.getId());

        Asserts.isTrue(clanMemberDonate.getDonateThing() == 0, ErrorCode.CLAN_DONATE.getValue(), "今日已经捐献!");

        Clan clan = clanService.getOrThrow(role.getClanId());
        Asserts.notNull(clan, ErrorCode.CLAN_NOT_EXIST.getValue(), "公会不存在");

        ClanMember clanMember = clanService.selectClanMemberOne(clan.getId(), playerContext.getId());
        Asserts.notNull(clanMember, ErrorCode.CLAN_NOT_JOIN.getValue(), "您还没有加入公会");

        //扣钱
        thingService.cost(role.getId(), cModel.getCost_res(), GameEvent.CLAN_DONATE);

        clanMemberDonate.setDonateThing(msg.getOrderType());
        clanMemberDonateService.updateDonate(clanMemberDonate);

        clanMember.setTodayDonate(cModel.getDonate_exp_gain());
        clanMember.setTotalDonate(clanMember.getTotalDonate() + cModel.getDonate_exp_gain());
        clanService.updateClanMember(clanMember);

        synchronized (InternerPool.intern(ClanLock.CLAN_DONATE_LOCK, clan.getId())) {
            //更新公会
            clan.setClanDonate(clan.getClanDonate() + cModel.getDonate_exp_gain());
            thingService.add(role.getId(), cModel.getClan_exp_gain(), GameEvent.CLAN_DONATE, NoticeType.TIPS);
            //增加公会历史记录
            clanService.insertClanMsg(clan, ClanConstant.CLAN_DONATE, msg.getOrderType(), null, role);
        }
        //领取奖励
        thingService.add(role.getId(), cModel.getReward(), GameEvent.CLAN_DONATE, NoticeType.TIPS);

        //向在线的公会成员刷新捐献列表
        List<ClanMember> list = clanService.selectClanMember(clan.getId());
        for (ClanMember model : list) {
            contextManager.write(model.getRid(), CmdCode._7041, clanService.donateList(model.getRid(), clan));
        }

        //广播公会变化
        clanService.broadcastToClan(role.getClanId(), CmdCode._7009, GResUpdateAllClanInfo.getDefaultInstance());

        eventBus.post(ClanDonateEvent.of(role.getId()));
    }

    /**
     * 捐献总次数领奖
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._7043)
    public void clanTotalDonateReward(PlayerContext playerContext, GReqClanTotalDonateReward msg) {
        CClandonateactivity cModel = clandonateactivitySysCache.getOrThrow(msg.getRewardIdx());

        Role role = roleService.getOrThrow(playerContext.getId());
        Clan clan = clanService.getOrThrow(role.getClanId());
        Asserts.notNull(clan, ErrorCode.CLAN_NOT_EXIST.getValue(), "公会不存在");

        Asserts.isTrue(clan.getClanDonate() >= cModel.getDonate_times(), ErrorCode.CLAN_DONATE_BOX.getValue()
                , "公会捐献宝箱开启条件未到达, boxId :" + msg.getRewardIdx());

        ClanMemberDonate clanMemberDonate = clanMemberDonateService.getDonate(playerContext.getId());
        Asserts.isTrue(!clanMemberDonate.getDonateReward().contains(cModel.getIdx()), ErrorCode.CLAN_DONATE_BOS_REPEA.getValue(), "公会捐献宝箱重复领取");

        clanMemberDonate.getDonateReward().add(cModel.getIdx());
        clanMemberDonateService.updateDonate(clanMemberDonate);
        //领取奖励
        thingService.add(role.getId(), cModel.getReward(), GameEvent.CLAN_DONATE_BOX);

        playerContext.write(CmdCode._7043, GResClanTotalDonateReward.getDefaultInstance());
    }


    /**
     * 公会改名
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._7054)
    public void renameRole(PlayerContext playerContext, ClanGMsg.GReqClanRenamingCard msg) {
        ClanGMsg.GResClanRenamingCard.Builder builder = ClanGMsg.GResClanRenamingCard.newBuilder();
        Role role = roleService.getOrThrow(playerContext.getId());
        Clan clan = clanService.getOrThrow(role.getClanId());
        ClanMember clanMember = clanService.selectClanMemberOne(clan.getId(), playerContext.getId());

        //拿到公会修改前的名字
        String oldNick = clan.getClanName();

        //判断是否加入公会
        Asserts.notNull(clanMember, ErrorCode.CLAN_NOT_EXIST.getValue(), StrUtil.format("没加入公会 clan id:{}", role.getClanId()));
        //判断有没有权根
        Asserts.isTrue(clanMember.getPosition() == ClanJobEnum.CLAN_PRESIDENT.getJobKey(), ErrorCode.CLAN_POSITION.getValue(),
                StrUtil.format("你不具有修改公会名字权根 Position:{}", clanMember.getPosition()));

        String clanName = msg.getNick().trim();
        clanName = clanName.replaceAll("\r|\n", "");
        //公会名称验证
        clanService.clanCheckNick(clanName, role);

        thingService.cost(playerContext.getId(), systemSysCache.getClanRenamingCard(), GameEvent.CLAN_RENAMING_CARD);

        clan.setClanName(clanName);
        clanService.updateClan(clan);

        builder.setNick(clanName);
        playerContext.write(CmdCode._7054, builder.build());

        clanService.broadcastToClan(role.getClanId(), CmdCode._7009, GResUpdateAllClanInfo.newBuilder().build());

        clanService.addToSendCrossList(clan.getId());

        eventBus.post(ClanEditNickEvent.of(role.getClanId(), clan.getClanName(), oldNick));
    }


    private enum ClanOperatorType {
        /**
         * 升职
         */
        RISE(1),
        /**
         * 降职
         */
        DOWN(0),
        /**
         * 踢出
         */
        KICK_OUT(2),
        ;

        private int type;

        ClanOperatorType(int type) {
            this.type = type;
        }

        public int getType() {
            return type;
        }
    }

    private enum ClanOperatorStatus {
        /**
         * 升职
         */
        SUCCESS(1),
        /**
         * 降职
         */
        FIAR(0),
        /**
         * 被踢出
         */
        BE_KICK_OUT(2),
        /**
         * 职位达到上限
         */
        POS_NUM_MAX(3),
        ;

        private int type;

        ClanOperatorStatus(int type) {
            this.type = type;
        }

        public int getType() {
            return type;
        }
    }

}
