package com.ayjs.mxzg.gameserver.module.friend.observer;


import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.TimeConstants;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.friend.domain.Relationship;
import com.ayjs.mxzg.gameserver.module.friend.service.RelationshipService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.event.LoginEvent;
import com.ayjs.mxzg.gameserver.module.role.event.LogoutEvent;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.protocol.FriendGMsg;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 好友上下线事件监听
 */
@Observer
public class FriendObserver {

    @Autowired
    private RoleService roleService;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private RelationshipService relationshipService;

    /**
     * 下线监听
     */
    @Subscribe
    public void friendLogout(LogoutEvent event){
        Role role = roleService.getOrThrow(event.getRid());
        Map<Long, Relationship> shipMap = relationshipService.getShipMap(event.getRid());
        if(shipMap.size() > 0){
            List<Long> ridsList = new ArrayList<>(shipMap.keySet());
            FriendGMsg.GResFriendsOnlineRadio.Builder builder = FriendGMsg.GResFriendsOnlineRadio.newBuilder();
            builder.setRid(event.getRid());
            builder.setOnline(0);
            builder.setOfflineTime((int) (role.getLastOfflineTime()/TimeConstants.ONE_SECOND_MILLIS));
            contextManager.writeSome(ridsList, CmdCode._9014,builder.build());
        }

    }

    /**
     * 上线监听
     */
    @Subscribe
    public void friendLogin(LoginEvent event){

        Map<Long, Relationship> shipMap = relationshipService.getShipMap(event.getRid());
        if(shipMap.size() > 0){
            List<Long> ridsList = new ArrayList<>(shipMap.keySet());
            FriendGMsg.GResFriendsOnlineRadio.Builder builder = FriendGMsg.GResFriendsOnlineRadio.newBuilder();
            builder.setRid(event.getRid());
            builder.setOnline(1);
            builder.setOfflineTime((int) (event.getLoginTime()/TimeConstants.ONE_SECOND_MILLIS));
            contextManager.writeSome(ridsList, CmdCode._9014,builder.build());
        }

    }
}
