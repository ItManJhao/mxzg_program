package com.ayjs.mxzg.message.module.floatingIslands.message;

import com.ayjs.mxzg.message.largecross.LargeCrossMessage;
import lombok.Value;

/**
 * gm设置状态
 *
 * @Author: CWJ
 * @Date: 2020/4/10
 **/
@Value(staticConstructor = "of")
public class FloatingIslandsGMMessage implements LargeCrossMessage {
    private int stage;
}
