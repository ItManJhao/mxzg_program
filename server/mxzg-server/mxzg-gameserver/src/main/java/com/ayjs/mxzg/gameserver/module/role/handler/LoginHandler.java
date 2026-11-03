/**
 *
 */
package com.ayjs.mxzg.gameserver.module.role.handler;

import cn.hutool.core.collection.CollectionUtil;
import cn.hutool.crypto.SecureUtil;
import com.ayjs.mxzg.common.convert.ConvertUtils;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.AreaSysCache;
import com.ayjs.mxzg.config.excel.cache.HeroTypeSysCache;
import com.ayjs.mxzg.config.excel.cache.InitUserSysCache;
import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.config.excel.entity.CHeroType;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.netty.OfflineEvent;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.role.domain.ErrorMsg;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.event.CreateRoleEvent;
import com.ayjs.mxzg.gameserver.module.role.event.LoginEvent;
import com.ayjs.mxzg.gameserver.module.role.service.ErrorMsgService;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.sensitive.service.SensitiveWordService;
import com.ayjs.mxzg.gameserver.module.server.constant.ServerParamType;
import com.ayjs.mxzg.gameserver.module.server.domain.ServerParam;
import com.ayjs.mxzg.gameserver.module.server.service.ServerParamService;
import com.ayjs.mxzg.protocol.LoginGMsg.*;
import com.ayjs.mxzg.template.constant.ErrorCode;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.HashSet;
import java.util.Objects;
import java.util.TimeZone;

/**
 * @author YY
 */
@Slf4j
@Controller
public class LoginHandler extends ProtocolHandler {

    @Autowired
    private RoleService roleService;
    @Autowired
    private InitUserSysCache initUserSysCache;
    @Autowired
    private SystemSysCache systemSysCache;
    @Autowired
    private ErrorMsgService errorMsgService;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private SensitiveWordService sensitiveWordService;
    @Autowired
    private ServerParamService serverParamService;
    @Autowired
    private ServerConfig serverConfig;
    @Autowired
    private HeroTypeSysCache heroTypeSysCache;
    @Autowired
    private AreaSysCache areaSysCache;
    @Autowired
    private ThingService thingService;

