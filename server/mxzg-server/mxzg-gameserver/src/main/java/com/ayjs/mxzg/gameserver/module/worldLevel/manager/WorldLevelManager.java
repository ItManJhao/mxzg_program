package com.ayjs.mxzg.gameserver.module.worldLevel.manager;

import com.ayjs.mxzg.common.lifecycle.Lifecycle;
import com.ayjs.mxzg.common.lifecycle.LifecycleInfo;
import com.ayjs.mxzg.common.scheduler.CommonScheduledHolder;
import com.ayjs.mxzg.common.util.time.LocalDateTimeUtil;
import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.server.service.ServerParamService;
import com.ayjs.mxzg.gameserver.module.worldLevel.service.WorldLevelService;
import com.ayjs.mxzg.message.center.ReportServerInfoMessage;
import com.ayjs.mxzg.protocol.WorldLevelGMsg;
import com.ayjs.rpc.dispatcher.MessageDispatcher;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.util.CollectionUtils;

import java.time.LocalDateTime;
import java.util.Comparator;
import java.util.List;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicBoolean;

/**
 * 世界等级管理者5分钟统计一次世界等级，并推送到跨服
 */
@Slf4j
@Component
public class WorldLevelManager implements Lifecycle {

    /** 当前世界等级 */
    private volatile int currentWorldLevel = -1;

    /** 活跃的玩家数量 */
    private volatile int activePlayersNumber = -1;

    @Autowired
    private ServerConfig serverConfig;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private RoleService roleService;
    @Autowired
    private SystemSysCache systemSysCache;
    @Autowired
    private MessageDispatcher messageDispatcher;
    @Autowired
    private ServerParamService serverParamService;

    private AtomicBoolean running = new AtomicBoolean(false);


    private ScheduledExecutorService executorService = CommonScheduledHolder.getScheduledExecutorService();

    @Override
    public LifecycleInfo getInfo() {
        return LifecycleInfo.valueOf("WORLD_LEVEL");
    }

    /**
     * 启动定时器定时向中心服发送信息
     */
    @Override
    public void start(){
        if(running.compareAndSet(false, true)){
            executorService.scheduleWithFixedDelay(()-> {
                this.currentWorldLevel = calWorldLevel();
                reportServerInfo();
                pushWorldLevel();
            }, 5, 5, TimeUnit.MINUTES);
        }
    }

    /**
     * 报告服务器信息
     */
    private void reportServerInfo(){
        try {
            ReportServerInfoMessage message = buildServerInfoMessage();
            messageDispatcher.dispatch(message);
            log.info("向中心服报告世界等级:{}开服时间:{}", currentWorldLevel, message.getOpenServerTime());
        } catch (Exception ex){
            ex.printStackTrace();
        }
    }

    /**
     * 推送世界等级
     */
    public void pushWorldLevel(){
        WorldLevelGMsg.GResWorldLevel.Builder builder = WorldLevelGMsg.GResWorldLevel.newBuilder();
        builder.setLevel(this.currentWorldLevel);
        contextManager.writeAll(CmdCode._51001, builder.build());
    }

    /**
     * 构造服务器信息消息
     * @return
     */
    public ReportServerInfoMessage buildServerInfoMessage(){
        activePlayersNumber = calActivePlayersNumber();
        int serverStartTime = serverParamService.getServerStartTime();
        LocalDateTime openServerTime = LocalDateTimeUtil.ofEpochSecond(serverStartTime);
        return ReportServerInfoMessage.of(serverConfig.getSubServerIds(), currentWorldLevel, activePlayersNumber, openServerTime);
    }

    /**
     * 获取世界等级
     * @return
     */
    public int getWorldLevel() {
        if(currentWorldLevel == -1){
            currentWorldLevel = calWorldLevel();
        }
        return currentWorldLevel;
    }

    /**
     * 计算世界等级
     * @return
     */
    private int calWorldLevel(){
        List<Role> roleList = roleService.getAllRole();
        if (CollectionUtils.isEmpty(roleList)) {
            return 1;
        } else{
            double level = roleService.getAllRole().stream().sorted(Comparator.comparingInt(Role::getLevel).reversed())
                    .limit(systemSysCache.getWorldLevelPeople()).mapToInt(Role::getLevel).average().getAsDouble();
            return (int) level;
        }
    }

    /**
     * 获取7天活跃玩家数量
     * @return
     */
    public int getActivePlayersNumber(){
        if(this.activePlayersNumber == -1){
            this.activePlayersNumber = calActivePlayersNumber();
        }
        return this.activePlayersNumber;
    }

    /**
     * 计算活跃的玩家数
     * @return
     */
    private int calActivePlayersNumber(){
        int needDays = systemSysCache.getActivePlayerNeedLoginDays();
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime activeDays = now.minusDays(needDays);
        long activeThreshold = LocalDateTimeUtil.toEpochMilli(activeDays);
        List<Role> roleList = roleService.getAllRole();
        if (CollectionUtils.isEmpty(roleList)) {
            return 1;
        } else {
            return (int)roleService.getAllRole().stream().filter(role -> role.isActive(activeThreshold)).count();
        }
    }

}
