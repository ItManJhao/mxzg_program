package com.ayjs.mxzg.message.module.countryWar;

import com.ayjs.rpc.RemoteMessage;
import lombok.Value;

import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2021/4/12
 **/
@Value(staticConstructor = "of")
public class CountryWarMarqueeResMessage implements RemoteMessage {
    private int idx;
    private List<String> param;
}
