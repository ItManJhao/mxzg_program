package com.ayjs.mxzg.largecross.module.countryWar.event;

import com.ayjs.mxzg.largecross.module.countryWar.domain.CountryWarRole;
import lombok.Value;

/**
 * @Author: CWJ
 * @Date: 2021/4/26
 **/
@Value(staticConstructor = "of")
public class CountryWarDefendSuccessEvent {
    private CountryWarRole defend;
    private CountryWarRole attack;
    private int idx;
}
