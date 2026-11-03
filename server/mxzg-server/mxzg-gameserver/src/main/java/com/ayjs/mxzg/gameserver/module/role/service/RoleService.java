/**
 *
 */
package com.ayjs.mxzg.gameserver.module.role.service;

import cn.hutool.core.collection.CollectionUtil;
import cn.hutool.core.util.RandomUtil;
import com.ayjs.mxzg.common.convert.ConvertUtils;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.exception.ErrorCodeException;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.ConcurrentHashSet;
import com.ayjs.mxzg.common.util.GJsonUtils;
import com.ayjs.mxzg.common.util.StringUtil;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.AreaSysCache;
import com.ayjs.mxzg.config.excel.cache.MainLevelSysCache;
import com.ayjs.mxzg.config.excel.cache.NickSysCache;
import com.ayjs.mxzg.config.excel.cache.OpenConditionSysCache;
import com.ayjs.mxzg.config.excel.cache.PeerageEmblemSysCache;
import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.config.excel.cache.XingSysCache;
import com.ayjs.mxzg.config.excel.entity.CArea;
import com.ayjs.mxzg.config.excel.entity.CMainLevel;
import com.ayjs.mxzg.config.excel.entity.CNick;
import com.ayjs.mxzg.config.excel.entity.COpenCondition;
import com.ayjs.mxzg.config.excel.entity.CXing;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.LineUpType;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.Rewards;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.clan.domain.Clan;
import com.ayjs.mxzg.gameserver.module.clan.service.ClanService;
import com.ayjs.mxzg.gameserver.module.global.platform.PlatformSupport;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroLineUp;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroLineUpService;
import com.ayjs.mxzg.gameserver.module.onlineReward.domain.OnlineReward;
import com.ayjs.mxzg.gameserver.module.onlineReward.service.OnlineRewardService;
import com.ayjs.mxzg.gameserver.module.recharge.domain.RoleRecharge;
import com.ayjs.mxzg.gameserver.module.recharge.service.RoleRechargeService;
import com.ayjs.mxzg.gameserver.module.role.constant.CommentSharedState;
import com.ayjs.mxzg.gameserver.module.role.constant.CommentSharedType;
import com.ayjs.mxzg.gameserver.module.role.constant.RoleParamType;
import com.ayjs.mxzg.gameserver.module.role.dao.RoleDao;
import com.ayjs.mxzg.gameserver.module.role.domain.RemoteRole;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.domain.RoleCommentShared;
import com.ayjs.mxzg.gameserver.module.role.domain.RoleParam;
import com.ayjs.mxzg.gameserver.module.role.event.RoleExpAddEvent;
import com.ayjs.mxzg.gameserver.module.role.event.RoleLvUpEvent;
import com.ayjs.mxzg.gameserver.module.role.event.RoleProvinceChangeEvent;
import com.ayjs.mxzg.gameserver.module.sensitive.service.SensitiveWordService;
import com.ayjs.mxzg.gameserver.module.util.IPUtil;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.message.module.role.message.CrossRoleUpdateMessage;
import com.ayjs.mxzg.message.module.role.message.CrossRoleUpdateMessageList;
import com.ayjs.mxzg.protocol.RoleGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.ayjs.mxzg.template.constant.GameConstant;
import com.ayjs.mxzg.template.language.LanguageHelper;
import com.ayjs.rpc.dispatcher.MessageDispatcher;
import com.google.common.reflect.TypeToken;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

/**
 * @author YY
 *
 */
@Slf4j
@Service
public class RoleService {

