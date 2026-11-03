package com.ayjs.mxzg.gameserver.module.role.observer;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.TimeConstants;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.AppointmentGiftSysCache;
import com.ayjs.mxzg.config.excel.cache.PeerageEmblemSysCache;
import com.ayjs.mxzg.config.excel.constant.MailConst;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.config.struct.LineUpType;
import com.ayjs.mxzg.config.struct.LoginMailInfo;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.netty.OfflineEvent;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.border.event.RoleBorderEvent;
import com.ayjs.mxzg.gameserver.module.border.event.RoleImageEvent;
import com.ayjs.mxzg.gameserver.module.clan.event.ClanChangeEvent;
import com.ayjs.mxzg.gameserver.module.headPortrait.event.RolePortraitEvent;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroLineUp;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroStarUpEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroUpLevelEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.LineUpChangeEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.RoleFightChangeEvent;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroLineUpService;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.mail.constant.MailScene;
import com.ayjs.mxzg.gameserver.module.mail.domain.Mail;
import com.ayjs.mxzg.gameserver.module.mail.service.MailService;
import com.ayjs.mxzg.gameserver.module.recharge.domain.RoleRecharge;
import com.ayjs.mxzg.gameserver.module.recharge.event.RechargeEvent;
import com.ayjs.mxzg.gameserver.module.recharge.service.RoleRechargeService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.event.CreateRoleEvent;
import com.ayjs.mxzg.gameserver.module.role.event.LoginEvent;
import com.ayjs.mxzg.gameserver.module.role.event.LogoutEvent;
import com.ayjs.mxzg.gameserver.module.role.event.MaxFightingEvent;
import com.ayjs.mxzg.gameserver.module.role.event.RoleEditNickEvent;
import com.ayjs.mxzg.gameserver.module.role.event.RoleLvUpEvent;
import com.ayjs.mxzg.gameserver.module.role.event.RolePeerageChangeEvent;
import com.ayjs.mxzg.gameserver.module.role.event.RoleProvinceChangeEvent;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.server.constant.ServerParamType;
import com.ayjs.mxzg.gameserver.module.server.domain.ServerParam;
import com.ayjs.mxzg.gameserver.module.server.service.ServerParamService;
import com.ayjs.mxzg.gameserver.remote.cross.event.CrossConnectedEvent;
import com.ayjs.mxzg.gameserver.web.event.RoleForbidChatEvent;
import com.ayjs.mxzg.gameserver.web.event.RoleForbidEvent;
import com.ayjs.mxzg.protocol.RoleGMsg;
import com.ayjs.mxzg.protocol.RoleGMsg.GResRoleForbid;
import com.ayjs.mxzg.protocol.RoleGMsg.GResRoleForbidChat;
import org.springframework.beans.factory.annotation.Autowired;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

@Observer
public class RoleObserver {

    @Autowired
    private RoleService roleService;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private HeroService heroService;
    @Autowired
    private HeroLineUpService heroLineUpService;
    @Autowired
    private ServerParamService serverParamService;
    @Autowired
    private RoleRechargeService roleRechargeService;
    @Autowired
    private PeerageEmblemSysCache peerageEmblemSysCache;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private MailService mailService;
    @Autowired
    private ServerConfig serverConfig;
    @Autowired
    private AppointmentGiftSysCache appointmentGiftSysCache;

    // 两个都比较耗时，暂时用日志线程
    // 创号
    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    public void onEventAreaId(CreateRoleEvent event) {
        roleService.analysisRoleAreaId(event.getRid(), event.getIp());
    }

    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    public void onEventCreateAreaId(CreateRoleEvent event) {
        roleService.analysisRoleCreateAreaId(event.getRid(), event.getIp());
    }

    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    public void onEventToPlatform(CreateRoleEvent event) {
        roleService.addSendToPlatformList(event.getRid());
    }

