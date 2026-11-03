package com.ayjs.mxzg.tools.client.client.network;

/**
 * 登录状态：未登录，未注册，已登录
 */
public enum ConnectStatus {
    /**
     * socket连接
     */
    CONNECT,

    /***
     * 登录游戏阶段
     */
    LOGIN_GAME,

    /***
     * 创角阶段
     */
    REGISTER_ROLE,

    /**
     * 角色登录阶段
     */
    LOGIN_ROLE,

    /**
     * 已登录
     */
    LOGGED_IN
}
