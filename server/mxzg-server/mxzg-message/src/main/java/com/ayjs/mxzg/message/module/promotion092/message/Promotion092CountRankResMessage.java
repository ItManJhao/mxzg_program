package com.ayjs.mxzg.message.module.promotion092.message;

import com.ayjs.mxzg.message.largecross.LargeCrossMessage;
import com.ayjs.mxzg.message.module.promotion092.struct.Promotion092Data;
import com.ayjs.rpc.RemoteMessage;
import lombok.Value;

import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2021/1/6
 **/
@Value(staticConstructor = "of")
public class Promotion092CountRankResMessage implements RemoteMessage {
    private List<Promotion092Data> rankDataList;
}
