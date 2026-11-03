package com.ayjs.mxzg.gameserver.module.clan.timer;


import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.clan.domain.Clan;
import com.ayjs.mxzg.gameserver.module.clan.service.ClanService;
import com.ayjs.mxzg.template.scheduler.service.AbstractCronTask;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

/**
 * 更新公会捐献及成员捐献
 */
@Component
public class ClanDonateTimer extends AbstractCronTask {

    @Autowired
    private ClanService clanService;
    @Autowired
    private ContextManager contextManager;

    @Override
    public Object identity() {
        return "ClanDonateTimer";
    }

    @Override
    public String expression() {
        return "0 0 0 * * ?";
    }

    @Override
    public void run() {
        List<Clan> clanList = clanService.selectAll();
        for (Clan clan : clanList) {
            clan.setClanDonate(0);
        }
        clanService.updateClanList(clanList);

        new ArrayList<>(contextManager.getAllOnline()).forEach(context -> {
            Clan roleClan = clanService.getRole2Clan(context.getId());
            if (Objects.nonNull(roleClan)) {
                contextManager.write(context.getId(), CmdCode._7041, clanService.donateList(context.getId(), roleClan));
            }
        });
    }
}
