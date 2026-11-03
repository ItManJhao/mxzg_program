package com.ayjs.mxzg.message.module.floatingIslands.message;

import com.ayjs.mxzg.message.largecross.LargeCrossMessage;
import lombok.Value;

/**
 * 更新排行榜数据
 *
 * @Author: CWJ
 * @Date: 2020/4/10
 **/
@Value(staticConstructor = "of")
public class FloatingIslandsGetRankMessage implements LargeCrossMessage {

    private int serverId;

}
