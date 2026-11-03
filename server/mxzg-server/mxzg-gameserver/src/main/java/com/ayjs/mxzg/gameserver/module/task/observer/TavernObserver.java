package com.ayjs.mxzg.gameserver.module.task.observer;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.config.excel.constant.TavernConst;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PrivilegeType;
import com.ayjs.mxzg.gameserver.module.promotionNew.event.BuyPrivilegeEvent;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion010PrivilegeGiftService;
import com.ayjs.mxzg.gameserver.module.role.event.CreateRoleEvent;
import com.ayjs.mxzg.gameserver.module.task.domain.TavernInfo;
import com.ayjs.mxzg.gameserver.module.task.domain.TavernTask;
import com.ayjs.mxzg.gameserver.module.task.event.TavernAdventureEvent;
import com.ayjs.mxzg.gameserver.module.task.service.TavernInfoService;
import com.ayjs.mxzg.gameserver.module.task.service.TavernTaskService;
import com.ayjs.mxzg.protocol.PubTaskGMsg;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;

/**
 * 酒馆监听
 *
 * @author hyx
 */
@Observer
public class TavernObserver {

    @Autowired
    private TavernInfoService tavernInfoService;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private TavernTaskService tavernTaskService;
    @Autowired
    private Promotion010PrivilegeGiftService promotion010PrivilegeGiftService;

    @Subscribe
    public void listen(TavernAdventureEvent event) {
        PubTaskGMsg.GResPubAdventureCount.Builder builder = PubTaskGMsg.GResPubAdventureCount.newBuilder();
        TavernInfo tavernInfo = tavernInfoService.getTavernInfo(event.getRid());
        builder.setAdventureCount(tavernInfo.getAdventureCount());
        contextManager.write(event.getRid(), CmdCode._13027, builder.build());
    }

    /**
     * 购买酒馆特权更新酒馆列表
     *
     * @param event
     */
    @Subscribe
    private void listen(BuyPrivilegeEvent event) {
        if (event.getPrivilegeType() == PrivilegeType.TAVERN_LUXURY ||
                event.getPrivilegeType() == PrivilegeType.TAVERN_HIGH) {
            TavernInfo pubInfo = tavernInfoService.getTavernInfo(event.getRid());
            PubTaskGMsg.GResPubTaskList.Builder builder = PubTaskGMsg.GResPubTaskList.newBuilder();
            // 获取酒馆表记录的任务
            for (TavernTask tavern : tavernTaskService.getTavernTasks(event.getRid())) {
                builder.addList(tavernTaskService.serialize(tavern));
            }
            builder.setFreeRefresh(TavernConst.TAVERN_FRESHEN_TIMES - pubInfo.getFreeRefresh());
            builder.setLuxury(promotion010PrivilegeGiftService.isPrivilegeActive(event.getRid(), PrivilegeType.TAVERN_LUXURY) ? 1 : 0);
            builder.setHigh(promotion010PrivilegeGiftService.isPrivilegeActive(event.getRid(), PrivilegeType.TAVERN_HIGH) ? 1 : 0);
            builder.setAdventureCount(pubInfo.getAdventureCount());
            contextManager.write(event.getRid(), CmdCode._13021, builder.build());
        }
    }

}
