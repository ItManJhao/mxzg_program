package com.ayjs.mxzg.gameserver.module.role.service;

import com.ayjs.mxzg.common.lifecycle.Lifecycle;
import com.ayjs.mxzg.common.lifecycle.LifecycleInfo;
import com.ayjs.mxzg.common.util.NamesThreadFactory;
import com.ayjs.mxzg.gameserver.module.clan.service.ClanService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.ScheduledThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

@Slf4j
@Component
public class RoleSendToPlatformCrossLifecycle implements Lifecycle {

    private static int period = 60;

    @Autowired
    private RoleService roleService;
    @Autowired
    private ClanService clanService;

    private ScheduledExecutorService pool = new ScheduledThreadPoolExecutor(2, new NamesThreadFactory("RoleSendToPlatformCross"));

    @Override
    public LifecycleInfo getInfo() {
        return LifecycleInfo.valueOf("RoleSendToPlatformCrossLifecycle");
    }

    @Override
    public void start() throws Exception {
        pool.scheduleAtFixedRate(() -> {
                    try {
                        roleService.sendToCross();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                },
                period,
                period,
                TimeUnit.SECONDS);

        pool.scheduleAtFixedRate(() -> {
                    try {
                        roleService.sendToPlatform();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                },
                period,
                period,
                TimeUnit.SECONDS);

        pool.scheduleAtFixedRate(() -> {
                    try {
                        clanService.sendToCross();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                },
                period,
                period,
                TimeUnit.SECONDS);
    }

    @Override
    public void stop() throws Exception {
        roleService.sendToCross();
        roleService.sendToPlatform();
        clanService.sendToCross();
        pool.shutdown();
    }
}
