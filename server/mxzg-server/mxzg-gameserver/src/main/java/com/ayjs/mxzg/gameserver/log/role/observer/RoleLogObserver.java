package com.ayjs.mxzg.gameserver.log.role.observer;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.LocalDateTimeUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.log.role.domain.*;
import com.ayjs.mxzg.gameserver.module.backpack.event.HeroExpAddEvent;
import com.ayjs.mxzg.gameserver.module.backpack.event.HeroExpCostEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.RoleFightChangeEvent;
import com.ayjs.mxzg.gameserver.module.recharge.event.VirtualRechargeEvent;
import com.ayjs.mxzg.gameserver.module.role.event.*;
import com.ayjs.mxzg.gameserver.module.statistic.event.RoleStatisticDailyEvent;
import com.ayjs.mxzg.template.log.LogEntityFactory;
import com.ayjs.mxzg.template.log.LogService;
import org.springframework.beans.factory.annotation.Autowired;

import java.text.DecimalFormat;
import java.time.Duration;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.Optional;

@Observer
public class RoleLogObserver {

    @Autowired
    private LogEntityFactory logEntityFactory;
    @Autowired
    private LogService logService;
    @Autowired
    private ServerConfig serverConfig;

    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    private void onEvent(LoginEvent event) {
        RoleLoginLog log = logEntityFactory.create(RoleLoginLog.class);
        log.setOpenid("" + event.getUserId());
        log.setRid(event.getRid());
        log.setLoginTime(event.getLoginTime());
        log.setLevel(event.getLevel());
        log.setLoginType(event.getLoginType());
        log.setIp(event.getIp());
        log.setBornTime(event.getBordTime());
        log.setPlace(event.getPlace());
        log.setDeviceId(Optional.of(event.getDeviceId()).orElse(""));
        logService.addLog(log);
    }

    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    private void onEvent(CreateRoleEvent event) {
        RoleLoginLog log = logEntityFactory.create(RoleLoginLog.class);
        log.setOpenid("" + event.getUserId());
        log.setRid(event.getRid());
        log.setLoginTime(event.getLoginTime());
        log.setLevel(event.getLevel());
        log.setLoginType(event.getLoginType());
        log.setIp(event.getIp());
        log.setBornTime(event.getBordTime());
        log.setPlace(event.getPlace());
        log.setDeviceId(Optional.of(event.getDeviceId()).orElse(""));
        logService.addLog(log);

        RoleCreateLog createLog = logEntityFactory.create(RoleCreateLog.class);
        createLog.setOpenid("" + event.getUserId());
        createLog.setRid(event.getRid());
        createLog.setLoginTime(event.getLoginTime());
        createLog.setLoginType(event.getLoginType());
        createLog.setIp(event.getIp());
        createLog.setPlace(event.getPlace());
        createLog.setDeviceId(Optional.of(event.getDeviceId()).orElse(""));
        logService.addLog(createLog);
    }

    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    private void gmCommandLog(GMCommandEvent event) {
        GMCommandLog log = logEntityFactory.create(GMCommandLog.class);
        log.setRid(event.getRid());
        log.setCommand(event.getCommand());
        log.setParams(event.getParams());
        log.setDateTime(LocalDateTime.now());
        logService.addLog(log);
    }

    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    private void listen(RoleFightChangeEvent event) {
        if (event.getCurrFighting() < 50000 && event.getOriFighting() < 50000){
            return ;
        }
        RoleFightingLog log = logEntityFactory.create(RoleFightingLog.class);
        log.setRid(event.getRid());
        log.setDelta(event.getCurrFighting() - event.getOriFighting());
        log.setCurr(event.getCurrFighting());
        log.setTime(TimeDateUtil.getCurrentTimeInt());
        log.setEvent(event.getGameEvent().getValue());
        log.setEventDesc(event.getGameEvent().getRemark());
        logService.addLog(log);
    }

    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    private void listen(RoleExpAddEvent event) {
        if (event.getCurrLv() < 20){
            return;
        }
        RoleExpLog log = logEntityFactory.create(RoleExpLog.class);
        log.setRid(event.getRid());
        log.setDelta(event.getAddCount());
        log.setCurr(event.getCurr());
        log.setOldLv(event.getOldLv());
        log.setCurrLv(event.getCurrLv());
        log.setTime(TimeDateUtil.getCurrentTimeInt());
        log.setEvent(event.getGameEvent().getValue());
        log.setEventDesc(event.getGameEvent().getRemark());
        logService.addLog(log);
    }

    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    private void listen(HeroExpAddEvent event) {
        HeroExpLog log = logEntityFactory.create(HeroExpLog.class);
        log.setRid(event.getRid());
        log.setDelta(event.getAddCount());
        log.setCurr(event.getCurr());
        log.setTime(TimeDateUtil.getCurrentTimeInt());
        log.setEvent(event.getGameEvent().getValue());
        log.setEventDesc(event.getGameEvent().getRemark());
        logService.addLog(log);
    }

    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    private void listen(HeroExpCostEvent event) {
        HeroExpLog log = logEntityFactory.create(HeroExpLog.class);
        log.setRid(event.getRid());
        log.setDelta(-event.getCostCount());
        log.setCurr(event.getCurr());
        log.setTime(TimeDateUtil.getCurrentTimeInt());
        log.setEvent(event.getGameEvent().getValue());
        log.setEventDesc(event.getGameEvent().getRemark());
        logService.addLog(log);
    }

    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    private void listen(StatisticsOnlineEvent event) {
        OnlineNumLog log = logEntityFactory.create(OnlineNumLog.class);
        log.setOnlineNum(event.getOnlineNum());
        log.setRecordTime(event.getTime());
        log.setServerId(serverConfig.getServerId());
        log.setDistinctOnlineNum(event.getDistinctOnlineNum());
        log.setPlace(serverConfig.getServerPlatformSonId());
        logService.addLog(log);
    }


    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    private void listen(VirtualRechargeEvent event) {
        VirtualRechargeLog log = logEntityFactory.create(VirtualRechargeLog.class);
        log.setRid(event.getRid());
        log.setProductId(event.getProductId());
        log.setTime(TimeDateUtil.getCurrentTimeInt());
        log.setSuccess(event.getSuccess());
        log.setCard(event.getCard());
        logService.addLog(log);
    }

    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    private void listen(RoleEditNickEvent event) {
        RoleRenameNickLog log = logEntityFactory.create(RoleRenameNickLog.class);
        log.setRid(event.getRid());
        log.setNewNick(event.getNewNick());
        log.setOldNick(event.getOldNick());
        log.setRenameTime(DateTimeUtil.currentSecond());
        logService.addLog(log);
    }

