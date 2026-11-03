package com.ayjs.mxzg.center.web.constant;

import lombok.Data;

import java.util.Set;

/**
 * ios充值限制条件
 */
@Data
public class CenterRechargeLimitInfo {
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