    @Autowired
    private RoleDao roleDao;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private MainLevelSysCache mainLevelSysCache;
    @Autowired
    private ThingService thingService;
    @Autowired
    private XingSysCache xingSysCache;
    @Autowired
    private NickSysCache nickSysCache;
    @Autowired
    private LanguageHelper languageHelper;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private PlatformSupport platformSupport;
    @Autowired
    private RoleRechargeService roleRechargeService;
    @Autowired
    private OpenConditionSysCache openConditionSysCache;
    @Autowired
    private OnlineRewardService onlineRewardService;
    @Autowired
    private IPUtil ipUtil;
    @Autowired
    private AreaSysCache areaSysCache;
    @Autowired
    private HeroLineUpService heroLineUpService;
    @Autowired
    private MessageDispatcher messageDispatcher;
    @Autowired
    private SensitiveWordService sensitiveWordService;
    @Autowired
    private ClanService clanService;
    @Autowired
    private RoleParamService roleParamService;
    @Autowired
    private PeerageEmblemSysCache peerageEmblemSysCache;
    @Autowired
    private SystemSysCache systemSysCache;
    @Autowired
    private ServerConfig serverConfig;

    /**
     * 缓冲更新信息
     */
    private Set<Long> sendToCrossRoles = new ConcurrentHashSet<>();
    private static int SEND_LIMIT = 100;
    private Set<Long> sendToPlatformRoles = new ConcurrentHashSet<>();
    /**
     * 推送到跨服最低等级
     */
    private final static int SEND_CROSS_LIMIT_LEVEL = 10;
    /**
     * rid --> last_update_time
     */
    private final Map<Long, LocalDateTime> buryingMap = new ConcurrentHashMap<>();


    public Role getOrThrow(long rid) {
        Role role = roleDao.get(rid);
        Asserts.notNull(role, ErrorCode.ROLE_NOT_EXIST.getValue(), () -> String.format("role{%s} not found", rid));
        return role;
    }

    public Role getByUserId(int serverId, long userId) {
        Map<String, Object> map = new HashMap<>();
        map.put("serverId", serverId);
        map.put("userId", userId);
        List<Role> list = roleDao.list(map);
        if (list.isEmpty()) {
            return null;
        } else if (list.size() == 1) {
            return list.get(0);
        } else {
            throw new ErrorCodeException(0, "相同服务器ID[" + serverId + "]下出现重复的userId[" + userId + "]账号");
        }
    }

    /**
     * 判断该ID是不是本服的玩家ID
     * @param rid
     * @return
     */
    public boolean isRole(long rid) {
        return roleDao.contains(rid);
    }

    public void roleOffline(long rid) {
        Role role = this.getOrThrow(rid);
        role.setOnline(0);
        role.setLastOfflineTime(TimeDateUtil.getCurrentTime());
        // eventBus.post(LogoutEvent.of(rid));
        updateRole(role);
        //TODO 其他下线逻
    }

    public void addRole(Role role) {
        roleDao.add(role);
    }

    public void updateRole(Role role) {
        roleDao.update(role);
    }

    public void updateRoles(List<Role> roles) {
        roleDao.update(roles);
    }

    /**
     * 获取活跃玩家
     * @return
     */
    public List<Role> getActiceRoles() {
        //listAll返回的列表无法排序
        List<Role> roleList = roleDao.listAll();
        List<Role> newList = new ArrayList<>(roleList);
        newList.sort(Comparator.comparingLong(Role::getOnline));
        List<Role> resultList = new ArrayList<>();
        for (int i = newList.size() - 1; i >= 0; i--) {
            Role role = newList.get(i);
            if (role.getIsEditName() == 0) {
                continue;
            }
            resultList.add(role);
            if (resultList.size() >= 200) {
                break;
            }
        }
        return resultList;
    }


    public List<Role> getNameLike(String name) {
        List<Role> list = roleDao.listAll();
        List<Role> result = new ArrayList<>();
        for (Role role : list) {
            if (role.getNick() == null) {
                continue;
            }
            if (role.getNick().contains(name)) {
                result.add(role);
            }
            if (result.size() > 10) {
                break;
            }
        }
        return result;
    }

