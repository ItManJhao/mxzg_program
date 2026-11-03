package com.ayjs.mxzg.message.module.countryWar;

import com.ayjs.rpc.RemoteMessage;
import lombok.Getter;
import lombok.Value;

/**
 * @Author: CWJ
 * @Date: 2021/4/12
 **/
@Value(staticConstructor = "of")
@Getter
public class CountryWarCityBroadcastMessage implements RemoteMessage {
    private byte[] data;
    private long rid;
}
