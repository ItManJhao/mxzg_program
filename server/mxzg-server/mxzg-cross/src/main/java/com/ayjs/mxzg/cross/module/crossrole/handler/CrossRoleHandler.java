package com.ayjs.mxzg.cross.module.crossrole.handler;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Objects;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.util.InternerPool;
import com.ayjs.mxzg.cross.module.crossrole.dao.CrossRoleDao;
import com.ayjs.mxzg.cross.module.crossrole.event.RoleFightChangeEvent;
import com.ayjs.mxzg.message.module.role.domain.CrossRole;
import com.ayjs.mxzg.message.module.role.message.CrossRoleUpdateMessage;
import com.ayjs.mxzg.message.module.role.message.CrossRoleUpdateMessageList;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.dispatcher.MessageHandler;

import cn.hutool.core.collection.CollectionUtil;

@Service
public class CrossRoleHandler implements MessageHandler {

    private static final String PREFIX = "CROSS_ROLE";

    @Autowired
    private CrossRoleDao crossRoleDao;
    @Autowired
    private EventBus eventBus;

    /**
     * 批量更新角色数据
     *
     * @param reqMessage
     */
    @RemoteMethod
    public void crossRoleUpdate(CrossRoleUpdateMessageList reqMessage) {
    	crossRoleUpdate(reqMessage.getList());
    }
    /**
     * 更新角色数据
     *
     * @param message
     */
    @RemoteMethod
    public void crossRoleUpdate(CrossRoleUpdateMessage message) {
    	crossRoleUpdate(Collections.singletonList(message));
    }
    
    
    private void crossRoleUpdate(List<CrossRoleUpdateMessage> roleMessageList) {
    	List<CrossRole> fightChangeList = new ArrayList<>();
        List<CrossRole> updateList = new ArrayList<>();
        for (CrossRoleUpdateMessage message : roleMessageList) {
            long rid = message.getId();
            CrossRole crossRole = crossRoleDao.get(rid);
            if (Objects.isNull(crossRole)) {
                synchronized (InternerPool.intern(PREFIX, rid)) {
                    crossRole = crossRoleDao.get(rid);
                    if (crossRole == null) {
                        crossRole = message.toCrossRole();
                        crossRoleDao.add(crossRole);
                        fightChangeList.add(crossRole);
                    }
                }
            } else {
            	if (crossRole.getFighting() != message.getFighting()) {
            		fightChangeList.add(crossRole);
            	}
            	message.fillCrossRole(crossRole);
                updateList.add(crossRole);
            }
        }
        crossRoleDao.update(updateList);
        if (CollectionUtil.isNotEmpty(fightChangeList)) {
            fightChangeList.forEach(crossRole -> {
                eventBus.post(RoleFightChangeEvent.of(crossRole.getId(), crossRole.getFighting(), crossRole.getServerId()));
            });
        }
    }
}
