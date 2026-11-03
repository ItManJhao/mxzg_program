package com.ayjs.mxzg.gameserver.infrastructure.netty;

/**
 * 离线事件
 */
public interface OfflineEvent {
    int ContextManager_stop = 1;
    int NettyHandler_channelInactive = 2;
    int LoginHandler_login = 3;
    int LoginHandler_offline = 4;
    int RoleObserver_onEvent_RoleForbidEvent = 5;
    int RoleApi_offlineAll = 6;
}
