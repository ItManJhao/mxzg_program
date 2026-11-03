package com.ayjs.mxzg.gameserver.module.timeLimitItem.service;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.timeLimitItem.dao.LimitItemInfoDao;
import com.ayjs.mxzg.gameserver.module.timeLimitItem.domain.LimitItemInfo;
import com.ayjs.mxzg.gameserver.module.timeLimitItem.event.TimeLimitItemEvent;
import com.ayjs.mxzg.protocol.BackPackGMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class LimitItemInfoService {

    @Autowired
    private LimitItemInfoDao limitItemInfoDao;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private ContextManager contextManager;

    public void add(LimitItemInfo limitItemInfo) {
        limitItemInfoDao.add(limitItemInfo);
    }

    public void addList(List<LimitItemInfo> list) {
        limitItemInfoDao.add(list);
        eventBus.post(TimeLimitItemEvent.of(list.get(0).getRid(), list, null));

        this.sendLimitItemInfo(list.get(0).getRid());
    }

    private List<LimitItemInfo> getAll(long rid) {
        return limitItemInfoDao.list("rid", rid);
    }

    private List<LimitItemInfo> selectList(long rid) {
        List<LimitItemInfo> delList = getAll(rid).stream().filter(limitItemInfo -> limitItemInfo.getEndTime() <= DateTimeUtil.currentSecond()).collect(Collectors.toList());
        if (!delList.isEmpty()) {
            deleteList(delList);
        }
        return getAll(rid);
    }

    private void deleteList(List<LimitItemInfo> list) {
        limitItemInfoDao.remove(list);
        eventBus.post(TimeLimitItemEvent.of(list.get(0).getRid(), null, list));
    }

    public void sendLimitItemInfo(long rid) {
        BackPackGMsg.GResTimeLimitList.Builder builder = BackPackGMsg.GResTimeLimitList.newBuilder();

        List<LimitItemInfo> limitItemInfoList = this.selectList(rid);

        limitItemInfoList.forEach(limitItemInfo -> {
            builder.addList(builderTimeLimitItem(limitItemInfo));
        });

        contextManager.write(rid, CmdCode._5010, builder.build());
    }

    private BackPackGMsg.ResTimeLimitItem.Builder builderTimeLimitItem(LimitItemInfo limitItemInfo) {
        BackPackGMsg.ResTimeLimitItem.Builder builder = BackPackGMsg.ResTimeLimitItem.newBuilder();
        builder.setItemId(limitItemInfo.getId());
        builder.setItemType(limitItemInfo.getItemType());
        builder.setEndTime(limitItemInfo.getEndTime());
        return builder;
    }


}