    @CMD(id = CmdCode._1001, needLogin = false)
    public void login(PlayerContext playerContext, GReqLogin msg) {
        if (msg.getUserId() <= 0) {
            // 账号ID错误
            playerContext.writeError(ErrorCode.ROLE_USERID_ERROR, msg.getUserId());
            return;
        }
        //检查是否允许该服务器ID进行登录
        if (!serverConfig.matchServerId(msg.getServerId())) {
            playerContext.writeError(ErrorCode.ROLE_SERVERID_ERROR, msg.getServerId());
            return;
        }

        // 校验sign
        long userId = msg.getUserId();
        String loginToken = msg.getLoginToken();
        String sign = msg.getSign();
        String signStr = loginToken + userId + serverConfig.getPlatformKey();
        String serverSign = SecureUtil.md5(signStr);

        log.debug("signStr:{}, serverSign:{}, platform sign:{}", signStr, serverSign, sign);
        if (!serverConfig.isServerDebug()) {
            Asserts.isTrue(serverSign.equalsIgnoreCase(sign), ErrorCode.ERROR_PARAM.getValue(),
                    () -> String.format("signStr:%s, serverSign:%s sign:%s ", signStr, serverSign, sign));
        }

        playerContext.setUserId(msg.getUserId());
        playerContext.setServerId(msg.getServerId());
        // 根据openId查询玩家
        Role role = roleService.getByUserId(msg.getServerId(), msg.getUserId());
        if (role == null) {
            // 返回没有创号的信息
            playerContext.write(CmdCode._1001, GResLogin.getDefaultInstance());
            // 还没有创号
            return;
        }
        if (role.getForbidEndTime() > DateTimeUtil.currentSecond()) {
            // 玩家被封号
            log.error("role forbid end time:{}", role.getForbidEndTime());
            GResLogin.Builder builder = GResLogin.newBuilder();
            builder.setRid(role.getId());
            builder.setStatus(1);
            playerContext.write(CmdCode._1001, builder.build());
            return;
        }

        // 判断服务器是否能登陆
        ServerParam serverParam = serverParamService.get(ServerParamType.DEFEND_END_TIME);
        int now = TimeDateUtil.getCurrentTimeInt();
        //服务器维护中请求平台，确认是否是白名单
        if (Objects.nonNull(serverParam) && ConvertUtils.toInt(serverParam.getSpValue()) > now) {
            boolean canLogin = roleService.canLogin(role.getUserId(), role.getServerId(), playerContext.getRemoteAddress());
            Asserts.isTrue(canLogin, ErrorCode.SERVER_MAINTENANCE.getValue(),
                    () -> String.format("server maintenance rid:%s serverId:%s ip:%s ",
                            role.getId(), role.getServerId(), playerContext.getRemoteAddress()));
        }

        PlayerContext oldContext = contextManager.getOnline(role.getId());
        if (oldContext != null) {
            log.info("玩家{}-{}异地登录", role.getId(), role.getNick());
            // 顶号登录，把在线的账号踢下线
            contextManager.playerOffline(oldContext, OfflineEvent.LoginHandler_login);

            GResOffline.Builder res = GResOffline.newBuilder();
            res.setType(1);
            oldContext.write(CmdCode._1003, res.build());
        }

        playerContext.setId(role.getId());
        playerContext.setLogin(true);
        contextManager.addToOnline(playerContext);

        role.setLastLoginTime(TimeDateUtil.getCurrentTime());
        role.setPlatform(msg.getPlatform());
        role.setPushToken(msg.getPushToken());
        role.setOnline(1);
        roleService.updateRole(role);

        // TODO 登录日志

        // TODO 处理玩家上线数据

        GResLogin.Builder builder = GResLogin.newBuilder();
        builder.setRid(role.getId());
        builder.setServerTime(TimeDateUtil.getCurrentTime());
        //服务器时间和格林标准时间差(时区差正或者负 单位秒)
        builder.setOffsetUtc(TimeZone.getDefault().getOffset(DateTimeUtil.millisTime()) / 1000);
        playerContext.write(CmdCode._1001, builder.build());

        eventBus.post(LoginEvent.of(role.getId(),
                role.getUserId(), role.getPlatform(),
                role.getLevel(), role.getPlatform(),
                DateTimeUtil.currentSecond(),
                playerContext.getRemoteAddress(),
                (int) (role.getCreateTime() / 1000),
                role.getPlace(),
                msg.getDeviceId()));
    }

