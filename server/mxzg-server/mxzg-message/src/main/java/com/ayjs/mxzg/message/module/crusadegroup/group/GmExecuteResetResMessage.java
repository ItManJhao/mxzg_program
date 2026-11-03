package com.ayjs.mxzg.message.module.crusadegroup.group;

import com.ayjs.mxzg.message.largecross.CrusadeGroupMessage;
import lombok.Value;

/**
 * 重置返回
 */
@Value(staticConstructor = "valueOf")
public class GmExecuteResetResMessage implements CrusadeGroupMessage {

    //当前阶段
    private int stage;
}
