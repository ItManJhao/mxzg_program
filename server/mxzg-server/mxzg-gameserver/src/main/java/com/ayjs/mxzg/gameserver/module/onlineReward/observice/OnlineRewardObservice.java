package com.ayjs.mxzg.gameserver.module.onlineReward.observice;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.util.time.TimeConstants;
import com.ayjs.mxzg.config.excel.cache.PromotionOnlineRewardSysCache;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.monthCard.event.MonthCardActiveEvent;
import com.ayjs.mxzg.gameserver.module.onlineReward.domain.OnlineReward;
import com.ayjs.mxzg.gameserver.module.onlineReward.service.OnlineRewardService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.event.LoginEvent;
import com.ayjs.mxzg.gameserver.module.role.event.LogoutEvent;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.protocol.OnlineRewardGMsg;
import org.springframework.beans.factory.annotation.Autowired;

@Observer
public class OnlineRewardObservice {

    @Autowired
    private RoleService roleService;
    @Autowired
    private OnlineRewardService onlineRewardService;
    @Autowired
    private PromotionOnlineRewardSysCache promotionOnlineRewardSysCache;
    @Autowired
    private ContextManager contextManager;

    @Subscribe
    public void initOnlineTime(LoginEvent event) {
       this.sendOnlineRewardList(event.getRid());
    }

    @Subscribe
    public void updateOnlineTime(LogoutEvent event) {
        OnlineReward onlineReward = onlineRewardService.getOnlineReward(event.getRid());
        if (onlineReward.getRewards().size() == promotionOnlineRewardSysCache.getAll().size()) {
            return;
        }
        Role role = roleService.getOrThrow(event.getRid());
        int time = (int) ((role.getLastOfflineTime() - role.getLastLoginTime()) / TimeConstants.ONE_SECOND_MILLIS);
        if (time < 0) {
            time = 0;
        }
        onlineReward.setOnlineTime(onlineReward.getOnlineTime() + time);
        onlineReward.setTodayOnlineTime(onlineReward.getTodayOnlineTime() + time);
        onlineRewardService.updateOnlineReward(onlineReward);
    }

    @Subscribe
    public void listen(MonthCardActiveEvent event){
        this.sendOnlineRewardList(event.getRid());
    }

    private void sendOnlineRewardList(long rid){
        OnlineReward onlineReward = onlineRewardService.getOnlineReward(rid);
        if (onlineReward.getRewards().size() == promotionOnlineRewardSysCache.getAll().size()) {
            return;
        }
        OnlineRewardGMsg.GResInitOnlineRewardData.Builder builder
                = OnlineRewardGMsg.GResInitOnlineRewardData.newBuilder();
        builder.setOnlineTime(onlineReward.getOnlineTime());
        builder.addAllIdxList(onlineRewardService.getOnlineList(onlineReward));
        builder.addAllOnceAgainList(onlineReward.getOnceAgainList());
        contextManager.write(rid, CmdCode._25001, builder.build());
    }
    // 暂时屏蔽，后面需要再补回来
//    @Subscribe(async = Subscribe.AsyncType.Sync)
//    public void onEvent(ZeroTimeEvent event){
//        contextManager.getAllOnline().forEach(playerContext -> roleService.sendRoleInfoToPlatform(playerContext.getId()));
//    }
}
