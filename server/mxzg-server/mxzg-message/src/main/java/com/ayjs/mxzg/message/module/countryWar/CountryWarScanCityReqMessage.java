package com.ayjs.mxzg.message.module.countryWar;

import com.ayjs.mxzg.message.largecross.PlayerLargeCrossMessage;
import lombok.Value;

/**
 * @Author: CWJ
 * @Date: 2021/4/12
 **/
@Value(staticConstructor = "of")
public class CountryWarScanCityReqMessage implements PlayerLargeCrossMessage {
    private int serverId;
    private long rid;

}
