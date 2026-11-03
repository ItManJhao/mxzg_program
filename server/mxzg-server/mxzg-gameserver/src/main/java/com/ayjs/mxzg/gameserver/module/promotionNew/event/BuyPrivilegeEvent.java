package com.ayjs.mxzg.gameserver.module.promotionNew.event;

import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PrivilegeType;
import lombok.Value;

/**
 * 购买特权事件
 * @author hyx
 */
@Value(staticConstructor = "of")
public class BuyPrivilegeEvent {
    private long rid;
    private PrivilegeType privilegeType;
}
