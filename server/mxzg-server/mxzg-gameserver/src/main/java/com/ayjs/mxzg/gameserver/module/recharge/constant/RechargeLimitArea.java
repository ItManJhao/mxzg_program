package com.ayjs.mxzg.gameserver.module.recharge.constant;

import java.util.HashSet;
import java.util.Set;

/**
 * 充值屏蔽地区
 */
public interface RechargeLimitArea {
    /**
     * 特殊地区定义，若有修改，就建议放到配置文件中
     */
    Set<String> limitAreas = new HashSet<String>() {{
        add("广州市");
        add("深圳市");
    }};
}
