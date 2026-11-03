package com.ayjs.mxzg.gameserver.module.server.struct;

import com.ayjs.mxzg.gameserver.web.constant.RechargeLevelInfo;
import lombok.Data;

import java.util.Set;

/**
 * 充值限制条件
 */
@Data
public class RechargeLimit {
    /**
     * 总充值额度
     */
    long totalRecharge;
    /**
     * 限制的注册地区名
     */
    Set<String> areas;
    /**
     * 登录地区
     */
    Set<String> loginAreas;

    Set<RechargeLevelInfo> levelInfos;
}
