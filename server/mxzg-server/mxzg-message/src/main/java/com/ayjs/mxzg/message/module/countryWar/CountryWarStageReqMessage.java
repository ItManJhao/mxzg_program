package com.ayjs.mxzg.message.module.countryWar;

import com.ayjs.mxzg.message.largecross.LargeCrossMessage;
import lombok.Value;

/**
 * @Author: CWJ
 * @Date: 2021/4/12
 **/
@Value(staticConstructor = "of")
public class CountryWarStageReqMessage implements LargeCrossMessage {
    private int serverId;
}
