package com.ayjs.mxzg.message.module.promotion092.message;

import com.ayjs.mxzg.message.module.promotion092.struct.Promotion092HeroData;
import com.ayjs.rpc.RemoteMessage;
import lombok.Value;

import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2021/1/6
 **/
@Value(staticConstructor = "of")
public class Promotion092HeroRankResMessage implements RemoteMessage {
    private List<Promotion092HeroData> rankDataList;
}