    /**
     * 是否重名
     * @param name
     * @return
     */
    public boolean hasSameName(String name) {
        for (Role role : roleDao.listAll()) {
            if (name.equals(role.getNick())) {
                return true;
            }
        }
        return false;
    }


    public List<Role> getAllRole() {
        return roleDao.listAll();
    }

    /***
     * 增加经验
     * @param rid
     * @param addExp
     */
    public void addExp(long rid, long addExp, GameEvent gameEvent) {
        Role role = getOrThrow(rid);
        if (role.getLevel() >= mainLevelSysCache.getMaxLevel()) {
            return;
        }
        role.setExp(role.getExp() + addExp);

        int oldLv = role.getLevel();

        CMainLevel config = mainLevelSysCache.getOrThrow(role.getLevel());

        List<ImmutableThing> rewardList = new ArrayList<>();
        while (role.getExp() >= config.getExp()) {
            rewardList.addAll(config.getReward());
            role.setLevel(role.getLevel() + 1);
            if (role.getLevel() >= mainLevelSysCache.getMaxLevel()) {
                role.setExp(0);
                break;
            }
            role.setExp(role.getExp() - config.getExp());
            config = mainLevelSysCache.getOrThrow(role.getLevel());
        }
        //没有升级的话，已经通过道具推送了经验值增加
        if (oldLv != role.getLevel()) {
            Rewards rewards = thingService.add(role.getId(), rewardList, GameEvent.LEVEL_REWARD, NoticeType.SLIENT);
            //推送升级
            RoleGMsg.GResRoleUpgradeReward.Builder builder = RoleGMsg.GResRoleUpgradeReward.newBuilder();
            builder.setLevelBeford(oldLv);
            builder.setLevelCurrent(role.getLevel());
            builder.setNowExp(role.getExp());
            builder.addAllList(PbUtil.buildReward(rewards.getThingSet().asList()));
            contextManager.write(rid, CmdCode._2014, builder.build());

            eventBus.post(RoleLvUpEvent.of(rid, oldLv, role.getLevel()));
        }
        eventBus.post(RoleExpAddEvent.of(rid, addExp, role.getExp(), oldLv, role.getLevel(), gameEvent));
    }

    /**
     * 随机名字
     *
     * @param filterNick 过滤的字符
     * @return
     */
    public String randomNick(Set<String> filterNick) {
        String nick = "";
        for (int i = 0; i < 100; i++) {
            CXing cXing = RandomUtil.randomEle(xingSysCache.getAll());
            CNick cNick = RandomUtil.randomEle(nickSysCache.getAll());

            nick = languageHelper.getLanguageBy(cXing) + languageHelper.getLanguageBy(cNick);
            if (Objects.isNull(filterNick) || !filterNick.contains(nick)) {
                break;
            }
        }
        Asserts.notNull(nick, ErrorCode.CONFIG_NOT_EXISTS.getValue(),
                () -> "nick not random:" + GJsonUtils.toJson(filterNick));
        return nick;
    }

    public String randomNick(Set<String> filterNick, long rid) {
        String nick = "";
        Role role = getOrThrow(rid);
        for (int i = 0; i < 100; i++) {
            CXing cXing = RandomUtil.randomEle(xingSysCache.getAll());
            CNick cNick = RandomUtil.randomEle(nickSysCache.getAll());

            nick = languageHelper.getLanguageBy(cXing, role.getLang()) + languageHelper.getLanguageBy(cNick, role.getLang());
            if (Objects.isNull(filterNick) || !filterNick.contains(nick)) {
                break;
            }
        }
        Asserts.notNull(nick, ErrorCode.CONFIG_NOT_EXISTS.getValue(),
                () -> "nick not random:" + GJsonUtils.toJson(filterNick));
        return nick;
    }


    /**
     * 添加到发送角色信息到平台的缓存
     *
     * @param rid
     */
    public void addSendToPlatformList(long rid) {
        sendToPlatformRoles.add(rid);
    }

