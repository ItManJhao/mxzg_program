package com.ayjs.mxzg.message.module.countryWar;

import com.ayjs.rpc.RemoteMessage;
import lombok.Getter;
import lombok.Setter;

/**
 * @Author: CWJ
 * @Date: 2021/4/12
 **/
@Getter
@Setter
public class CountryWarMoveResMessage implements RemoteMessage {
    private byte[] data;
    private boolean costItem;
}
