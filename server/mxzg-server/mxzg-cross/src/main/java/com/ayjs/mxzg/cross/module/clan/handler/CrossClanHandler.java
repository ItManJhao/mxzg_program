package com.ayjs.mxzg.cross.module.clan.handler;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.util.ReflectionUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.cross.module.clan.dao.CrossClanDao;
import com.ayjs.mxzg.cross.module.clan.domain.CrossClan;
import com.ayjs.mxzg.cross.module.clan.event.ClanChangeEvent;
import com.ayjs.mxzg.cross.module.clan.event.ClanFightChangeEvent;
import com.ayjs.mxzg.cross.module.crossservice.SessionManager;
import com.ayjs.mxzg.cross.module.rank.service.impl.CrossClanRankService;
import com.ayjs.mxzg.message.center.dto.CrossGroup;
import com.ayjs.mxzg.message.module.clan.MemberChangeClanMessage;
import com.ayjs.mxzg.message.module.clan.UpdateCrossClanListMessage;
import com.ayjs.mxzg.message.module.clan.UpdateCrossClanMessage;
import com.ayjs.mxzg.message.module.rank.ResCrossClanRankMessage;
import com.ayjs.mxzg.message.module.rank.dto.CrossClanRank;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.dispatcher.MessageHandler;
import com.ayjs.rpc.server.Connection;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

/**
 * @Author: CWJ
 * @Date: 2019/12/18
 **/
@Slf4j
@Component
public class CrossClanHandler implements MessageHandler {

    @Autowired
    private CrossClanDao crossClanDao;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private CrossClanRankService crossClanRankService;
    @Autowired
    private SessionManager sessionManager;

    @RemoteMethod
    public void updateCrossClan(UpdateCrossClanMessage message, Connection connection) {
        if (message.getId() == 0) {
            log.error("message error!clan id:" + message.getId());
            return;
        }

        CrossClan crossClan = crossClanDao.get(message.getId());

        if (message.isRemove()) {
            if (crossClan != null)
                crossClanDao.remove(crossClan);
            eventBus.post(ClanFightChangeEvent.of(message.getId(), 0, message.getServerId()));
            return;
        }

        if (crossClan == null) {
            crossClan = new CrossClan();
            crossClan.setId(message.getId());
            updateData(message, crossClan);
            crossClanDao.add(crossClan);

            CrossGroup group = sessionManager.getGroupByClientId(connection.getClientId());
            if (Objects.nonNull(group)) {
                List<CrossClanRank> ranks = crossClanRankService.getAll(group.getGroupId());
                ResCrossClanRankMessage rankMessage = ResCrossClanRankMessage.createOf(ranks);
                connection.send(rankMessage);
            }
        } else {
            if (message.isRemove()) {
                crossClanDao.remove(crossClan);
                return;
            }
            updateData(message, crossClan);
            crossClanDao.update(crossClan);
        }
    }

    @RemoteMethod
    public void updateCrossClan(UpdateCrossClanListMessage listMessage, Connection connection) {
        List<UpdateCrossClanMessage> list = listMessage.getList();
        if (CollectionUtil.isEmpty(list)) {
            log.error("message error!clan is empty");
            return;
        }

        boolean updateToGroup = false;
        List<CrossClan> updateClan = new ArrayList<>();
        for (UpdateCrossClanMessage message : list) {
            CrossClan crossClan = crossClanDao.get(message.getId());
            if (message.isRemove()) {
                if (crossClan != null) {
                    crossClanDao.remove(crossClan);
                }
                eventBus.post(ClanFightChangeEvent.of(message.getId(), 0, message.getServerId()));
                continue;
            }

            if (crossClan == null) {
                crossClan = new CrossClan();
                crossClan.setId(message.getId());
                updateData(message, crossClan);
                crossClanDao.add(crossClan);

                updateToGroup = true;

            } else {
                updateData(message, crossClan);
                updateClan.add(crossClan);
            }
        }
        crossClanDao.update(updateClan);

        if (updateToGroup) {
            CrossGroup group = sessionManager.getGroupByClientId(connection.getClientId());
            if (Objects.nonNull(group)) {
                List<CrossClanRank> ranks = crossClanRankService.getAll(group.getGroupId());
                ResCrossClanRankMessage rankMessage = ResCrossClanRankMessage.createOf(ranks);
                connection.send(rankMessage);
            }
        }
    }

    private void updateData(UpdateCrossClanMessage message, CrossClan crossClan) {
//        crossClan.setClanFighting(message.getClanFighting());
//        crossClan.setClanHeadName(message.getClanHeadName());
        crossClan.setClanHeadRid(message.getClanHeadRid());
        crossClan.setClanIcon(message.getClanIcon());
        crossClan.setClanLevel(message.getClanLevel());
        crossClan.setCreateTime(message.getCreateTime());
        crossClan.setServerId(message.getServerId());
        crossClan.setClanHeadName(message.getClanHeadName());
        crossClan.setClanName(message.getClanName());
        crossClan.setServerOpenTime(message.getServerOpenTime());
        if (crossClan.getClanFighting() != message.getClanFighting()) {
            crossClan.setFightingUpdateTime(TimeDateUtil.getCurrentTimeInt());
            crossClan.setClanFighting(message.getClanFighting());
            eventBus.post(ClanFightChangeEvent.of(crossClan.getId(), crossClan.getClanFighting(), crossClan.getServerId()));
        }
//        crossClanRankService.markChange(crossClan.getServerId());
    }

    @RemoteMethod
    public void memberChangeClan(MemberChangeClanMessage message) {
        eventBus.post(ClanChangeEvent.of(message.getRid(), message.getNewClanId(), message.getOldClanId()));
    }

    public static void main(String[] args) {
        Method[] declaredMethodsWith = ReflectionUtil.getDeclaredMethodsWith(CrossClanHandler.class, RemoteMethod.class);
        for (Method method : declaredMethodsWith) {
            System.out.println(method.getName());
        }
    }
}