    /**
     * 发送角色信息到平台
     *
     * @param rid
     */
    public void sendRoleInfoToPlatform(long rid) {
        Role role = getOrThrow(rid);
        Map<String, Object> params = new HashMap<>();
        params.put("action", "Platform.recordRole");
        params.put("user_id", role.getUserId());
        params.put("role_id", role.getId());
        params.put("role_name", role.getNick());
        params.put("sid", role.getServerId());
        params.put("fighting", role.getMaxFighting());
        params.put("vip", role.getGoddessVip());
        params.put("level", role.getLevel());
        params.put("headId", role.getHeadId());
        params.put("borderId", role.getBorderId());
        params.put("gem", role.getGem());
        params.put("super_gem", role.getSuperGem());
        params.put("c_son_id", role.getPlace());

        OnlineReward onlineReward = onlineRewardService.getOnlineReward(rid);
        params.put("online_time", onlineReward.getOnlineTime());
        params.put("today_online_time", onlineReward.getTodayOnlineTime());

        RoleRecharge roleRecharge = roleRechargeService.getRoleRecharge(rid);
        params.put("totalRecharge", roleRecharge.getTotalRecharge());

        platformSupport.sendToPlatform(params);
    }


    /**
     * 是否能够登陆
     */
    public boolean canLogin(long userId, int serverId, String ip) {
        Map<String, Object> params = new HashMap<>();
        params.put("action", "User.canLogin");
        params.put("uid", userId);
        params.put("sid", serverId);
        params.put("ip", ip);
        Map<String, String> statusMap = platformSupport.callPlatform(params, new TypeToken<Map<String, String>>() {
        });
        if (Objects.isNull(statusMap)) {
            log.debug("result msg is null,params:{}", GJsonUtils.toJson(params));
            return false;
        }
        return ConvertUtils.toInt(statusMap.get("is_login"), 0) == 1;
    }

    /**
     * 获取邀请的玩家信息
     *
     * @param rid
     * @return
     */
    public List<RemoteRole> getInviteRoles(long rid) {
        Map<String, Object> params = new HashMap<>();
        params.put("action", "Platform.getInviteRoles");
        params.put("invite_rid", rid);
        List<RemoteRole> remoteRoleList = platformSupport.callPlatform(params, new TypeToken<List<RemoteRole>>() {
        });
        if (CollectionUtil.isNotEmpty(remoteRoleList)) {
            return remoteRoleList;
        } else {
            return Collections.emptyList();
        }
    }

    /**
     * 是否允许进行该请求
     * @param rid
     * @param entryType
     * @return
     */
    public boolean canEntry(long rid, String entryType) {
        if ("".equals(entryType)) {
            return true;
        }
        COpenCondition cOpenCondition = openConditionSysCache.getCondition(entryType);
        if (cOpenCondition == null) {
            return false;
        }
        Role role = this.getOrThrow(rid);
        if (cOpenCondition.getCondition_type() == 1) {
            Asserts.isTrue(role.getLevel() >= cOpenCondition.getCondition_value(), ErrorCode.ROLE_LEVEL_LACK.getValue(),
                    () -> "系统: " + entryType + "您的冒险等级不足:" + role.getLevel() + "，要求等级:" + cOpenCondition.getCondition_value());
        } else if (cOpenCondition.getCondition_type() == 2) {
            Asserts.isTrue(role.getClanId() > 0, ErrorCode.CLAN_NOT_JOIN.getValue(), () -> "您还没有加入公会");
        }
        return true;
    }

