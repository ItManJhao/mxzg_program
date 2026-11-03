package com.ayjs.mxzg.message.module.countryWar;

import com.ayjs.rpc.RemoteMessage;
import lombok.Value;

/**
 * @Author: CWJ
 * @Date: 2021/4/12
 **/
@Value(staticConstructor = "of")
public class CountryWarRandomShopBuyResMessage implements RemoteMessage {
    private boolean buySuccess;

}
