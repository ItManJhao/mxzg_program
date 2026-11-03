package com.ayjs.mxzg.message.module.crusadegroup.group;

import com.ayjs.mxzg.message.largecross.CrusadeGroupMessage;
import lombok.Value;

/**
 * 执行下一个阶段返回
 */
@Value(staticConstructor = "valueOf")
public class GmExecuteNextResMessage implements CrusadeGroupMessage {

    //当前阶段
    private int stage;
}