    /**
     * 解析角色省份城市id，仅用于聊天同省频道
     */
    public void analysisRoleAreaId(long rid, String ip) {
        Role role = getOrThrow(rid);
        if (role.getAreaId() > 0 && StringUtils.isNotBlank(role.getProvince())) {
            return;
        }
        CArea cArea = null;
        // 判断聊天的同省频道是否还需要，不用就不计算和设置地区属性
        if (serverConfig.isGameChatProvincialChannel()) {
            //根据ip获取城市
            cArea = ipUtil.getCityId(ip);
        }
        int cityId = areaSysCache.getDefaultCityId();
        String province = areaSysCache.getDefaultProvince();
        if (Objects.nonNull(cArea)) {
            cityId = cArea.getIdx();
            province = cArea.getProvince();
        }
        if (role.getAreaId() == cityId) {
            return;
        }
        role.setAreaId(cityId);
        if (!role.getProvince().equals(province)) {
            role.setProvince(province);
            eventBus.post(RoleProvinceChangeEvent.of(rid, province));
        }
        updateRole(role);
        RoleGMsg.GResUpdateAreaId.Builder res = RoleGMsg.GResUpdateAreaId.newBuilder();
        res.setAreaId(role.getAreaId());

        contextManager.write(role.getId(), CmdCode._2019, res.build());
    }

    /**
     * 分析注册时的ip
     *
     * @param rid
     * @param ip
     */
    public void analysisRoleCreateAreaId(long rid, String ip) {
        Role role = getOrThrow(rid);
        CArea cArea = ipUtil.getCityId(ip);
        if (Objects.isNull(cArea)) {
            return;
        }
        role.setCreateAreaId(cArea.getIdx());
        role.setLoginAreaId(cArea.getIdx());
        updateRole(role);
    }

    /**
     * 分析登录时的ip
     *
     * @param rid
     * @param ip
     */
    public void analysisRoleLoginAreaId(long rid, String ip) {
        Role role = getOrThrow(rid);
        CArea cArea = ipUtil.getCityId(ip);
        if (Objects.isNull(cArea)) {
            return;
        }
        if (role.getCreateAreaId() <= 0) {
            role.setCreateAreaId(cArea.getIdx());
        }
        role.setLoginAreaId(cArea.getIdx());
        updateRole(role);
    }



    public void checkNick(String nick, Role role) {
        Asserts.isTrue(StringUtils.isNotBlank(nick), ErrorCode.ROLE_NICK_EMPTY.getValue(),
                () -> "nick is blank");

        int nickLength = StringUtil.getShowLength(nick);
        Asserts.isTrue(nickLength >= 1 && nickLength <= systemSysCache.getPlayerNameLength(),
                ErrorCode.ROLE_NICK_TOO_LONG.getValue(), String.format("nick too long:%s", nick));

        Asserts.isTrue(GameConstant.NAME_PATTERN.matcher(nick).matches(), ErrorCode.ROLE_NICK_SENSITIVE.getValue(),
                String.format("名称格式不对!name:%s", nick));

        // 敏感字过滤
        Asserts.isTrue(sensitiveWordService.wordCanUse(nick, role), ErrorCode.ROLE_NICK_SENSITIVE.getValue(),
                () -> String.format("nick:%s contains sensitive word :%s", nick,
                        sensitiveWordService.findConfigSensitiveWord(nick, role)));
        // 屏蔽字过滤
        Asserts.isTrue(sensitiveWordService.checkMaskedWord(nick, role), ErrorCode.ROLE_NICK_EXIST_MASKED_WORD.getValue(),
                String.format("玩家昵称{%s}存在屏蔽字", nick));
    }

    /**
     * 发送角色数据去跨服
     *
     * @param rid
     */
    public void sendRoleInfoToCross(long rid) {
        Role role = getOrThrow(rid);
        sendRoleInfoToCross(role);
    }

    public void sendRoleInfoToCross(Role role) {
        // 由于世界boss，工会战功能跨服数据需要上传加入公会的成员数据
//        COpenCondition condition = openConditionSysCache.getCondition(EntryType.MAIN_CLAN);
        int limitLevel = SEND_CROSS_LIMIT_LEVEL;// 最低的等级
//        if (Objects.nonNull(condition)) {
//            limitLevel = condition.getCondition_value();
//        }
        if (role.getLevel() < limitLevel) {
            return;
        }
        sendToCrossRoles.add(role.getId());
    }