    @CMD(id = CmdCode._1002, needLogin = false)
    public void create(PlayerContext playerContext, GReqInit msg) {
        String nick = msg.getNick().trim();
        nick = nick.replaceAll("\r|\n", "");
        roleService.checkNick(nick, null);
//        Asserts.isTrue(StringUtils.isNotBlank(nick), ErrorCode.ROLE_NICK_EMPTY.getValue(),
//                () -> String.format("nick is blank"));
//        // 敏感字过滤
//        Asserts.isTrue(sensitiveWordService.wordCanUse(nick), ErrorCode.ROLE_NICK_SENSITIVE.getValue(),
//                () -> String.format("nick:%s contains sensitive word :%s", nick,
//                        sensitiveWordService.findConfigSensitiveWord(nick)));
//
//        int nickLength = StringUtil.getShowLength(nick);
//        Asserts.isTrue(nickLength >= 1 && nickLength <= GameConstant.ROLE_NICK_LENGTH,
//                ErrorCode.ROLE_NICK_TOO_LONG.getValue(), String.format("nick too long:%s", nick));

        if (playerContext.getUserId() <= 0 || playerContext.getServerId() <= 0) {
            // 请先进行登录
            playerContext.writeError(ErrorCode.ROLE_LOGIN_FIRST);
            return;
        }

        // 根据openId查询玩家
        Role role = roleService.getByUserId(playerContext.getServerId(), playerContext.getUserId());
        if (role != null) {
            // 已经创号
            log.error("serverId:{} userId:{} oldRid:{}, oldNick:{}",
                    playerContext.getServerId(), playerContext.getUserId(), role.getId(), role.getNick());
            playerContext.writeError(ErrorCode.ROLE_CREATED, playerContext.getUserId());
            return;
        }
        role = new Role();
        role.setUserId(playerContext.getUserId());
        role.setServerId(playerContext.getServerId());
        role.setCreateTime(TimeDateUtil.getCurrentTime());
        role.setLang(msg.getLang());
        role.setPlatform(msg.getPlatform());
        role.setNick(nick);
        role.setOnline(1);
        role.setLastLoginTime(TimeDateUtil.getCurrentTime());
        role.setLevel(initUserSysCache.getLevel());
        role.setExp(initUserSysCache.getExp());
        role.setArenaScore(initUserSysCache.getCup());
        role.setMaxCup(initUserSysCache.getCup());
        role.setGem(initUserSysCache.getGem());
        role.setGold(initUserSysCache.getGold());
        role.setHeroNum(systemSysCache.getHeroSpaceInitial());
        role.setPlace(msg.getPlace());
        CHeroType cHeroType = heroTypeSysCache.getOrThrow(systemSysCache.getFirstOrdinaryLottery());
        String imageId = cHeroType.getStar() + "" + systemSysCache.getFirstOrdinaryLottery();
        role.setImageId(Integer.parseInt(imageId));
        role.setDeviceId(msg.getDeviceId());
        role.setAreaId(0);
        role.setProvince("");
        role.setPushToken("");
        role.setPushOffIds(new HashSet<>());
        roleService.addRole(role);

        playerContext.setId(role.getId());
        playerContext.setLogin(true);
        // TODO 创号日志

        eventBus.post(CreateRoleEvent.of(role.getId(),
                role.getUserId(), role.getPlatform(),
                role.getLevel(), role.getPlatform(),
                DateTimeUtil.currentSecond(), playerContext.getRemoteAddress(), (int) (role.getCreateTime() / 1000)
                , role.getDeviceId(), role.getPlace()));

        GResInit.Builder builder = GResInit.newBuilder();
        builder.setRid(role.getId());
        playerContext.write(CmdCode._1002, builder.build());

        // 增加创号送的道具
        if (CollectionUtil.isNotEmpty(initUserSysCache.getInitReward())) {
            thingService.add(role.getId(), initUserSysCache.getInitReward(), GameEvent.CREATE_ROLE_MAIL, NoticeType.SLIENT);
        }
    }

    @CMD(id = CmdCode._1003)
    public void offline(PlayerContext playerContext, GReqOffline msg) {
        contextManager.playerOffline(playerContext, OfflineEvent.LoginHandler_offline);
    }

    @CMD(id = CmdCode._1004)
    public void heartBeat(PlayerContext playerContext, GReqHeartBeat msg) {
        GResHeartBeat.Builder builder = GResHeartBeat.newBuilder();
        builder.setServerTime(TimeDateUtil.getCurrentTime());
        playerContext.write(CmdCode._1004, builder.build());
    }

    @CMD(id = CmdCode._1005)
    public void clientError(PlayerContext playerContext, GReqError msg) {
        ErrorMsg errorMsg = new ErrorMsg();
        errorMsg.setRid(playerContext.getId());
        errorMsg.setTime(TimeDateUtil.getCurrentTime());
        errorMsg.setMsg(msg.getError());
        errorMsgService.addErrorMsg(errorMsg);
    }
}
