package com.ayjs.mxzg.gameserver.web.event;

import com.ayjs.mxzg.gameserver.web.constant.RechargeLevelInfo;
import lombok.Value;

import java.util.Set;

/**
 * 充值限制修改
 */
@Value(staticConstructor = "of")
public class RechargeLimitChangeEvent {
    /**
     * 总充值额度
     */
    long totalRecharge;
    /**
     * 限制的注册地区名
     */
    Set<String> areas;
    /**
     * 限制的登录地区名
     */
    Set<String> loginAreas;
    /**
     * 最新的充值等级限制信息
     */
    Set<RechargeLevelInfo> rechargeLevelInfos;
}
