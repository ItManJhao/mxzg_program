package com.ayjs.mxzg.gameserver.web.event;

import com.ayjs.mxzg.gameserver.module.recharge.domain.Recharge;
import lombok.Value;

import java.util.Map;

/**
 * 充值回调事件
 */
@Value(staticConstructor = "of")
public class ReChargeCallbackEvent {
    /**
     * 订单信息
     * 数据不要做修改
     */
    private Recharge recharge;
    // 扩展信息
    private Map<String, String> extraDataMap;
}
