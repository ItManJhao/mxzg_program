package com.ayjs.mxzg.message.largecross;

import com.ayjs.rpc.RemoteMessage;
import lombok.Value;

/**
 * 超凡段位赛跨服连接成功
 *
 * @Author: CWJ
 * @Date: 2020/6/19
 **/
@Value(staticConstructor = "getInstance")
public class LargeServerConnectedMessage implements RemoteMessage {
}
