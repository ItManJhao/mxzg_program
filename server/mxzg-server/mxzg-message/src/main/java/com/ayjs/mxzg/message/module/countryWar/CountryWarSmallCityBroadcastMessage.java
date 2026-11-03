package com.ayjs.mxzg.message.module.countryWar;

import com.ayjs.rpc.RemoteMessage;
import lombok.Getter;
import lombok.Value;

import java.util.ArrayList;
import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2021/4/12
 **/
@Value(staticConstructor = "of")
@Getter
public class CountryWarSmallCityBroadcastMessage implements RemoteMessage {
    private List<byte[]> data = new ArrayList<>();
    private long rid;
}
