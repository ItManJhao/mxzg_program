package com.ayjs.mxzg.message.module.rechargeLimit;

import com.ayjs.mxzg.message.center.CenterServerMessage;
import lombok.Value;

/**
 * 请求跨服充值限制信息
 */
@Value(staticConstructor = "of")
public class RequestCenterRechargeLimitMessage implements CenterServerMessage {
}
