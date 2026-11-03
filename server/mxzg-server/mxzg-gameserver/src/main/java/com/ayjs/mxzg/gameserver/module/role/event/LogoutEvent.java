package com.ayjs.mxzg.gameserver.module.role.event;

import lombok.Value;

/**
 * @Author: CWJ
 * @Date: 2019/10/19
 **/
@Value(staticConstructor = "of")
public class LogoutEvent {
    private long rid;

    private int eventId;

    /**
     * 角色id
     */
    private long userId;
    /**
     * 平台id
     */
    private int platform;
    /**
     * 等级
     */
    private int level;

    /**
     * 登出时间
     */
    private int logoutTime;

    /**
     * 在线时间
     */
    private int onlineTime;
}
