package com.ayjs.mxzg.message.module.countryWar;

import com.ayjs.mxzg.message.largecross.LargeCrossMessage;
import lombok.Builder;
import lombok.Getter;

/**
 * @Author: CWJ
 * @Date: 2021/4/12
 **/
@Builder
@Getter
public class CountryWarGMReqMessage implements LargeCrossMessage {
    private int type;

    private int mainServerId;
}
