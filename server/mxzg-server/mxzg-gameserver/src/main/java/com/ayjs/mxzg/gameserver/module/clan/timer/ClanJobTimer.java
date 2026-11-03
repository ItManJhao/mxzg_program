package com.ayjs.mxzg.gameserver.module.clan.timer;

import com.ayjs.mxzg.gameserver.module.clan.service.ClanService;
import com.ayjs.mxzg.template.scheduler.service.AbstractCronTask;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * 公会职位定时器
 * @author hyx
 */
@Component
public class ClanJobTimer extends AbstractCronTask {

    @Autowired
    private ClanService clanService;

    @Override
    public Object identity() {
        return "ClanJobTimer";
    }

    @Override
    public String expression() {
        return "0 0 4 * * ?";
    }

    @Override
    public void run() {
        clanService.clanJob();
    }
}