    // 登录
    @Subscribe(async = Subscribe.AsyncType.Async)
    public void onEventToCross(LoginEvent event) {
        roleService.sendRoleInfoToCross(event.getRid());
    }

    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    public void onEventLoginToPlatform(LoginEvent event) {
        roleService.addSendToPlatformList(event.getRid());
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void onEventAreaId(LoginEvent event) {
        roleService.analysisRoleAreaId(event.getRid(), event.getIp());
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void onEventLoginAreaId(LoginEvent event) {
        roleService.analysisRoleLoginAreaId(event.getRid(), event.getIp());
    }

    // 登出
    @Subscribe(async = Subscribe.AsyncType.Async)
    public void onEventToCross(LogoutEvent event) {
        roleService.sendRoleInfoToCross(event.getRid());
    }

    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    public void onEventToPlatform(LogoutEvent event) {
        roleService.addSendToPlatformList(event.getRid());
    }

    // 最大战力变化
    @Subscribe(async = Subscribe.AsyncType.Async)
    public void onEventToCross(MaxFightingEvent event) {
        roleService.sendRoleInfoToCross(event.getRid());
    }

    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    public void onEventToPlatform(MaxFightingEvent event) {
        roleService.addSendToPlatformList(event.getRid());
    }

    // 个人当前战力变化
    @Subscribe(async = Subscribe.AsyncType.Async)
    public void onEvent(RoleFightChangeEvent event) {
        roleService.sendRoleInfoToCross(event.getRid());
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void onEvent(RolePortraitEvent event) {
        roleService.sendRoleInfoToCross(event.getRid());
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void onEvent(RoleBorderEvent event) {
        roleService.sendRoleInfoToCross(event.getRid());
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void onEvent(RoleImageEvent event) {
        roleService.sendRoleInfoToCross(event.getRid());
    }

    // 升级
    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    public void onEventToPlatform(RoleLvUpEvent event) {
        roleService.addSendToPlatformList(event.getRid());
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void onEventToCross(RoleLvUpEvent event) {
        roleService.sendRoleInfoToCross(event.getRid());
    }

    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    public void onEvent(RechargeEvent event) {
        roleService.addSendToPlatformList(event.getRid());
    }

    // 改名
    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    public void onEventToPlatform(RoleEditNickEvent event) {
        roleService.addSendToPlatformList(event.getRid());
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void onEventToCross(RoleEditNickEvent event) {
        roleService.sendRoleInfoToCross(event.getRid());
    }

    // 工会变化
    @Subscribe
    public void onEvent(ClanChangeEvent event) {
        roleService.sendToCrossImmediately(event.getRid(), event);
    }

    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    public void onEventToPlatform(ClanChangeEvent event) {
        roleService.addSendToPlatformList(event.getRid());
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void onEventToCross(ClanChangeEvent event) {
        roleService.sendRoleInfoToCross(event.getRid());
    }

    // 归属地区变化
    @Subscribe(async = Subscribe.AsyncType.Async)
    public void onEvent(RoleProvinceChangeEvent event) {
        roleService.sendRoleInfoToCross(event.getRid());
    }

    // 阵营英雄变化
    @Subscribe(async = Subscribe.AsyncType.Async)
    public void onEvent(LineUpChangeEvent event) {
        HeroLineUp heroLineUp = event.getHeroLineUp();
        if (Objects.nonNull(heroLineUp) && heroLineUp.getType() == LineUpType.MAIN.getValue()) {
            roleService.sendRoleInfoToCross(heroLineUp.getRid());
        }
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void onEvent(HeroStarUpEvent event) {
        Hero hero = event.getHero();
        if (heroLineUpService.isHeroInLineUp(hero.getRid(), hero.getId(), LineUpType.MAIN)) {
            roleService.sendRoleInfoToCross(hero.getRid());
        }
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void onEvent(HeroUpLevelEvent event) {
        Hero hero = event.getHero();
        if (heroLineUpService.isHeroInLineUp(hero.getRid(), hero.getId(), LineUpType.MAIN)) {
            roleService.sendRoleInfoToCross(hero.getRid());
        }
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void onEvent(RoleForbidChatEvent event) {
        GResRoleForbidChat resRoleForbidChat = GResRoleForbidChat.newBuilder()
                .setForbidWordsEndTime(event.getForbidWordsEndTime()).build();
        // 推送禁言
        contextManager.writeSome(event.getRids(), CmdCode._2017, resRoleForbidChat);
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void onEvent(RoleForbidEvent event) {
        GResRoleForbid resRoleForbid = GResRoleForbid.newBuilder().setForbidEndTime(event.getForbidEndTime()).build();
        contextManager.writeSome(event.getRids(), CmdCode._2018, resRoleForbid);
        event.getRids().forEach(rid -> {
            // 推送封号
            contextManager.playerOffline(rid, OfflineEvent.RoleObserver_onEvent_RoleForbidEvent);
        });
    }

    /**
     * 跨服连接完成之后，上报所有玩家
     */
    @Subscribe(async = Subscribe.AsyncType.Async)
    public void crossEvent(CrossConnectedEvent event) {
        int lastValue = 2;
        ServerParam serverParam = serverParamService.getOrCreate(ServerParamType.SEND_ALL_ROLE_TO_CROSS, () -> lastValue);
        if (Objects.nonNull(serverParam) && serverParam.parseJson(Integer.class) > lastValue) {
            return;
        }
        List<Role> roleList = roleService.getAllRole();
        roleList.forEach(role -> {
            roleService.sendRoleInfoToCross(role);
        });

        serverParam.setSpValue(String.valueOf(lastValue + 1));
        serverParamService.update(serverParam);
    }

    /**
     * 添加尊贵标识属性加成
     *
     * @param event
     */
    @Subscribe
    public void listen(LoginEvent event) {
        Role role = roleService.getOrThrow(event.getRid());
        if (role.getPeerageStatus() == 0) {
            role.setPeerageStatus(1);
            roleService.updateRole(role);
            eventBus.post(RolePeerageChangeEvent.of(event.getRid(), GameEvent.RECHARGE));
        }
        //检查是否发送创角邮件,规定时间内创角 & 邮件发送数量未超过目标数 & 今天未发送过邮件 & 未超过最大离线时长(日本版本)
        int serverLang = serverConfig.getServerLang();
        if (appointmentGiftSysCache.isLoginGift(serverLang) && role.getLoginMailInfo() != null &&
                role.getLoginMailInfo().getNum() < MailConst.SEND_CREATE_ROLE_MAIL_NUM &&
                role.getLoginMailInfo().getSendTime() < DateTimeUtil.dayBreak() &&
                role.getLastOfflineTime() > DateTimeUtil.currentSecond() - MailConst.SEND_CREATE_ROLE_MAIL_DAY_LIMIT * TimeConstants.ONE_DAY_SECOND) {
            //发送邮件数
            int mailNum = DateTimeUtil.apartDay(role.getLoginMailInfo().getSendTime(), DateTimeUtil.currentSecond());
            if (mailNum + role.getLoginMailInfo().getNum() > MailConst.SEND_CREATE_ROLE_MAIL_NUM) {
                mailNum = MailConst.SEND_CREATE_ROLE_MAIL_NUM - role.getLoginMailInfo().getNum();
            }
            role.getLoginMailInfo().setNum(role.getLoginMailInfo().getNum() + mailNum);
            role.getLoginMailInfo().setSendTime(DateTimeUtil.currentSecond());
            roleService.updateRole(role);

            Mail mail = mailService.newMailNoTitle(role.getId(), MailScene.CREATE_MAIL_REWARD2, null,
                    ImmutableThingUtil.multiplyThing(MailConst.createRoleMailRewardTwo, mailNum), GameEvent.CREATE_ROLE_MAIL);
            mailService.insert(mail);
        }
    }

    /**
     * 发送创角邮件
     *
     * @param event
     */
    @Subscribe
    public void listen(CreateRoleEvent event) {
        //创角时间在规定时间内(日本版本)
        int serverLang = serverConfig.getServerLang();
        if (appointmentGiftSysCache.isGift(serverLang) && event.getBordTime() <= serverParamService.getServerStartTime() +
                MailConst.OPEN_SERVICE_DAY_MAIL_LIMIT * TimeConstants.ONE_DAY_SECOND) {
            Role role = roleService.getOrThrow(event.getRid());

            List<Mail> mailList = new ArrayList<>();
            if (appointmentGiftSysCache.isCreateGift(serverLang)) {
                //创角邮件1
                Mail mail = mailService.newMailNoTitle(role.getId(), MailScene.CREATE_MAIL_REWARD1, null,
                        MailConst.createRoleMailRewardOne, GameEvent.CREATE_ROLE_MAIL);
                mailList.add(mail);
            }
            if (appointmentGiftSysCache.isLoginGift(serverLang)) {
                //创角邮件2
                Mail mail2 = mailService.newMailNoTitle(role.getId(), MailScene.CREATE_MAIL_REWARD2, null,
                        MailConst.createRoleMailRewardTwo, GameEvent.CREATE_ROLE_MAIL);
                mailList.add(mail2);
            }
            //记录邮件领取
            LoginMailInfo info = new LoginMailInfo();
            info.setNum(1);
            info.setSendTime(DateTimeUtil.currentSecond());
            role.setLoginMailInfo(info);
            roleService.updateRole(role);

            mailService.insertMails(mailList);
        }
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(RechargeEvent rechargeEvent) {
        RoleRecharge roleRecharge = roleRechargeService.getRoleRecharge(rechargeEvent.getRid());
        long oldRecharge = roleRecharge.getTotalRecharge() - rechargeEvent.getMoney();
        int oldLevel = peerageEmblemSysCache.getPeerageLevel(oldRecharge);
        int newLevel = peerageEmblemSysCache.getPeerageLevel(roleRecharge.getTotalRecharge());
        if (oldLevel < newLevel) {
            //若尊贵标识等级发生变化,推送新的等级
            RoleGMsg.GResActivePeerage.Builder builder = RoleGMsg.GResActivePeerage.newBuilder();
            builder.setLevel(newLevel);
            contextManager.write(rechargeEvent.getRid(), CmdCode._2024, builder.build());
            eventBus.post(RolePeerageChangeEvent.of(rechargeEvent.getRid(), GameEvent.RECHARGE));
        }
    }

    /**
     * 检测援助是否解锁
     *
     * @param event
     */
    @Subscribe
    public void onLoginEvent(LoginEvent event) {
        Role role = roleService.getOrThrow(event.getRid());
        if (role.isAssistanceUnlock()) {
            return;
        }

        if (heroService.assistanceUnlock(event.getRid())) {
            role.setAssistanceUnlock(true);
            roleService.updateRole(role);
        }
    }

    @Subscribe
    public void onLoginToPutBuryingData(LoginEvent event) {
        roleService.updateLastGuideTime(event.getRid(), LocalDateTime.now().withNano(0));
    }
}
