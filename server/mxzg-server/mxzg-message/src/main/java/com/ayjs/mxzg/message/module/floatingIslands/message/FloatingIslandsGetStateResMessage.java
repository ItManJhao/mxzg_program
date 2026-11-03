package com.ayjs.mxzg.message.module.floatingIslands.message;

import com.ayjs.mxzg.message.module.floatingIslands.struct.FloatingIslandsTime;
import com.ayjs.rpc.RemoteMessage;
import lombok.Value;

/**
 * 请求状态信息，跨服连接时
 *
 * @Author: CWJ
 * @Date: 2020/4/10
 **/
@Value(staticConstructor = "of")
public class FloatingIslandsGetStateResMessage implements RemoteMessage {

    private FloatingIslandsTime time;
}
