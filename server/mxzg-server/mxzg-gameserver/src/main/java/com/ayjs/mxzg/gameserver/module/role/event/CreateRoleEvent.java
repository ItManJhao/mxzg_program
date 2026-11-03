package com.ayjs.mxzg.gameserver.module.role.event;

import lombok.Value;

/**
 * 创号事件
 * @author hyx
 */
@Value(staticConstructor = "of")
public class CreateRoleEvent {

    private long rid;
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
     * 客户端类型0：IOS，1：安卓
     */
    private int loginType;
    /**
     * 登录时间
     */
    private int loginTime;
    /**
     * ip
     */
    private String ip;
    /**
     * 创号时间
     */
    private int bordTime;
    /**
     * 设备id
     */
    private String deviceId;
    /**
     * 渠道id
     */
    private String place;
}