    public CrossRoleUpdateMessage toCrossRole(Role role) {
        CrossRoleUpdateMessage.CrossRoleUpdateMessageBuilder builder = CrossRoleUpdateMessage.builder();
        builder.id(role.getId());
        builder.userId(role.getUserId());
        builder.serverId(role.getServerId());
        builder.nick(role.getNick());
        builder.headId(role.getHeadId());
        builder.borderId(role.getBorderId());
        builder.imageId(role.getImageId());
        builder.level(role.getLevel());
        builder.createTime(role.getCreateTime());

        builder.areaId(role.getAreaId());
        String clanName = "";
        long clanId = role.getClanId();
        try {
            if (role.getClanId() > 0) {
                Clan clan = clanService.getOrThrow(role.getClanId());
                clanName = clan.getClanName();
                clanId = clan.getId();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        builder.clanId(clanId);
        builder.clanName(clanName);
        builder.arenaScore(role.getArenaScore());
        builder.fighting(role.getFighting());
        builder.maxFighting(role.getMaxFighting());
        builder.isOnline(contextManager.isOnline(role.getId()));
        builder.heroBrief(heroLineUpService.getMainHeroBrief(role.getId()));
        builder.lastOfflineTime(role.getLastOfflineTime());
        builder.place(role.getPlace());
        HeroLineUp mainHeroLineUp = heroLineUpService.getLineUpByType(role.getId(), LineUpType.MAIN);
        builder.formationId(mainHeroLineUp.getFormationId());
        builder.assistanceUnlock(role.isAssistanceUnlock());
        return builder.build();
    }

    /**
     * 发送去跨服
     */
    synchronized void sendToCross() {
        Iterator<Long> iterator = sendToCrossRoles.iterator();
        List<CrossRoleUpdateMessage> updateList = new ArrayList<>();
        while (iterator.hasNext()) {
            try {
                Long rid = iterator.next();
                iterator.remove();
                Role role = getOrThrow(rid);
                CrossRoleUpdateMessage crossRoleUpdateMessage = toCrossRole(role);
                updateList.add(crossRoleUpdateMessage);
                if (updateList.size() >= SEND_LIMIT) {
                    messageDispatcher.dispatch(CrossRoleUpdateMessageList.of(updateList));
                    updateList = new ArrayList<>();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        if (CollectionUtil.isNotEmpty(updateList)) {
            messageDispatcher.dispatch(CrossRoleUpdateMessageList.of(updateList));
        }
    }

    /**
     * 立刻同步玩家数据至跨服
     * @param rid
     * @param anyObj
     */
    public void sendToCrossImmediately(long rid, Object anyObj) {
        try {
            Role role = getOrThrow(rid);
            CrossRoleUpdateMessage crossRoleUpdateMessage = toCrossRole(role);
            List<CrossRoleUpdateMessage> updateList = new ArrayList<>();
            updateList.add(crossRoleUpdateMessage);
            messageDispatcher.dispatch(CrossRoleUpdateMessageList.of(updateList));
        } catch (Exception e) {
            log.error("同步玩家数据至跨服失败，触发信息{}", (anyObj != null ? anyObj.getClass().getSimpleName() : ""));
        }
    }

    /**
     * 发送给平台
     */
    synchronized void sendToPlatform() {
        Iterator<Long> iterator = sendToPlatformRoles.iterator();
        while (iterator.hasNext()) {
            Long rid = iterator.next();
            iterator.remove();
            sendRoleInfoToPlatform(rid);
        }
    }

    /**
     * 返回所有的状态
     *
     * @param rid
     * @return
     */
    public Map<Integer, RoleCommentShared> getAllCommentShared(long rid) {
        RoleParam roleParam = roleParamService.get(rid, RoleParamType.ROLE_COMMENT_SHARED);
        if (Objects.isNull(roleParam)) {
            return Collections.emptyMap();
        }

        Map<Integer, RoleCommentShared> map = roleParam.parseJson(new TypeToken<Map<Integer, RoleCommentShared>>() {
        });
        RoleCommentShared roleCommentShared = map.get(CommentSharedType.TWITTER_SHARED.getType());
        if (roleCommentShared != null && roleCommentShared.getState() == CommentSharedState.RECEIVED.getState()
                && roleCommentShared.getDatetime() < DateTimeUtil.dayBreak()) {
            roleCommentShared.setState(CommentSharedState.UNDONE.getState());
            this.addOrUpdateRoleCommentShared(rid, roleCommentShared);
        }

        return roleParam.parseJson(new TypeToken<Map<Integer, RoleCommentShared>>() {
        });
    }

    /**
     * 返回指定类型的状态
     *
     * @param rid
     * @param type
     * @return
     */
    public RoleCommentShared getRoleCommentShared(long rid, CommentSharedType type) {
        Map<Integer, RoleCommentShared> roleCommentShared = getAllCommentShared(rid);
        return roleCommentShared.get(type.getType());
    }

    /**
     * 新增或者修改状态数据
     *
     * @param rid
     * @param state
     * @return
     */
    public void addOrUpdateRoleCommentShared(long rid, RoleCommentShared state) {
        RoleParam roleParam = roleParamService.get(rid, RoleParamType.ROLE_COMMENT_SHARED);

        if (Objects.isNull(roleParam)) {
            roleParam = RoleParam.of(rid, RoleParamType.ROLE_COMMENT_SHARED);
            Map<Integer, RoleCommentShared> roleCommentSharedMap = new HashMap<>();
            roleCommentSharedMap.put(state.getType(), state);

            roleParam.saveJson(roleCommentSharedMap);
            roleParamService.save(roleParam);
        } else {
            Map<Integer, RoleCommentShared> roleCommentSharedMap = roleParam.parseJson(new TypeToken<Map<Integer, RoleCommentShared>>() {
            });

            RoleCommentShared commentShared = roleCommentSharedMap.get(state.getType());
            if (Objects.isNull(commentShared)) {
                commentShared = new RoleCommentShared();
                roleCommentSharedMap.put(state.getType(), commentShared);
            }

            commentShared.setType(state.getType());
            commentShared.setState(state.getState());
            commentShared.setDatetime(state.getDatetime());
            roleParam.saveJson(roleCommentSharedMap);
            roleParamService.update(roleParam);
        }
    }

    /**
     * 转换成协议方式
     *
     * @param data
     * @return
     */
    public List<RoleGMsg.RoleCommentSharedState> toRoleCommentSharedState(Map<Integer, RoleCommentShared> data) {
        List<RoleGMsg.RoleCommentSharedState> result = new ArrayList<>();

        if (Objects.nonNull(data)) {
            data.values().forEach(commentShared -> {
                RoleGMsg.RoleCommentSharedState.Builder stateBuilder = RoleGMsg.RoleCommentSharedState.newBuilder();
                stateBuilder.setType(commentShared.getType());
                stateBuilder.setState(commentShared.getState());
                result.add(stateBuilder.build());
            });
        }
        return result;
    }

    /**
     * 获取玩家尊贵标识等级
     * @param rid
     * @return
     */
    public int getRolePeerage(long rid) {
        RoleRecharge roleRecharge = roleRechargeService.getRoleRecharge(rid);
        return peerageEmblemSysCache.getPeerageLevel(roleRecharge.getTotalRecharge());
    }

    public LocalDateTime getLastGuideTime(long rid){
        return buryingMap.getOrDefault(rid, LocalDateTime.now());
    }

    public void updateLastGuideTime(long rid, LocalDateTime lastTime){
        buryingMap.put(rid, lastTime);
    }

}
