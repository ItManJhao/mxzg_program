package com.ayjs.mxzg.message.module.countryWar;

import com.ayjs.mxzg.message.largecross.PlayerLargeCrossMessage;
import lombok.Value;

/**
 * @Author: CWJ
 * @Date: 2021/4/12
 **/
@Value(staticConstructor = "of")
public class CountryWarRoleLogReqMessage implements PlayerLargeCrossMessage {
    private long rid;

}
