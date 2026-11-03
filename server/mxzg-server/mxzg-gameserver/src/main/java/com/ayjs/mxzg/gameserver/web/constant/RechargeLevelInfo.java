package com.ayjs.mxzg.gameserver.web.constant;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 充值等级设置信息
 */
@Data
@EqualsAndHashCode(of = "clientType")
public class RechargeLevelInfo {
    /**
     * 1:安卓，2:IOS，3:H5
     */
    private int clientType;
    /**
     * 角色等级
     */
    private int level;
    /**
     * 0关闭，1开启
     */
    private int isOpen;
}
