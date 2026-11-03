package com.ayjs.mxzg.message.module.rechargeLimit;

import com.ayjs.rpc.RemoteMessage;
import lombok.Value;

import java.util.Set;

/**
 * 跨服充值限制信息
 */
@Value(staticConstructor = "of")
public class ReposeCenterRechargeLimitMessage implements RemoteMessage {
    /**
     * 总充值额
     */
    long totalRecharge;
    /**
     * 限制注册地区信息
     */
    Set<String> areas;
    /**
     * 限制的登录地区信息
     */
    Set<String> loginAreas;
}
