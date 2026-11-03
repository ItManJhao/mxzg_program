package com.ayjs.mxzg.message.module.floatingIslands.message;

import com.ayjs.rpc.RemoteMessage;
import lombok.Getter;
import lombok.Value;

/**
 * 请求状态信息，跨服连接时
 *
 * @Author: CWJ
 * @Date: 2020/4/10
 **/
@Getter
@Value(staticConstructor = "of")
public class FloatingIslandsChallengeResMessage implements RemoteMessage {

    private int code;

    private long totalDmg;

}
