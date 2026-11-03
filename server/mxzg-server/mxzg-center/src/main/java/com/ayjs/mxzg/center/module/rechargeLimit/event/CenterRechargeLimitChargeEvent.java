package com.ayjs.mxzg.center.module.rechargeLimit.event;

import lombok.Value;

import java.util.Set;

/**
 * 充值限制条件修改
 */
@Value(staticConstructor = "of")
public class CenterRechargeLimitChargeEvent {
    /**
     * 总充值额度
     */
    int totalRecharge;
    /**
     * 限制的注册地区名
     */
    Set<String> areas;
    /**
     * 限制的登录地区名
     */
    Set<String> loginAreas;
}
