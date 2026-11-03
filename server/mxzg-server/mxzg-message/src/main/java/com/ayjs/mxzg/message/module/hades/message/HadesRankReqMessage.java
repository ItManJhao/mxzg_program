package com.ayjs.mxzg.message.module.hades.message;

import com.ayjs.mxzg.message.largecross.LargeCrossMessage;
import lombok.Value;

/**
 * 更新排行榜数据
 *
 * @Author: CWJ
 * @Date: 2020/4/10
 **/
@Value(staticConstructor = "of")
public class HadesRankReqMessage implements LargeCrossMessage {
    private int hadesType;
    private int serverId;
}