    // 登出
    @Subscribe(async = Subscribe.AsyncType.Async)
    public void onEventToCross(LogoutEvent event) {
        RoleLogoutLog log = logEntityFactory.create(RoleLogoutLog.class);
        log.setOpenid("" + event.getUserId());
        log.setRid(event.getRid());
        log.setLogoutTime(event.getLogoutTime());
        log.setLevel(event.getLevel());
        log.setOnlineTime(event.getOnlineTime());
        log.setEventId(event.getEventId());
        logService.addLog(log);
    }

    // 个人资源统计
    @Subscribe(async = Subscribe.AsyncType.Async)
    public void statisticDaily(RoleStatisticDailyEvent event) {
        RoleStatisticDailyLog log = logEntityFactory.create(RoleStatisticDailyLog.class);
        log.setRid(event.getRid());
        log.setItems(event.getItemMap());
        log.setHeroes(event.getHeroMap());
        logService.addLog(log);
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void buryingPoint(BuryingPointEvent event) {
        RoleBuryingPointLog log = logEntityFactory.create(RoleBuryingPointLog.class);
        log.setRid(event.getRid());
        log.setIdx(event.getIdx());
        LocalDateTime now = LocalDateTime.now().withNano(0);
        LocalDateTime time = event.getLastGuideTime().withNano(0);
        log.setCurStartTime(now);
        log.setStayTime(Duration.between(time, now).toMillis()/ 1000);
        log.setLastGuideTime(time);
        logService.addLog(log);
    }

}
